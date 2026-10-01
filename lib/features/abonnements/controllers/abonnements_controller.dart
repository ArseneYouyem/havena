import 'dart:async';
import 'package:get/get.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/features/abonnements/repositories/abonnements_repository.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/calendrier/repositories/calendrier_repository.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/finances/repositories/finances_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';

class AbonnementsController extends GetxController {
  AbonnementsController(
    this._repository,
    this._clientsRepository,
    this._logementsRepository,
    this._sessionController,
    this._financesRepository,
    this._calendrierRepository,
  );

  final AbonnementsRepository _repository;
  final ClientsRepository _clientsRepository;
  final LogementsRepository _logementsRepository;
  final SessionController _sessionController;
  final FinancesRepository _financesRepository;
  final CalendrierRepository _calendrierRepository;

  final abonnements = <Abonnement>[].obs;
  final clients = <Client>[].obs;
  final logements = <Logement>[].obs;
  final searchQuery = ''.obs;

  /// Filtres + tri de la vue liste (retour utilisateur) : tri par date de
  /// renouvellement la plus proche en premier (`null` en dernier), filtres
  /// par client/logement/statut combinables avec la recherche texte.
  final filterClientId = Rxn<int>();
  final filterLogementId = Rxn<int>();
  final filterStatus = Rxn<PaymentStatus>();

  /// Drawer latéral (retour utilisateur) : détails de l'abonnement cliqué,
  /// avec un bouton « Renouveler » qui préremplit le formulaire de création
  /// pour un NOUVEL abonnement (jamais une modification de l'existant).
  final Rxn<int> selectedAbonnementId = Rxn<int>();
  void selectAbonnement(int? id) => selectedAbonnementId.value = id;

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
    var list = abonnements.toList();
    final query = searchQuery.value.toLowerCase().trim();
    if (query.isNotEmpty) {
      list = list.where((abonnement) {
        return abonnement.reference.toLowerCase().contains(query) ||
            abonnement.formula.toLowerCase().contains(query);
      }).toList();
    }
    final clientIdFilter = filterClientId.value;
    if (clientIdFilter != null) {
      list = list.where((a) => a.clientId == clientIdFilter).toList();
    }
    final logementIdFilter = filterLogementId.value;
    if (logementIdFilter != null) {
      list = list.where((a) => a.logementId == logementIdFilter).toList();
    }
    final statusFilter = filterStatus.value;
    if (statusFilter != null) {
      list = list.where((a) => a.paymentStatus == statusFilter).toList();
    }
    list.sort((a, b) {
      final dateA = a.renewalDate;
      final dateB = b.renewalDate;
      if (dateA == null && dateB == null) return 0;
      if (dateA == null) return 1;
      if (dateB == null) return -1;
      return dateA.compareTo(dateB);
    });
    return list;
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

  /// Préremplit le formulaire de création pour renouveler [old] : un NOUVEL
  /// abonnement est créé au clic sur Enregistrer (`editingId` reste `null`),
  /// jamais une modification de l'abonnement existant.
  void openRenewForm(Abonnement old) {
    final now = DateTime.now();
    editingId.value = null;
    clientId.value = old.clientId;
    logementId.value = old.logementId;
    formula.value = old.formula;
    monthlyPriceText.value = old.monthlyPrice.toString();
    startDate.value = now;
    renewalDate.value = old.renewalDate;
    lastPaymentDate.value = now;
    nextPaymentDate.value = old.renewalDate;
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
        await _recordAutomaticEffects(
          clientId: clientIdValue,
          formula: formulaValue.trim(),
          monthlyPrice: monthlyPrice,
          renewalDateValue: renewalDate.value,
          paymentStatusValue: paymentStatusValue,
          currentUid: currentUid,
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

  /// Effets automatiques déclenchés à la création d'un abonnement (retour
  /// utilisateur) : si le paiement est marqué « à jour », enregistre tout de
  /// suite la transaction correspondante dans Finances ; si une date de
  /// renouvellement est renseignée, crée l'évènement correspondant dans le
  /// calendrier. Jamais appelé lors d'une simple modification (édition d'un
  /// abonnement existant), uniquement à la création d'une nouvelle ligne —
  /// y compris via `openRenewForm`, qui crée toujours une nouvelle ligne.
  Future<void> _recordAutomaticEffects({
    required int clientId,
    required String formula,
    required double monthlyPrice,
    required DateTime? renewalDateValue,
    required PaymentStatus paymentStatusValue,
    required String currentUid,
  }) async {
    if (paymentStatusValue == PaymentStatus.aJour) {
      final now = DateTime.now();
      final period = '${now.year}-${now.month.toString().padLeft(2, '0')}';
      await _financesRepository.create(
        transactionDate: now,
        transactionType: TransactionType.entree,
        relatedClientId: clientId,
        description: 'Paiement abonnement — $formula',
        amount: monthlyPrice,
        status: TransactionStatus.valide,
        periodMonth: period,
        updatedBy: currentUid,
      );
    }
    if (renewalDateValue != null) {
      await _calendrierRepository.create(
        eventType: CalendarEventType.renouvellement,
        title: 'Renouvellement abonnement — ${clientLabelFor(clientId)}',
        eventDate: renewalDateValue,
        relatedReference: formula,
        status: CalendarEventStatus.planifie,
        updatedBy: currentUid,
      );
    }
  }

  Future<void> deleteAbonnement(int id) async {
    await _repository.delete(id);
  }
}
