import 'dart:async';
import 'package:get/get.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/features/abonnements/repositories/abonnements_repository.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';

class AbonnementsController extends GetxController {
  AbonnementsController(
    this._repository,
    this._clientsRepository,
    this._logementsRepository,
    this._sessionController,
  );

  final AbonnementsRepository _repository;
  final ClientsRepository _clientsRepository;
  final LogementsRepository _logementsRepository;
  final SessionController _sessionController;

  final abonnements = <Abonnement>[].obs;
  final clients = <Client>[].obs;
  final logements = <Logement>[].obs;
  final searchQuery = ''.obs;

  final editingId = Rxn<int>();

  final clientId = Rxn<int>();
  final logementId = Rxn<int>();
  final formula = Rxn<String>();
  final monthlyPriceText = ''.obs;
  final startDate = Rxn<DateTime>();
  final renewalDate = Rxn<DateTime>();
  final lastPaymentDate = Rxn<DateTime>();
  final nextPaymentDate = Rxn<DateTime>();
  final paymentStatus = Rxn<PaymentStatus>();
  final observations = Rxn<String>();

  final isSaving = false.obs;
  final formError = Rxn<String>();

  StreamSubscription<List<Abonnement>>? _abonnementsSub;
  StreamSubscription<List<Client>>? _clientsSub;
  StreamSubscription<List<Logement>>? _logementsSub;

  @override
  void onInit() {
    super.onInit();
    _abonnementsSub = _repository.watchAll().listen((data) {
      abonnements.value = data;
    });
    _clientsSub = _clientsRepository.watchAll().listen((data) {
      clients.value = data;
    });
    _logementsSub = _logementsRepository.watchAll().listen((data) {
      logements.value = data;
    });
  }

  @override
  void onClose() {
    _abonnementsSub?.cancel();
    _clientsSub?.cancel();
    _logementsSub?.cancel();
    super.onClose();
  }

  List<Abonnement> visibleAbonnements() {
    final query = searchQuery.value.toLowerCase().trim();
    if (query.isEmpty) return abonnements;
    return abonnements.where((abonnement) {
      return abonnement.reference.toLowerCase().contains(query) ||
          abonnement.formula.toLowerCase().contains(query);
    }).toList();
  }

  String clientLabelFor(int? clientId) {
    if (clientId == null) return 'Client introuvable';
    for (final client in clients) {
      if (client.id == clientId) {
        return '${client.fullName} (${client.reference})';
      }
    }
    return 'Client introuvable';
  }

  String logementLabelFor(int? logementId) {
    if (logementId == null) return 'Logement introuvable';
    for (final logement in logements) {
      if (logement.id == logementId) {
        return '${logement.reference} — ${logement.address}';
      }
    }
    return 'Logement introuvable';
  }

  bool isRenewalOrPaymentSoon(Abonnement abonnement) {
    final now = DateTime.now();
    final soon = now.add(const Duration(days: 7));
    if (abonnement.renewalDate != null &&
        abonnement.renewalDate!.isBefore(soon)) {
      return true;
    }
    if (abonnement.nextPaymentDate != null &&
        abonnement.nextPaymentDate!.isBefore(soon)) {
      return true;
    }
    return false;
  }

  void openCreateForm() {
    editingId.value = null;
    clientId.value = null;
    logementId.value = null;
    formula.value = null;
    monthlyPriceText.value = '';
    startDate.value = DateTime.now();
    renewalDate.value = null;
    lastPaymentDate.value = null;
    nextPaymentDate.value = null;
    paymentStatus.value = PaymentStatus.aJour;
    observations.value = null;
    isSaving.value = false;
    formError.value = null;
  }

  void openEditForm(Abonnement abonnement) {
    editingId.value = abonnement.id;
    clientId.value = abonnement.clientId;
    logementId.value = abonnement.logementId;
    formula.value = abonnement.formula;
    monthlyPriceText.value = abonnement.monthlyPrice.toString();
    startDate.value = abonnement.startDate;
    renewalDate.value = abonnement.renewalDate;
    lastPaymentDate.value = abonnement.lastPaymentDate;
    nextPaymentDate.value = abonnement.nextPaymentDate;
    paymentStatus.value = abonnement.paymentStatus;
    observations.value = abonnement.observations;
    isSaving.value = false;
    formError.value = null;
  }

  Future<void> submitForm() async {
    final clientIdValue = clientId.value;
    final logementIdValue = logementId.value;
    final formulaValue = formula.value;
    final startDateValue = startDate.value;
    final paymentStatusValue = paymentStatus.value;

    if (clientIdValue == null) {
      formError.value = 'Le client est obligatoire.';
      return;
    }
    if (logementIdValue == null) {
      formError.value = 'Le logement est obligatoire.';
      return;
    }
    if (formulaValue == null || formulaValue.trim().isEmpty) {
      formError.value = 'La formule est obligatoire.';
      return;
    }
    if (monthlyPriceText.value.trim().isEmpty) {
      formError.value = 'Le prix mensuel est obligatoire.';
      return;
    }
    final monthlyPrice = double.tryParse(
      monthlyPriceText.value.trim().replaceAll(',', '.'),
    );
    if (monthlyPrice == null || monthlyPrice < 0) {
      formError.value = 'Le prix mensuel doit être un nombre valide.';
      return;
    }
    if (startDateValue == null) {
      formError.value = 'La date de début est obligatoire.';
      return;
    }
    if (paymentStatusValue == null) {
      formError.value = 'Le statut de paiement est obligatoire.';
      return;
    }

    isSaving.value = true;
    formError.value = null;
    try {
      final currentUid = _sessionController.session.value?.uid ?? 'system';
      final id = editingId.value;
      if (id == null) {
        await _repository.create(
          clientId: clientIdValue,
          logementId: logementIdValue,
          formula: formulaValue.trim(),
          monthlyPrice: monthlyPrice,
          startDate: startDateValue,
          renewalDate: renewalDate.value,
          lastPaymentDate: lastPaymentDate.value,
          nextPaymentDate: nextPaymentDate.value,
          paymentStatus: paymentStatusValue,
          observations: observations.value,
          updatedBy: currentUid,
        );
      } else {
        await _repository.update(
          id: id,
          clientId: clientIdValue,
          logementId: logementIdValue,
          formula: formulaValue.trim(),
          monthlyPrice: monthlyPrice,
          startDate: startDateValue,
          renewalDate: renewalDate.value,
          lastPaymentDate: lastPaymentDate.value,
          nextPaymentDate: nextPaymentDate.value,
          paymentStatus: paymentStatusValue,
          observations: observations.value,
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

  Future<void> deleteAbonnement(int id) async {
    await _repository.delete(id);
  }
}
