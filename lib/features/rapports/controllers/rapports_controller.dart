import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/pdf/rapport_pdf_generator.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';
import 'package:havena/features/rapports/repositories/rapports_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

class RapportsController extends GetxController {
  RapportsController(
    this._repository,
    this._logementsRepository,
    this._clientsRepository,
    this._sessionController,
  );

  final RapportsRepository _repository;
  final LogementsRepository _logementsRepository;
  final ClientsRepository _clientsRepository;
  final SessionController _sessionController;

  final rapports = <Rapport>[].obs;
  final logements = <Logement>[].obs;
  final clients = <Client>[].obs;
  final searchQuery = ''.obs;

  final editingId = Rxn<int>();

  final logementId = Rxn<int>();
  final periodMonth = ''.obs;
  final generalCondition = Rxn<HousingCondition>();
  final inspectionDone = false.obs;
  final anomalies = Rxn<String>();
  final interventionsDone = Rxn<String>();
  final totalExpensesText = ''.obs;
  final recommendations = Rxn<String>();
  final nextActions = Rxn<String>();

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
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    periodMonth.value = '${now.year}-$month';
  }

  @override
  void onClose() {
    _rapportsSub?.cancel();
    _logementsSub?.cancel();
    _clientsSub?.cancel();
    super.onClose();
  }

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

  List<Rapport> visibleRapports() {
    final query = searchQuery.value.toLowerCase().trim();
    if (query.isEmpty) return rapports;
    return rapports.where((rapport) {
      return rapport.reference.toLowerCase().contains(query) ||
          rapport.periodMonth.toLowerCase().contains(query);
    }).toList();
  }

  void openCreateForm() {
    editingId.value = null;
    logementId.value = null;
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    periodMonth.value = '${now.year}-$month';
    generalCondition.value = null;
    inspectionDone.value = false;
    anomalies.value = null;
    interventionsDone.value = null;
    totalExpensesText.value = '';
    recommendations.value = null;
    nextActions.value = null;
    isSaving.value = false;
    formError.value = null;
  }

  void openEditForm(Rapport rapport) {
    editingId.value = rapport.id;
    logementId.value = rapport.logementId;
    periodMonth.value = rapport.periodMonth;
    generalCondition.value = rapport.generalCondition;
    inspectionDone.value = rapport.inspectionDone;
    anomalies.value = rapport.anomalies;
    interventionsDone.value = rapport.interventionsDone;
    totalExpensesText.value = rapport.totalExpenses?.toString() ?? '';
    recommendations.value = rapport.recommendations;
    nextActions.value = rapport.nextActions;
    isSaving.value = false;
    formError.value = null;
  }

  Future<void> submitForm() async {
    final logementIdValue = logementId.value;
    final periodMonthValue = periodMonth.value.trim();

    if (logementIdValue == null) {
      formError.value = 'Le logement est obligatoire.';
      return;
    }
    if (!RegExp(r'^\d{4}-\d{2}$').hasMatch(periodMonthValue)) {
      formError.value = 'Le mois de période doit être au format YYYY-MM.';
      return;
    }

    double? totalExpenses;
    final totalExpensesInput = totalExpensesText.value.trim();
    if (totalExpensesInput.isNotEmpty) {
      totalExpenses =
          double.tryParse(totalExpensesInput.replaceAll(',', '.'));
      if (totalExpenses == null) {
        formError.value =
            'Le total des dépenses doit être un nombre décimal.';
        return;
      }
    }

    isSaving.value = true;
    formError.value = null;
    try {
      final currentUid = _sessionController.session.value?.uid ?? 'system';
      final id = editingId.value;
      if (id == null) {
        await _repository.create(
          logementId: logementIdValue,
          periodMonth: periodMonthValue,
          generalCondition: generalCondition.value,
          inspectionDone: inspectionDone.value,
          anomalies: anomalies.value,
          interventionsDone: interventionsDone.value,
          totalExpenses: totalExpenses,
          recommendations: recommendations.value,
          nextActions: nextActions.value,
          updatedBy: currentUid,
        );
      } else {
        await _repository.update(
          id: id,
          logementId: logementIdValue,
          periodMonth: periodMonthValue,
          generalCondition: generalCondition.value,
          inspectionDone: inspectionDone.value,
          anomalies: anomalies.value,
          interventionsDone: interventionsDone.value,
          totalExpenses: totalExpenses,
          recommendations: recommendations.value,
          nextActions: nextActions.value,
          updatedBy: currentUid,
        );
      }
      Get.back();
    } catch (e) {
      formError.value = 'Erreur lors de l\'enregistrement : $e';
    } finally {
      isSaving.value = false;
    }
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
