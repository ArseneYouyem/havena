import 'dart:async';

import 'package:get/get.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/features/abonnements/repositories/abonnements_repository.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/finances/repositories/finances_repository.dart';
import 'package:havena/features/inspections/repositories/inspections_repository.dart';
import 'package:havena/features/interventions/repositories/interventions_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';
import 'package:havena/features/prestataires/repositories/prestataires_repository.dart';
import 'package:havena/features/rapports/repositories/rapports_repository.dart';

/// Types d'entités portant une référence HAVENA (HAV-XXX-000001),
/// cahier des charges §4/§9 — recherche transversale.
enum ReferenceEntityType {
  client,
  logement,
  abonnement,
  intervention,
  prestataire,
  finance,
  rapport,
  inspection,
}

const Map<ReferenceEntityType, String> referenceTypeLabels = {
  ReferenceEntityType.client: 'Client',
  ReferenceEntityType.logement: 'Logement',
  ReferenceEntityType.abonnement: 'Abonnement',
  ReferenceEntityType.intervention: 'Intervention',
  ReferenceEntityType.prestataire: 'Prestataire',
  ReferenceEntityType.finance: 'Finance',
  ReferenceEntityType.rapport: 'Rapport',
  ReferenceEntityType.inspection: 'Inspection',
};

class ReferenceSearchResult {
  const ReferenceSearchResult({
    required this.type,
    required this.id,
    required this.reference,
    required this.label,
  });

  final ReferenceEntityType type;
  final int id;
  final String reference;
  final String label;
}

/// Ne crée aucun repository : réutilise ceux déjà enregistrés par les
/// bindings des autres modules métier (doit donc être déclarée après eux
/// dans `AppPages`). Alimente la recherche globale accessible depuis la
/// topbar (`ReferenceSearchField`).
class ReferenceSearchController extends GetxController {
  ReferenceSearchController({
    required ClientsRepository clientsRepository,
    required LogementsRepository logementsRepository,
    required AbonnementsRepository abonnementsRepository,
    required InterventionsRepository interventionsRepository,
    required PrestatairesRepository prestatairesRepository,
    required FinancesRepository financesRepository,
    required RapportsRepository rapportsRepository,
    required InspectionsRepository inspectionsRepository,
  })  : _clientsRepository = clientsRepository,
        _logementsRepository = logementsRepository,
        _abonnementsRepository = abonnementsRepository,
        _interventionsRepository = interventionsRepository,
        _prestatairesRepository = prestatairesRepository,
        _financesRepository = financesRepository,
        _rapportsRepository = rapportsRepository,
        _inspectionsRepository = inspectionsRepository;

  final ClientsRepository _clientsRepository;
  final LogementsRepository _logementsRepository;
  final AbonnementsRepository _abonnementsRepository;
  final InterventionsRepository _interventionsRepository;
  final PrestatairesRepository _prestatairesRepository;
  final FinancesRepository _financesRepository;
  final RapportsRepository _rapportsRepository;
  final InspectionsRepository _inspectionsRepository;

  final clients = <Client>[].obs;
  final logements = <Logement>[].obs;
  final abonnements = <Abonnement>[].obs;
  final interventions = <Intervention>[].obs;
  final prestataires = <Prestataire>[].obs;
  final finances = <Finance>[].obs;
  final rapports = <Rapport>[].obs;
  final inspections = <Inspection>[].obs;

  final List<StreamSubscription<dynamic>> _subs = [];

  @override
  void onInit() {
    super.onInit();
    _subs.addAll([
      _clientsRepository.watchAll().listen((v) => clients.value = v),
      _logementsRepository.watchAll().listen((v) => logements.value = v),
      _abonnementsRepository.watchAll().listen((v) => abonnements.value = v),
      _interventionsRepository
          .watchAll()
          .listen((v) => interventions.value = v),
      _prestatairesRepository.watchAll().listen((v) => prestataires.value = v),
      _financesRepository.watchAll().listen((v) => finances.value = v),
      _rapportsRepository.watchAll().listen((v) => rapports.value = v),
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

  List<ReferenceSearchResult> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const [];

    final results = <ReferenceSearchResult>[];
    for (final c in clients) {
      if (c.reference.toLowerCase().contains(q) ||
          c.fullName.toLowerCase().contains(q)) {
        results.add(_clientResult(c));
      }
    }
    for (final l in logements) {
      if (l.reference.toLowerCase().contains(q) ||
          l.address.toLowerCase().contains(q)) {
        results.add(_logementResult(l));
      }
    }
    for (final a in abonnements) {
      if (a.reference.toLowerCase().contains(q) ||
          a.formula.toLowerCase().contains(q)) {
        results.add(_abonnementResult(a));
      }
    }
    for (final i in interventions) {
      if (i.reference.toLowerCase().contains(q) ||
          i.problemDescription.toLowerCase().contains(q)) {
        results.add(_interventionResult(i));
      }
    }
    for (final p in prestataires) {
      if (p.reference.toLowerCase().contains(q) ||
          p.fullName.toLowerCase().contains(q)) {
        results.add(_prestataireResult(p));
      }
    }
    for (final f in finances) {
      if (f.reference.toLowerCase().contains(q) ||
          f.description.toLowerCase().contains(q)) {
        results.add(_financeResult(f));
      }
    }
    for (final r in rapports) {
      if (r.reference.toLowerCase().contains(q) ||
          r.periodMonth.toLowerCase().contains(q)) {
        results.add(_rapportResult(r));
      }
    }
    for (final i in inspections) {
      if (i.reference.toLowerCase().contains(q)) {
        results.add(_inspectionResult(i));
      }
    }
    return results;
  }

  List<ReferenceSearchResult> relatedFor(ReferenceSearchResult result) {
    switch (result.type) {
      case ReferenceEntityType.client:
        final related = <ReferenceSearchResult>[];
        related.addAll(
            logements.where((l) => l.clientId == result.id).map(_logementResult));
        related.addAll(abonnements
            .where((a) => a.clientId == result.id)
            .map(_abonnementResult));
        related.addAll(interventions
            .where((i) => i.clientId == result.id)
            .map(_interventionResult));
        return related;

      case ReferenceEntityType.logement:
        final related = <ReferenceSearchResult>[];
        final logement = _logementById(result.id);
        if (logement != null) {
          final client = _clientById(logement.clientId);
          if (client != null) related.add(_clientResult(client));
        }
        related.addAll(abonnements
            .where((a) => a.logementId == result.id)
            .map(_abonnementResult));
        related.addAll(inspections
            .where((i) => i.logementId == result.id)
            .map(_inspectionResult));
        related.addAll(interventions
            .where((i) => i.logementId == result.id)
            .map(_interventionResult));
        related.addAll(rapports
            .where((r) => r.logementId == result.id)
            .map(_rapportResult));
        return related;

      case ReferenceEntityType.abonnement:
        final related = <ReferenceSearchResult>[];
        final abonnement = _abonnementById(result.id);
        if (abonnement != null) {
          final client = _clientById(abonnement.clientId);
          if (client != null) related.add(_clientResult(client));
          final logement = _logementById(abonnement.logementId);
          if (logement != null) related.add(_logementResult(logement));
        }
        return related;

      case ReferenceEntityType.intervention:
        final related = <ReferenceSearchResult>[];
        final intervention = _interventionById(result.id);
        if (intervention != null) {
          final logement = _logementById(intervention.logementId);
          if (logement != null) related.add(_logementResult(logement));
          final client = _clientById(intervention.clientId);
          if (client != null) related.add(_clientResult(client));
          final prestataire = _prestataireById(intervention.prestataireId);
          if (prestataire != null) related.add(_prestataireResult(prestataire));
        }
        return related;

      case ReferenceEntityType.prestataire:
        return interventions
            .where((i) => i.prestataireId == result.id)
            .map(_interventionResult)
            .toList();

      case ReferenceEntityType.finance:
        final related = <ReferenceSearchResult>[];
        final finance = _financeById(result.id);
        if (finance != null) {
          final client = _clientById(finance.relatedClientId);
          if (client != null) related.add(_clientResult(client));
          final prestataire = _prestataireById(finance.relatedPrestataireId);
          if (prestataire != null) related.add(_prestataireResult(prestataire));
        }
        return related;

      case ReferenceEntityType.rapport:
        final related = <ReferenceSearchResult>[];
        final rapport = _rapportById(result.id);
        if (rapport != null) {
          final logement = _logementById(rapport.logementId);
          if (logement != null) related.add(_logementResult(logement));
        }
        return related;

      case ReferenceEntityType.inspection:
        final related = <ReferenceSearchResult>[];
        final inspection = _inspectionById(result.id);
        if (inspection != null) {
          final logement = _logementById(inspection.logementId);
          if (logement != null) related.add(_logementResult(logement));
        }
        return related;
    }
  }

  List<MapEntry<String, String>> detailsFor(ReferenceSearchResult result) {
    switch (result.type) {
      case ReferenceEntityType.client:
        final c = _clientById(result.id);
        if (c == null) return const [];
        return [
          MapEntry('Nom complet', c.fullName),
          MapEntry('Téléphone', c.phone),
          MapEntry('Ville', c.city),
          MapEntry('Statut', c.status.name),
        ];
      case ReferenceEntityType.logement:
        final l = _logementById(result.id);
        if (l == null) return const [];
        return [
          MapEntry('Adresse', l.address),
          MapEntry('État général', l.generalCondition?.name ?? 'Non renseigné'),
        ];
      case ReferenceEntityType.abonnement:
        final a = _abonnementById(result.id);
        if (a == null) return const [];
        return [
          MapEntry('Formule', a.formula),
          MapEntry('Prix mensuel', '${a.monthlyPrice.toStringAsFixed(2)} FCFA'),
          MapEntry('Statut paiement', a.paymentStatus.name),
        ];
      case ReferenceEntityType.intervention:
        final i = _interventionById(result.id);
        if (i == null) return const [];
        return [
          MapEntry('Problème', i.problemDescription),
          MapEntry('Urgence', i.urgencyLevel.name),
          MapEntry('Statut', i.status.name),
        ];
      case ReferenceEntityType.prestataire:
        final p = _prestataireById(result.id);
        if (p == null) return const [];
        return [
          MapEntry('Spécialité', p.specialty),
          MapEntry('Statut', p.status.name),
          MapEntry('Interventions', '${p.interventionsCount}'),
        ];
      case ReferenceEntityType.finance:
        final f = _financeById(result.id);
        if (f == null) return const [];
        return [
          MapEntry('Description', f.description),
          MapEntry('Montant', '${f.amount.toStringAsFixed(2)} FCFA'),
          MapEntry('Type', f.transactionType.name),
          MapEntry('Statut', f.status.name),
        ];
      case ReferenceEntityType.rapport:
        final r = _rapportById(result.id);
        if (r == null) return const [];
        return [
          MapEntry('Période', r.periodMonth),
          MapEntry('État général', r.generalCondition?.name ?? 'Non renseigné'),
        ];
      case ReferenceEntityType.inspection:
        final i = _inspectionById(result.id);
        if (i == null) return const [];
        return [
          MapEntry('Date', _formatDate(i.inspectionDate)),
          MapEntry(
              'État général', i.generalCondition?.name ?? 'Non renseigné'),
          MapEntry('Validée', i.isValidated ? '[Oui]' : '[Non]'),
        ];
    }
  }

  ReferenceSearchResult _clientResult(Client c) => ReferenceSearchResult(
      type: ReferenceEntityType.client,
      id: c.id,
      reference: c.reference,
      label: c.fullName);

  ReferenceSearchResult _logementResult(Logement l) => ReferenceSearchResult(
      type: ReferenceEntityType.logement,
      id: l.id,
      reference: l.reference,
      label: l.address);

  ReferenceSearchResult _abonnementResult(Abonnement a) => ReferenceSearchResult(
      type: ReferenceEntityType.abonnement,
      id: a.id,
      reference: a.reference,
      label: a.formula);

  ReferenceSearchResult _interventionResult(Intervention i) =>
      ReferenceSearchResult(
          type: ReferenceEntityType.intervention,
          id: i.id,
          reference: i.reference,
          label: i.problemDescription);

  ReferenceSearchResult _prestataireResult(Prestataire p) =>
      ReferenceSearchResult(
          type: ReferenceEntityType.prestataire,
          id: p.id,
          reference: p.reference,
          label: p.fullName);

  ReferenceSearchResult _financeResult(Finance f) => ReferenceSearchResult(
      type: ReferenceEntityType.finance,
      id: f.id,
      reference: f.reference,
      label: f.description);

  ReferenceSearchResult _rapportResult(Rapport r) => ReferenceSearchResult(
      type: ReferenceEntityType.rapport,
      id: r.id,
      reference: r.reference,
      label: r.periodMonth);

  ReferenceSearchResult _inspectionResult(Inspection i) =>
      ReferenceSearchResult(
          type: ReferenceEntityType.inspection,
          id: i.id,
          reference: i.reference,
          label: _formatDate(i.inspectionDate));

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

  Abonnement? _abonnementById(int? id) {
    if (id == null) return null;
    for (final a in abonnements) {
      if (a.id == id) return a;
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

  Prestataire? _prestataireById(int? id) {
    if (id == null) return null;
    for (final p in prestataires) {
      if (p.id == id) return p;
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

  Rapport? _rapportById(int? id) {
    if (id == null) return null;
    for (final r in rapports) {
      if (r.id == id) return r;
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

  String _formatDate(DateTime d) {
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    return '$day/$month/${d.year}';
  }
}
