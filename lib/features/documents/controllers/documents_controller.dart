import 'dart:async';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/pdf/checklist_inspection_pdf_generator.dart';
import 'package:havena/core/pdf/contrat_abonnement_pdf_generator.dart';
import 'package:havena/core/pdf/devis_pdf_generator.dart';
import 'package:havena/core/pdf/facture_pdf_generator.dart';
import 'package:havena/core/pdf/fiche_client_pdf_generator.dart';
import 'package:havena/core/pdf/fiche_intervention_pdf_generator.dart';
import 'package:havena/core/pdf/fiche_logement_pdf_generator.dart';
import 'package:havena/core/pdf/fiche_prestataire_pdf_generator.dart';
import 'package:havena/core/pdf/procedure_coordinateur_pdf_generator.dart';
import 'package:havena/core/pdf/recu_pdf_generator.dart';
import 'package:havena/features/abonnements/repositories/abonnements_repository.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/finances/repositories/finances_repository.dart';
import 'package:havena/features/inspections/repositories/inspection_items_repository.dart';
import 'package:havena/features/inspections/repositories/inspections_repository.dart';
import 'package:havena/features/interventions/repositories/interventions_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';
import 'package:havena/features/prestataires/repositories/prestataires_repository.dart';
import 'package:printing/printing.dart';

/// Types de documents du dossier « 09 — MODÈLES » (cahier des charges §17),
/// à l'exception du rapport mensuel qui a son propre module.
enum DocumentKind {
  ficheClient,
  ficheLogement,
  ficheIntervention,
  fichePrestataire,
  checklistInspection,
  devis,
  facture,
  recu,
  contratAbonnement,
  procedureCoordinateur,
}

const Map<DocumentKind, String> documentKindLabels = {
  DocumentKind.ficheClient: 'Fiche client',
  DocumentKind.ficheLogement: 'Fiche logement',
  DocumentKind.ficheIntervention: 'Fiche intervention',
  DocumentKind.fichePrestataire: 'Fiche prestataire',
  DocumentKind.checklistInspection: "Checklist d'inspection",
  DocumentKind.devis: 'Devis',
  DocumentKind.facture: 'Facture',
  DocumentKind.recu: 'Reçu de paiement',
  DocumentKind.contratAbonnement: "Contrat d'abonnement",
  DocumentKind.procedureCoordinateur: 'Procédure coordinateur',
};

class EntityOption {
  const EntityOption(this.id, this.label);

  final int id;
  final String label;
}

class DocumentsController extends GetxController {
  DocumentsController({
    required ClientsRepository clientsRepository,
    required LogementsRepository logementsRepository,
    required InterventionsRepository interventionsRepository,
    required PrestatairesRepository prestatairesRepository,
    required AbonnementsRepository abonnementsRepository,
    required FinancesRepository financesRepository,
    required InspectionsRepository inspectionsRepository,
    required InspectionItemsRepository inspectionItemsRepository,
  })  : _clientsRepository = clientsRepository,
        _logementsRepository = logementsRepository,
        _interventionsRepository = interventionsRepository,
        _prestatairesRepository = prestatairesRepository,
        _abonnementsRepository = abonnementsRepository,
        _financesRepository = financesRepository,
        _inspectionsRepository = inspectionsRepository,
        _inspectionItemsRepository = inspectionItemsRepository;

  final ClientsRepository _clientsRepository;
  final LogementsRepository _logementsRepository;
  final InterventionsRepository _interventionsRepository;
  final PrestatairesRepository _prestatairesRepository;
  final AbonnementsRepository _abonnementsRepository;
  final FinancesRepository _financesRepository;
  final InspectionsRepository _inspectionsRepository;
  final InspectionItemsRepository _inspectionItemsRepository;

  final selectedKind = DocumentKind.ficheClient.obs;
  final selectedEntityId = Rxn<int>();
  final isGenerating = false.obs;
  final error = Rxn<String>();

  final clients = <Client>[].obs;
  final logements = <Logement>[].obs;
  final interventions = <Intervention>[].obs;
  final prestataires = <Prestataire>[].obs;
  final abonnements = <Abonnement>[].obs;
  final finances = <Finance>[].obs;
  final inspections = <Inspection>[].obs;

  final List<StreamSubscription<dynamic>> _subs = [];

  @override
  void onInit() {
    super.onInit();
    _subs.addAll([
      _clientsRepository.watchAll().listen((v) => clients.value = v),
      _logementsRepository.watchAll().listen((v) => logements.value = v),
      _interventionsRepository
          .watchAll()
          .listen((v) => interventions.value = v),
      _prestatairesRepository.watchAll().listen((v) => prestataires.value = v),
      _abonnementsRepository.watchAll().listen((v) => abonnements.value = v),
      _financesRepository.watchAll().listen((v) => finances.value = v),
      _inspectionsRepository.watchAll().listen((v) => inspections.value = v),
    ]);
  }

  @override
  void onClose() {
    for (final sub in _subs) {
      sub.cancel();
    }
    super.onClose();
  }

  bool get needsEntity =>
      selectedKind.value != DocumentKind.procedureCoordinateur;

  void selectKind(DocumentKind kind) {
    selectedKind.value = kind;
    selectedEntityId.value = null;
    error.value = null;
  }

  List<EntityOption> get entityOptions {
    switch (selectedKind.value) {
      case DocumentKind.ficheClient:
        return clients
            .map((c) => EntityOption(c.id, '${c.reference} - ${c.fullName}'))
            .toList();
      case DocumentKind.ficheLogement:
        return logements
            .map((l) => EntityOption(l.id, '${l.reference} - ${l.address}'))
            .toList();
      case DocumentKind.fichePrestataire:
        return prestataires
            .map((p) => EntityOption(p.id, '${p.reference} - ${p.fullName}'))
            .toList();
      case DocumentKind.ficheIntervention:
      case DocumentKind.devis:
      case DocumentKind.facture:
        return interventions
            .map((i) =>
                EntityOption(i.id, '${i.reference} - ${i.problemDescription}'))
            .toList();
      case DocumentKind.recu:
        return finances
            .map((f) => EntityOption(f.id, '${f.reference} - ${f.description}'))
            .toList();
      case DocumentKind.contratAbonnement:
        return abonnements
            .map((a) => EntityOption(a.id, '${a.reference} - ${a.formula}'))
            .toList();
      case DocumentKind.checklistInspection:
        return inspections
            .map((i) => EntityOption(
                i.id, '${i.reference} - ${_formatDate(i.inspectionDate)}'))
            .toList();
      case DocumentKind.procedureCoordinateur:
        return const [];
    }
  }

  Client? _clientById(int? id) {
    if (id == null) return null;
    for (final c in clients) {
      if (c.id == id) return c;
    }
    return null;
  }

  Logement? _logementById(int? id) {
    if (id == null) return null;
    for (final l in logements) {
      if (l.id == id) return l;
    }
    return null;
  }

  Prestataire? _prestataireById(int? id) {
    if (id == null) return null;
    for (final p in prestataires) {
      if (p.id == id) return p;
    }
    return null;
  }

  Intervention? _interventionById(int? id) {
    if (id == null) return null;
    for (final i in interventions) {
      if (i.id == id) return i;
    }
    return null;
  }

  Finance? _financeById(int? id) {
    if (id == null) return null;
    for (final f in finances) {
      if (f.id == id) return f;
    }
    return null;
  }

  Abonnement? _abonnementById(int? id) {
    if (id == null) return null;
    for (final a in abonnements) {
      if (a.id == id) return a;
    }
    return null;
  }

  Inspection? _inspectionById(int? id) {
    if (id == null) return null;
    for (final i in inspections) {
      if (i.id == id) return i;
    }
    return null;
  }

  Future<void> generateAndPreview() async {
    if (isGenerating.value) return;
    error.value = null;

    if (needsEntity && selectedEntityId.value == null) {
      error.value = 'Veuillez sélectionner un élément.';
      return;
    }

    isGenerating.value = true;
    try {
      final Uint8List bytes = await _buildBytes();
      await Printing.layoutPdf(onLayout: (format) async => bytes);
    } catch (e) {
      error.value = 'Erreur lors de la génération du document : $e';
    } finally {
      isGenerating.value = false;
    }
  }

  /// Génère directement le document d'un type et d'une entité donnés
  /// (retour utilisateur : un bouton « Générer le document » dans chaque
  /// drawer de détail, sans passer par les menus déroulants de la page
  /// Documents).
  Future<void> generateAndPreviewFor(DocumentKind kind, int entityId) async {
    selectedKind.value = kind;
    selectedEntityId.value = entityId;
    await generateAndPreview();
  }

  Future<Uint8List> _buildBytes() async {
    switch (selectedKind.value) {
      case DocumentKind.ficheClient:
        final client = _clientById(selectedEntityId.value);
        if (client == null) throw Exception('Client introuvable');
        return FicheClientPdfGenerator.generate(client: client);

      case DocumentKind.ficheLogement:
        final logement = _logementById(selectedEntityId.value);
        if (logement == null) throw Exception('Logement introuvable');
        final clientName = _clientById(logement.clientId)?.fullName;
        return FicheLogementPdfGenerator.generate(
            logement: logement, clientName: clientName);

      case DocumentKind.fichePrestataire:
        final prestataire = _prestataireById(selectedEntityId.value);
        if (prestataire == null) throw Exception('Prestataire introuvable');
        return FichePrestatairePdfGenerator.generate(prestataire: prestataire);

      case DocumentKind.ficheIntervention:
      case DocumentKind.devis:
      case DocumentKind.facture:
        final intervention = _interventionById(selectedEntityId.value);
        if (intervention == null) throw Exception('Intervention introuvable');
        final logement = _logementById(intervention.logementId);
        if (logement == null) throw Exception('Logement introuvable');
        final clientName = _clientById(intervention.clientId)?.fullName;
        final prestataireName =
            _prestataireById(intervention.prestataireId)?.fullName;
        if (selectedKind.value == DocumentKind.devis) {
          return DevisPdfGenerator.generate(
            intervention: intervention,
            logement: logement,
            clientName: clientName,
            prestataireName: prestataireName,
          );
        }
        if (selectedKind.value == DocumentKind.facture) {
          return FacturePdfGenerator.generate(
            intervention: intervention,
            logement: logement,
            clientName: clientName,
          );
        }
        return FicheInterventionPdfGenerator.generate(
          intervention: intervention,
          logement: logement,
          clientName: clientName,
          prestataireName: prestataireName,
        );

      case DocumentKind.recu:
        final finance = _financeById(selectedEntityId.value);
        if (finance == null) throw Exception('Transaction introuvable');
        final clientName = _clientById(finance.relatedClientId)?.fullName;
        final prestataireName =
            _prestataireById(finance.relatedPrestataireId)?.fullName;
        return RecuPdfGenerator.generate(
          finance: finance,
          clientName: clientName,
          prestataireName: prestataireName,
        );

      case DocumentKind.contratAbonnement:
        final abonnement = _abonnementById(selectedEntityId.value);
        if (abonnement == null) throw Exception('Abonnement introuvable');
        final client = _clientById(abonnement.clientId);
        final logement = _logementById(abonnement.logementId);
        if (client == null || logement == null) {
          throw Exception('Client ou logement introuvable');
        }
        return ContratAbonnementPdfGenerator.generate(
          abonnement: abonnement,
          client: client,
          logement: logement,
        );

      case DocumentKind.checklistInspection:
        final inspection = _inspectionById(selectedEntityId.value);
        if (inspection == null) throw Exception('Inspection introuvable');
        final logement = _logementById(inspection.logementId);
        if (logement == null) throw Exception('Logement introuvable');
        final items = await _inspectionItemsRepository
            .watchByInspection(inspection.id)
            .first;
        return ChecklistInspectionPdfGenerator.generate(
          inspection: inspection,
          logement: logement,
          items: items,
        );

      case DocumentKind.procedureCoordinateur:
        return ProcedureCoordinateurPdfGenerator.generate();
    }
  }

  String _formatDate(DateTime d) {
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    return '$day/$month/${d.year}';
  }
}
