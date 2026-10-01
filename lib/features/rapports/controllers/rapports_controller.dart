import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/pdf/rapport_pdf_generator.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/finances/repositories/finances_repository.dart';
import 'package:havena/features/inspections/repositories/inspection_items_repository.dart';
import 'package:havena/features/inspections/repositories/inspections_repository.dart';
import 'package:havena/features/interventions/repositories/interventions_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';
import 'package:havena/features/photos/repositories/photos_repository.dart';
import 'package:havena/features/rapports/repositories/rapports_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

class RapportsController extends GetxController {
  RapportsController(
    this._repository,
    this._logementsRepository,
    this._clientsRepository,
    this._sessionController,
    this._interventionsRepository,
    this._inspectionsRepository,
    this._inspectionItemsRepository,
    this._photosRepository,
    this._financesRepository,
  );

  final RapportsRepository _repository;
  final LogementsRepository _logementsRepository;
  final ClientsRepository _clientsRepository;
  final SessionController _sessionController;
  final InterventionsRepository _interventionsRepository;
  final InspectionsRepository _inspectionsRepository;
  final InspectionItemsRepository _inspectionItemsRepository;
  final PhotosRepository _photosRepository;
  final FinancesRepository _financesRepository;

  final rapports = <Rapport>[].obs;
  final logements = <Logement>[].obs;
  final clients = <Client>[].obs;
  final searchQuery = ''.obs;

  /// Mois affiché (format YYYY-MM) — retour utilisateur : la génération est
  /// désormais 100% automatique pour tous les logements d'un coup, l'user
  /// choisit juste le mois. Présélectionné sur le mois précédent (un
  /// rapport ne peut être généré que pour un mois déjà terminé, voir
  /// `canGenerateForSelectedMonth`).
  final selectedMonth = ''.obs;

  final isSaving = false.obs;
  final formError = Rxn<String>();
  final generatingIds = RxSet<int>();

  StreamSubscription<List<Rapport>>? _rapportsSub;
  StreamSubscription<List<Logement>>? _logementsSub;
  StreamSubscription<List<Client>>? _clientsSub;

  @override
  void onInit() {
    super.onInit();
    _rapportsSub = _repository.watchAll().listen((data) {
      rapports.value = data;
    });
    _logementsSub = _logementsRepository.watchAll().listen((data) {
      logements.value = data;
    });
    _clientsSub = _clientsRepository.watchAll().listen((data) {
      clients.value = data;
    });
    selectedMonth.value = _monthKey(_previousMonth(DateTime.now()));
  }

  @override
  void onClose() {
    _rapportsSub?.cancel();
    _logementsSub?.cancel();
    _clientsSub?.cancel();
    super.onClose();
  }

  String _monthKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}';

  DateTime _previousMonth(DateTime date) => DateTime(date.year, date.month - 1);

  void goToPreviousMonth() {
    final parts = selectedMonth.value.split('-');
    final current = DateTime(int.parse(parts[0]), int.parse(parts[1]));
    selectedMonth.value = _monthKey(DateTime(current.year, current.month - 1));
  }

  void goToNextMonth() {
    final parts = selectedMonth.value.split('-');
    final current = DateTime(int.parse(parts[0]), int.parse(parts[1]));
    selectedMonth.value = _monthKey(DateTime(current.year, current.month + 1));
  }

  /// Un rapport ne peut être généré que pour un mois déjà terminé (retour
  /// utilisateur) : le bouton reste masqué pour le mois courant (et tout
  /// mois futur, atteignable via la flèche suivante).
  bool get canGenerateForSelectedMonth =>
      selectedMonth.value.compareTo(_monthKey(DateTime.now())) < 0;

  T? _firstWhereOrNull<T>(Iterable<T> items, bool Function(T) test) {
    for (final item in items) {
      if (test(item)) return item;
    }
    return null;
  }

  String logementLabelFor(int? id) {
    if (id == null) return '';
    final logement = _firstWhereOrNull(logements, (l) => l.id == id);
    return logement?.address ?? 'Logement introuvable';
  }

  String logementReferenceFor(int? id) {
    if (id == null) return '';
    final logement = _firstWhereOrNull(logements, (l) => l.id == id);
    return logement?.reference ?? '';
  }

  /// Client du logement (retour utilisateur : affiché sur chaque rapport).
  /// Nom et référence séparés pour que la référence porte sa propre icône
  /// de copie, indépendamment du nom.
  Client? _clientForLogement(int? logementId) {
    if (logementId == null) return null;
    final logement = _firstWhereOrNull(logements, (l) => l.id == logementId);
    if (logement?.clientId == null) return null;
    return _firstWhereOrNull(clients, (c) => c.id == logement!.clientId);
  }

  String clientNameFor(int? logementId) =>
      _clientForLogement(logementId)?.fullName ?? '';

  String clientReferenceFor(int? logementId) =>
      _clientForLogement(logementId)?.reference ?? '';

  /// Rapports du mois sélectionné (retour utilisateur : la page affiche les
  /// rapports mois par mois), recherche texte appliquée en plus.
  List<Rapport> visibleRapports() {
    final period = selectedMonth.value;
    var list = rapports.where((r) => r.periodMonth == period).toList();
    final query = searchQuery.value.toLowerCase().trim();
    if (query.isNotEmpty) {
      list = list
          .where((rapport) =>
              rapport.reference.toLowerCase().contains(query))
          .toList();
    }
    return list;
  }

  /// Génère automatiquement, pour CHAQUE logement, le rapport du mois
  /// sélectionné (retour utilisateur : plus de saisie manuelle, le système
  /// a déjà toutes les informations nécessaires — inspections,
  /// interventions, dépenses du client). Un logement déjà rapporté ce mois
  /// voit son rapport recalculé (mêmes informations qu'une nouvelle
  /// génération), sans dupliquer la ligne ni perdre son éventuel PDF déjà
  /// généré (conservé par `RapportsRepository.update`).
  Future<void> generateReportsForSelectedMonth() async {
    if (!canGenerateForSelectedMonth || isSaving.value) return;

    isSaving.value = true;
    formError.value = null;
    try {
      final period = selectedMonth.value;
      final parts = period.split('-');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      bool inPeriod(DateTime? date) =>
          date != null && date.year == year && date.month == month;

      final currentUid = _sessionController.session.value?.uid ?? 'system';
      final allInterventions =
          await _interventionsRepository.watchAll().first;
      final allInspections = await _inspectionsRepository.watchAll().first;
      final allFinances = await _financesRepository.watchAll().first;

      for (final logement in logements.toList()) {
        final monthInterventions = allInterventions
            .where((i) =>
                i.logementId == logement.id && inPeriod(i.interventionDate))
            .toList();
        final interventionsDoneValue = monthInterventions.isEmpty
            ? null
            : monthInterventions
                .map((i) => '${i.reference} — ${i.problemDescription}')
                .join('\n');

        final monthInspections = allInspections
            .where((i) =>
                i.logementId == logement.id && inPeriod(i.inspectionDate))
            .toList()
          ..sort((a, b) => b.inspectionDate.compareTo(a.inspectionDate));
        final inspectionDoneValue = monthInspections.any((i) => i.isValidated);

        HousingCondition? generalConditionValue;
        String? recommendationsValue;
        String? anomaliesValue;
        if (monthInspections.isNotEmpty) {
          final latest = monthInspections.first;
          generalConditionValue = latest.generalCondition;
          recommendationsValue = latest.recommendations;

          final problems = <String>[];
          for (final inspection in monthInspections) {
            final items = await _inspectionItemsRepository
                .watchByInspection(inspection.id)
                .first;
            for (final item in items.where((it) => it.isOk == false)) {
              final observation = item.observation;
              problems.add(observation != null && observation.isNotEmpty
                  ? '${item.label} : $observation'
                  : item.label);
            }
          }
          anomaliesValue = problems.isEmpty ? null : problems.join('\n');
        }

        // Dépense totale faite par le CLIENT ce mois (paiements ponctuels
        // et/ou abonnements, déjà enregistrés comme entrées dans Finances —
        // voir AbonnementsController pour l'automatisation de ces
        // dernières) : un rapport destiné au client résume ce qu'il a payé,
        // pas ce que HAVENA a reversé aux prestataires.
        double? totalExpensesValue;
        final clientId = logement.clientId;
        if (clientId != null) {
          final total = allFinances
              .where((f) =>
                  f.transactionType == TransactionType.entree &&
                  f.relatedClientId == clientId &&
                  f.periodMonth == period)
              .fold<double>(0, (sum, f) => sum + f.amount);
          totalExpensesValue = total > 0 ? total : null;
        }

        final existing = _firstWhereOrNull(
            rapports, (r) => r.logementId == logement.id && r.periodMonth == period);
        if (existing == null) {
          await _repository.create(
            logementId: logement.id,
            periodMonth: period,
            generalCondition: generalConditionValue,
            inspectionDone: inspectionDoneValue,
            anomalies: anomaliesValue,
            interventionsDone: interventionsDoneValue,
            totalExpenses: totalExpensesValue,
            recommendations: recommendationsValue,
            updatedBy: currentUid,
          );
        } else {
          await _repository.update(
            id: existing.id,
            logementId: logement.id,
            periodMonth: period,
            generalCondition: generalConditionValue,
            inspectionDone: inspectionDoneValue,
            anomalies: anomaliesValue,
            interventionsDone: interventionsDoneValue,
            totalExpenses: totalExpensesValue,
            recommendations: recommendationsValue,
            nextActions: existing.nextActions,
            updatedBy: currentUid,
          );
        }
      }
    } catch (e) {
      formError.value = 'Erreur lors de la génération des rapports : $e';
    } finally {
      isSaving.value = false;
    }
  }

  /// Photos du logement prises pendant la période du rapport (inspections
  /// et interventions confondues) — jointes au PDF (cahier des charges
  /// §13). Recalculé à chaque génération plutôt que stocké sur le rapport,
  /// pour rester à jour avec les photos ajoutées après coup.
  Future<List<String>> _photosForReport(Rapport rapport) async {
    final parts = rapport.periodMonth.split('-');
    if (parts.length != 2) return [];
    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    if (year == null || month == null) return [];

    final allPhotos = await _photosRepository.watchAll().first;
    return allPhotos
        .where((p) =>
            p.logementId == rapport.logementId &&
            p.takenAt.year == year &&
            p.takenAt.month == month)
        .map((p) => p.localFilePath)
        .toList();
  }

  Future<void> generateAndPreviewPdf(int rapportId) async {
    if (generatingIds.contains(rapportId)) return;
    generatingIds.add(rapportId);
    try {
      final rapport = _firstWhereOrNull(rapports, (r) => r.id == rapportId);
      if (rapport == null) {
        throw Exception('Rapport introuvable');
      }
      final logement =
          _firstWhereOrNull(logements, (l) => l.id == rapport.logementId);
      if (logement == null) {
        throw Exception('Logement introuvable');
      }
      final clientName = _firstWhereOrNull(
              clients, (c) => c.id == logement.clientId)
          ?.fullName;

      final bytes = await RapportPdfGenerator.generate(
        rapport: rapport,
        logement: logement,
        clientName: clientName,
        photoFilePaths: await _photosForReport(rapport),
      );

      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/HAVENA/rapports';
      await Directory(path).create(recursive: true);
      final file = File('$path/${rapport.reference}.pdf');
      await file.writeAsBytes(bytes);

      await _repository.updatePdfInfo(
        id: rapport.id,
        pdfLocalPath: file.path,
        generatedAt: DateTime.now(),
      );

      await Printing.layoutPdf(onLayout: (format) async => bytes);
    } catch (e) {
      formError.value = 'Erreur lors de la génération du PDF : $e';
    } finally {
      generatingIds.remove(rapportId);
    }
  }

  Future<void> deleteRapport(int id) async {
    await _repository.delete(id);
  }
}
