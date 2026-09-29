import 'dart:async';
import 'package:get/get.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';

class LogementsController extends GetxController {
  LogementsController(
      this._repository, this._clientsRepository, this._sessionController);

  final LogementsRepository _repository;
  final ClientsRepository _clientsRepository;
  final SessionController _sessionController;

  final logements = <Logement>[].obs;
  final clients = <Client>[].obs;
  final searchQuery = ''.obs;

  final editingId = Rxn<int>();

  final clientId = Rxn<int>();
  final address = Rxn<String>();
  final neighborhood = Rxn<String>();
  final housingType = Rxn<String>();
  final bedroomsCountText = ''.obs;
  final occupancy = Rxn<String>();
  final localContact = Rxn<String>();
  final guardian = Rxn<String>();
  final keysCountText = ''.obs;
  final mainEquipment = Rxn<String>();
  final generalCondition = Rxn<HousingCondition>();
  final notes = Rxn<String>();

  final isSaving = false.obs;
  final formError = Rxn<String>();

  StreamSubscription<List<Logement>>? _logementsSub;
  StreamSubscription<List<Client>>? _clientsSub;

  @override
  void onInit() {
    super.onInit();
    _logementsSub = _repository.watchAll().listen((data) {
      logements.value = data;
    });
    _clientsSub = _clientsRepository.watchAll().listen((data) {
      clients.value = data;
    });
  }

  @override
  void onClose() {
    _logementsSub?.cancel();
    _clientsSub?.cancel();
    super.onClose();
  }

  List<Logement> visibleLogements() {
    final query = searchQuery.value.toLowerCase().trim();
    if (query.isEmpty) return logements;
    return logements.where((logement) {
      return logement.reference.toLowerCase().contains(query) ||
          logement.address.toLowerCase().contains(query) ||
          (logement.neighborhood?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  String clientLabelFor(int? clientId) {
    if (clientId == null) return 'Non assigné';
    for (final client in clients) {
      if (client.id == clientId) {
        return '${client.fullName} (${client.reference})';
      }
    }
    return 'Non assigné';
  }

  void openCreateForm() {
    editingId.value = null;
    clientId.value = null;
    address.value = null;
    neighborhood.value = null;
    housingType.value = null;
    bedroomsCountText.value = '';
    occupancy.value = null;
    localContact.value = null;
    guardian.value = null;
    keysCountText.value = '';
    mainEquipment.value = null;
    generalCondition.value = null;
    notes.value = null;
    isSaving.value = false;
    formError.value = null;
  }

  void openEditForm(Logement logement) {
    editingId.value = logement.id;
    clientId.value = logement.clientId;
    address.value = logement.address;
    neighborhood.value = logement.neighborhood;
    housingType.value = logement.housingType;
    bedroomsCountText.value = logement.bedroomsCount?.toString() ?? '';
    occupancy.value = logement.occupancy;
    localContact.value = logement.localContact;
    guardian.value = logement.guardian;
    keysCountText.value = logement.keysCount?.toString() ?? '';
    mainEquipment.value = logement.mainEquipment;
    generalCondition.value = logement.generalCondition;
    notes.value = logement.notes;
    isSaving.value = false;
    formError.value = null;
  }

  Future<void> submitForm() async {
    if (address.value == null || address.value!.trim().isEmpty) {
      formError.value = 'L\'adresse est obligatoire.';
      return;
    }
    final bedrooms = int.tryParse(bedroomsCountText.value);
    final keys = int.tryParse(keysCountText.value);
    if (bedroomsCountText.value.isNotEmpty && bedrooms == null) {
      formError.value = 'Le nombre de chambres doit être un entier valide.';
      return;
    }
    if (keysCountText.value.isNotEmpty && keys == null) {
      formError.value = 'Le nombre de clés doit être un entier valide.';
      return;
    }

    isSaving.value = true;
    formError.value = null;
    try {
      final currentUid = _sessionController.session.value?.uid ?? 'system';
      final id = editingId.value;
      if (id == null) {
        await _repository.create(
          clientId: clientId.value,
          address: address.value!.trim(),
          neighborhood: neighborhood.value,
          housingType: housingType.value,
          bedroomsCount: bedrooms,
          occupancy: occupancy.value,
          localContact: localContact.value,
          guardian: guardian.value,
          keysCount: keys,
          mainEquipment: mainEquipment.value,
          generalCondition: generalCondition.value,
          notes: notes.value,
          updatedBy: currentUid,
        );
      } else {
        await _repository.update(
          id: id,
          clientId: clientId.value,
          address: address.value!.trim(),
          neighborhood: neighborhood.value,
          housingType: housingType.value,
          bedroomsCount: bedrooms,
          occupancy: occupancy.value,
          localContact: localContact.value,
          guardian: guardian.value,
          keysCount: keys,
          mainEquipment: mainEquipment.value,
          generalCondition: generalCondition.value,
          notes: notes.value,
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

  Future<void> deleteLogement(int id) async {
    await _repository.delete(id);
  }
}
