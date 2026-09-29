import 'dart:async';
import 'package:get/get.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/prestataires/repositories/prestataires_repository.dart';

class PrestatairesController extends GetxController {
  PrestatairesController(this._repository, this._sessionController);

  final PrestatairesRepository _repository;
  final SessionController _sessionController;

  final prestataires = <Prestataire>[].obs;
  final searchQuery = ''.obs;

  final editingId = Rxn<int>();

  final fullName = Rxn<String>();
  final phone = Rxn<String>();
  final specialty = Rxn<String>();
  final zone = Rxn<String>();
  final experienceYearsText = RxString('');
  final indicativeRateText = RxString('');
  final qualityRatingText = RxString('');
  final punctualityRatingText = RxString('');
  final communicationRatingText = RxString('');
  final identityVerified = false.obs;
  final referencesVerified = false.obs;
  final status = Rxn<PrestataireStatus>();
  final observations = Rxn<String>();

  final isSaving = false.obs;
  final formError = Rxn<String>();

  StreamSubscription<List<Prestataire>>? _prestatairesSub;

  @override
  void onInit() {
    super.onInit();
    _prestatairesSub = _repository.watchAll().listen((data) {
      prestataires.value = data;
    });
  }

  @override
  void onClose() {
    _prestatairesSub?.cancel();
    super.onClose();
  }

  List<Prestataire> visiblePrestataires() {
    final query = searchQuery.value.toLowerCase().trim();
    if (query.isEmpty) return prestataires;
    return prestataires.where((prestataire) {
      return prestataire.fullName.toLowerCase().contains(query) ||
          prestataire.reference.toLowerCase().contains(query) ||
          prestataire.specialty.toLowerCase().contains(query);
    }).toList();
  }

  void openCreateForm() {
    editingId.value = null;
    fullName.value = null;
    phone.value = null;
    specialty.value = null;
    zone.value = null;
    experienceYearsText.value = '';
    indicativeRateText.value = '';
    qualityRatingText.value = '';
    punctualityRatingText.value = '';
    communicationRatingText.value = '';
    identityVerified.value = false;
    referencesVerified.value = false;
    status.value = PrestataireStatus.actif;
    observations.value = null;
    isSaving.value = false;
    formError.value = null;
  }

  void openEditForm(Prestataire prestataire) {
    editingId.value = prestataire.id;
    fullName.value = prestataire.fullName;
    phone.value = prestataire.phone;
    specialty.value = prestataire.specialty;
    zone.value = prestataire.zone;
    experienceYearsText.value = prestataire.experienceYears?.toString() ?? '';
    indicativeRateText.value = prestataire.indicativeRate?.toString() ?? '';
    qualityRatingText.value = prestataire.qualityRating?.toString() ?? '';
    punctualityRatingText.value =
        prestataire.punctualityRating?.toString() ?? '';
    communicationRatingText.value =
        prestataire.communicationRating?.toString() ?? '';
    identityVerified.value = prestataire.identityVerified;
    referencesVerified.value = prestataire.referencesVerified;
    status.value = prestataire.status;
    observations.value = prestataire.observations;
    isSaving.value = false;
    formError.value = null;
  }

  Future<void> submitForm() async {
    if (fullName.value == null ||
        fullName.value!.trim().isEmpty ||
        phone.value == null ||
        phone.value!.trim().isEmpty ||
        specialty.value == null ||
        specialty.value!.trim().isEmpty ||
        status.value == null) {
      formError.value = 'Veuillez remplir tous les champs obligatoires.';
      return;
    }

    final experienceYears = _parseInt(experienceYearsText.value);
    if (experienceYearsText.value.isNotEmpty && experienceYears == null) {
      formError.value = 'Années d\'expérience invalides.';
      return;
    }

    final indicativeRate = _parseDouble(indicativeRateText.value);
    if (indicativeRateText.value.isNotEmpty && indicativeRate == null) {
      formError.value = 'Tarif indicatif invalide.';
      return;
    }

    final qualityRating = _parseDouble(qualityRatingText.value);
    if (qualityRatingText.value.isNotEmpty && qualityRating == null) {
      formError.value = 'Note qualité invalide.';
      return;
    }

    final punctualityRating = _parseDouble(punctualityRatingText.value);
    if (punctualityRatingText.value.isNotEmpty && punctualityRating == null) {
      formError.value = 'Note ponctualité invalide.';
      return;
    }

    final communicationRating = _parseDouble(communicationRatingText.value);
    if (communicationRatingText.value.isNotEmpty &&
        communicationRating == null) {
      formError.value = 'Note communication invalide.';
      return;
    }

    if (qualityRating != null && (qualityRating < 0 || qualityRating > 5)) {
      formError.value = 'La note qualité doit être entre 0 et 5.';
      return;
    }
    if (punctualityRating != null &&
        (punctualityRating < 0 || punctualityRating > 5)) {
      formError.value = 'La note ponctualité doit être entre 0 et 5.';
      return;
    }
    if (communicationRating != null &&
        (communicationRating < 0 || communicationRating > 5)) {
      formError.value = 'La note communication doit être entre 0 et 5.';
      return;
    }

    isSaving.value = true;
    formError.value = null;
    try {
      final currentUid = _sessionController.session.value?.uid ?? 'system';
      final id = editingId.value;
      if (id == null) {
        await _repository.create(
          fullName: fullName.value!.trim(),
          phone: phone.value!.trim(),
          specialty: specialty.value!.trim(),
          zone: zone.value,
          experienceYears: experienceYears,
          identityVerified: identityVerified.value,
          referencesVerified: referencesVerified.value,
          indicativeRate: indicativeRate,
          qualityRating: qualityRating,
          punctualityRating: punctualityRating,
          communicationRating: communicationRating,
          status: status.value!,
          observations: observations.value,
          updatedBy: currentUid,
        );
      } else {
        await _repository.update(
          id: id,
          fullName: fullName.value!.trim(),
          phone: phone.value!.trim(),
          specialty: specialty.value!.trim(),
          zone: zone.value,
          experienceYears: experienceYears,
          identityVerified: identityVerified.value,
          referencesVerified: referencesVerified.value,
          indicativeRate: indicativeRate,
          qualityRating: qualityRating,
          punctualityRating: punctualityRating,
          communicationRating: communicationRating,
          status: status.value!,
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

  int? _parseInt(String value) {
    if (value.trim().isEmpty) return null;
    return int.tryParse(value.trim());
  }

  double? _parseDouble(String value) {
    if (value.trim().isEmpty) return null;
    return double.tryParse(value.trim().replaceAll(',', '.'));
  }

  Future<void> deletePrestataire(int id) async {
    await _repository.delete(id);
  }
}
