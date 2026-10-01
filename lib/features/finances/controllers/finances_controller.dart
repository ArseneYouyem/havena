import 'dart:async';
import 'package:get/get.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/finances/repositories/finances_repository.dart';
import 'package:havena/features/prestataires/repositories/prestataires_repository.dart';

class FinancesController extends GetxController {
  FinancesController(
    this._repository,
    this._clientsRepository,
    this._prestatairesRepository,
    this._sessionController,
  );

  final FinancesRepository _repository;
  final ClientsRepository _clientsRepository;
  final PrestatairesRepository _prestatairesRepository;
  final SessionController _sessionController;

  final finances = <Finance>[].obs;
  final clients = <Client>[].obs;
  final prestataires = <Prestataire>[].obs;
  final searchQuery = ''.obs;

  /// Filtres de la vue liste (retour utilisateur : filtres par type,
  /// statut, client, prestataire). `null` = filtre désactivé (« Tous »).
  final filterType = Rxn<TransactionType>();
  final filterStatus = Rxn<TransactionStatus>();
  final filterClientId = Rxn<int>();
  final filterPrestataireId = Rxn<int>();

  /// Drawer latéral (retour utilisateur : liste allégée, détails complets
  /// affichés uniquement au clic) — même principe que les drawers
  /// Clients/Logements.
  final Rxn<int> selectedFinanceId = Rxn<int>();
  void selectFinance(int? id) => selectedFinanceId.value = id;

  final editingId = Rxn<int>();

  final transactionDate = Rxn<DateTime>();
  final transactionType = Rxn<TransactionType>();
  final relatedClientId = Rxn<int>();
  final relatedPrestataireId = Rxn<int>();
  final description = Rxn<String>();
  final amountText = ''.obs;
  final paymentMethod = Rxn<String>();
  final status = Rxn<TransactionStatus>();
  final periodMonth = ''.obs;
  final observations = Rxn<String>();

  final isSaving = false.obs;
  final formError = Rxn<String>();

  StreamSubscription<List<Finance>>? _financesSub;
  StreamSubscription<List<Client>>? _clientsSub;
  StreamSubscription<List<Prestataire>>? _prestatairesSub;

  @override
  void onInit() {
    super.onInit();
    _financesSub = _repository.watchAll().listen((data) {
      finances.value = data;
    });
    _clientsSub = _clientsRepository.watchAll().listen((data) {
      clients.value = data;
    });
    _prestatairesSub = _prestatairesRepository.watchAll().listen((data) {
      prestataires.value = data;
    });
  }

  @override
  void onClose() {
    _financesSub?.cancel();
    _clientsSub?.cancel();
    _prestatairesSub?.cancel();
    super.onClose();
  }

  double get totalEntrees => finances
      .where((f) => f.transactionType == TransactionType.entree)
      .fold(0.0, (sum, f) => sum + f.amount);

  double get totalSorties => finances
      .where((f) => f.transactionType == TransactionType.sortie)
      .fold(0.0, (sum, f) => sum + f.amount);

  double get solde => totalEntrees - totalSorties;

  List<Finance> visibleFinances() {
    var list = finances.toList();
    final query = searchQuery.value.toLowerCase().trim();
    if (query.isNotEmpty) {
      list = list.where((finance) {
        return finance.reference.toLowerCase().contains(query) ||
            finance.description.toLowerCase().contains(query);
      }).toList();
    }
    final type = filterType.value;
    if (type != null) {
      list = list.where((f) => f.transactionType == type).toList();
    }
    final status = filterStatus.value;
    if (status != null) {
      list = list.where((f) => f.status == status).toList();
    }
    final clientId = filterClientId.value;
    if (clientId != null) {
      list = list.where((f) => f.relatedClientId == clientId).toList();
    }
    final prestataireId = filterPrestataireId.value;
    if (prestataireId != null) {
      list =
          list.where((f) => f.relatedPrestataireId == prestataireId).toList();
    }
    return list;
  }

  String clientLabelFor(int? clientId) {
    if (clientId == null) return '';
    for (final client in clients) {
      if (client.id == clientId) {
        return '${client.fullName} (${client.reference})';
      }
    }
    return '';
  }

  String prestataireLabelFor(int? prestataireId) {
    if (prestataireId == null) return '';
    for (final prestataire in prestataires) {
      if (prestataire.id == prestataireId) {
        return '${prestataire.fullName} (${prestataire.reference})';
      }
    }
    return '';
  }

  void openCreateForm() {
    editingId.value = null;
    transactionDate.value = DateTime.now();
    transactionType.value = TransactionType.entree;
    relatedClientId.value = null;
    relatedPrestataireId.value = null;
    description.value = null;
    amountText.value = '';
    paymentMethod.value = null;
    status.value = TransactionStatus.enAttente;
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    periodMonth.value = '${now.year}-$month';
    observations.value = null;
    isSaving.value = false;
    formError.value = null;
  }

  void openEditForm(Finance finance) {
    editingId.value = finance.id;
    transactionDate.value = finance.transactionDate;
    transactionType.value = finance.transactionType;
    relatedClientId.value = finance.relatedClientId;
    relatedPrestataireId.value = finance.relatedPrestataireId;
    description.value = finance.description;
    amountText.value = finance.amount.toString();
    paymentMethod.value = finance.paymentMethod;
    status.value = finance.status;
    periodMonth.value = finance.periodMonth;
    observations.value = finance.observations;
    isSaving.value = false;
    formError.value = null;
  }

  Future<void> submitForm() async {
    final transactionDateValue = transactionDate.value;
    final transactionTypeValue = transactionType.value;
    final descriptionValue = description.value;
    final statusValue = status.value;
    final periodMonthValue = periodMonth.value;

    if (transactionDateValue == null) {
      formError.value = 'La date de transaction est obligatoire.';
      return;
    }
    if (transactionTypeValue == null) {
      formError.value = 'Le type de transaction est obligatoire.';
      return;
    }
    if (descriptionValue == null || descriptionValue.trim().isEmpty) {
      formError.value = 'La description est obligatoire.';
      return;
    }
    if (amountText.value.trim().isEmpty) {
      formError.value = 'Le montant est obligatoire.';
      return;
    }
    final amount = double.tryParse(
      amountText.value.trim().replaceAll(',', '.'),
    );
    if (amount == null || amount <= 0) {
      formError.value = 'Le montant doit être un nombre décimal positif.';
      return;
    }
    if (!RegExp(r'^\d{4}-\d{2}$').hasMatch(periodMonthValue)) {
      formError.value = 'Le mois de période doit être au format YYYY-MM.';
      return;
    }
    if (statusValue == null) {
      formError.value = 'Le statut est obligatoire.';
      return;
    }

    isSaving.value = true;
    formError.value = null;
    try {
      final currentUid = _sessionController.session.value?.uid ?? 'system';
      final id = editingId.value;
      if (id == null) {
        await _repository.create(
          transactionDate: transactionDateValue,
          transactionType: transactionTypeValue,
          relatedClientId: relatedClientId.value,
          relatedPrestataireId: relatedPrestataireId.value,
          description: descriptionValue.trim(),
          amount: amount,
          paymentMethod: paymentMethod.value,
          status: statusValue,
          periodMonth: periodMonthValue,
          observations: observations.value,
          updatedBy: currentUid,
        );
      } else {
        await _repository.update(
          id: id,
          transactionDate: transactionDateValue,
          transactionType: transactionTypeValue,
          relatedClientId: relatedClientId.value,
          relatedPrestataireId: relatedPrestataireId.value,
          description: descriptionValue.trim(),
          amount: amount,
          paymentMethod: paymentMethod.value,
          status: statusValue,
          periodMonth: periodMonthValue,
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

  Future<void> deleteFinance(int id) async {
    await _repository.delete(id);
  }
}
