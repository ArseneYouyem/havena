import 'dart:async';

import 'package:get/get.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/interventions/repositories/interventions_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';
import 'package:havena/features/photos/repositories/photos_repository.dart';
import 'package:havena/features/prestataires/repositories/prestataires_repository.dart';

class InterventionsController extends GetxController {
  InterventionsController({
    required InterventionsRepository interventionsRepository,
    required LogementsRepository logementsRepository,
    required ClientsRepository clientsRepository,
    required PrestatairesRepository prestatairesRepository,
    required PhotosRepository photosRepository,
    required SessionController sessionController,
  })  : _interventionsRepository = interventionsRepository,
        _logementsRepository = logementsRepository,
        _clientsRepository = clientsRepository,
        _prestatairesRepository = prestatairesRepository,
        _photosRepository = photosRepository,
        _sessionController = sessionController;

  final InterventionsRepository _interventionsRepository;
  final LogementsRepository _logementsRepository;
  final ClientsRepository _clientsRepository;
  final PrestatairesRepository _prestatairesRepository;
  final PhotosRepository _photosRepository;
  final SessionController _sessionController;

  final Rxn<int> selectedInterventionId = Rxn<int>();
  final Rxn<Intervention> selectedIntervention = Rxn<Intervention>();
  final RxList<Intervention> interventions = <Intervention>[].obs;
  final RxList<Logement> logements = <Logement>[].obs;
  final RxList<Client> clients = <Client>[].obs;
  final RxList<Prestataire> prestataires = <Prestataire>[].obs;
  final RxList<Photo> beforePhotos = <Photo>[].obs;
  final RxList<Photo> afterPhotos = <Photo>[].obs;
  final RxString searchQuery = ''.obs;
  final formError = Rxn<String>();

  StreamSubscription<List<Intervention>>? _interventionsSub;
  StreamSubscription<List<Logement>>? _logementsSub;
  StreamSubscription<List<Client>>? _clientsSub;
  StreamSubscription<List<Prestataire>>? _prestatairesSub;

  @override
  void onInit() {
    super.onInit();
    _subscribeToCoreStreams();
  }

  @override
  void onClose() {
    _interventionsSub?.cancel();
    _logementsSub?.cancel();
    _clientsSub?.cancel();
    _prestatairesSub?.cancel();
    super.onClose();
  }

  void _subscribeToCoreStreams() {
    _interventionsSub = _interventionsRepository.watchAll().listen((list) {
      interventions.assignAll(list);
      _refreshSelectedIntervention();
    });
    _logementsSub = _logementsRepository.watchAll().listen((list) {
      logements.assignAll(list);
    });
    _clientsSub = _clientsRepository.watchAll().listen((list) {
      clients.assignAll(list);
    });
    _prestatairesSub = _prestatairesRepository.watchAll().listen((list) {
      prestataires.assignAll(list);
    });
  }

  void selectIntervention(int? id) {
    if (id == selectedInterventionId.value) return;
    selectedInterventionId.value = id;
    selectedIntervention.value = null;
    beforePhotos.clear();
    afterPhotos.clear();
    if (id == null) return;

    _refreshSelectedIntervention();
    _loadPhotos(id);
  }

  Future<void> _loadPhotos(int interventionId) async {
    final photos = await _photosRepository.forIntervention(interventionId);
    beforePhotos.assignAll(
      photos
          .where((p) => p.photoType == PhotoType.avantIntervention)
          .toList(),
    );
    afterPhotos.assignAll(
      photos
          .where((p) => p.photoType == PhotoType.apresIntervention)
          .toList(),
    );
  }

  void _refreshSelectedIntervention() {
    final id = selectedInterventionId.value;
    if (id == null) return;
    selectedIntervention.value = _findIntervention(id);
  }

  Intervention? _findIntervention(int id) {
    for (final intervention in interventions) {
      if (intervention.id == id) return intervention;
    }
    return null;
  }

  Logement? _findLogement(int id) {
    for (final logement in logements) {
      if (logement.id == id) return logement;
    }
    return null;
  }

  Client? _findClient(int id) {
    for (final client in clients) {
      if (client.id == id) return client;
    }
    return null;
  }

  Prestataire? _findPrestataire(int id) {
    for (final prestataire in prestataires) {
      if (prestataire.id == id) return prestataire;
    }
    return null;
  }

  String logementLabelFor(int id) {
    final logement = _findLogement(id);
    return logement != null ? logement.address : 'Logement introuvable';
  }

  String clientLabelFor(int id) {
    final client = _findClient(id);
    return client != null ? client.fullName : 'Client introuvable';
  }

  String prestataireLabelFor(int? id) {
    if (id == null) return 'Non assigné';
    final prestataire = _findPrestataire(id);
    return prestataire != null ? prestataire.fullName : 'Introuvable';
  }

  List<Intervention> get visibleInterventions {
    if (searchQuery.value.isEmpty) return interventions.toList();
    final query = searchQuery.value.toLowerCase();
    return interventions
        .where((i) =>
            i.reference.toLowerCase().contains(query) ||
            i.problemDescription.toLowerCase().contains(query))
        .toList();
  }

  Future<int?> createIntervention({
    required int logementId,
    required String problemDescription,
    String? category,
    required UrgencyLevel urgencyLevel,
    int? prestataireId,
  }) async {
    final logement = _findLogement(logementId);
    final clientId = logement?.clientId;
    if (clientId == null) {
      formError.value = 'Le logement sélectionné n\'a pas de client associé.';
      return null;
    }

    formError.value = null;
    final id = await _interventionsRepository.create(
      logementId: logementId,
      clientId: clientId,
      problemDescription: problemDescription,
      category: category,
      urgencyLevel: urgencyLevel,
      prestataireId: prestataireId,
      updatedBy: _currentUserId(),
    );
    selectIntervention(id);
    return id;
  }

  Future<void> updateProblem({
    required String problemDescription,
    String? category,
    required UrgencyLevel urgencyLevel,
  }) async {
    final id = selectedInterventionId.value;
    if (id == null) return;
    await _interventionsRepository.updateProblem(
      id: id,
      problemDescription: problemDescription,
      category: category,
      urgencyLevel: urgencyLevel,
      updatedBy: _currentUserId(),
    );
    _refreshSelectedIntervention();
  }

  Future<void> updatePrestataire({int? prestataireId}) async {
    final id = selectedInterventionId.value;
    if (id == null) return;
    await _interventionsRepository.updatePrestataire(
      id: id,
      prestataireId: prestataireId,
      updatedBy: _currentUserId(),
    );
    _refreshSelectedIntervention();
  }

  Future<void> updateQuoteAndValidation({
    double? quoteAmount,
    required bool clientValidated,
  }) async {
    final id = selectedInterventionId.value;
    if (id == null) return;
    await _interventionsRepository.updateQuote(
      id: id,
      quoteAmount: quoteAmount,
      clientValidated: clientValidated,
      updatedBy: _currentUserId(),
    );
    _refreshSelectedIntervention();
  }

  Future<void> updatePlanning({DateTime? interventionDate}) async {
    final id = selectedInterventionId.value;
    if (id == null) return;
    await _interventionsRepository.updatePlanning(
      id: id,
      interventionDate: interventionDate,
      updatedBy: _currentUserId(),
    );
    _refreshSelectedIntervention();
  }

  Future<void> updateAmounts({
    double? clientAmount,
    double? prestataireAmount,
  }) async {
    final id = selectedInterventionId.value;
    if (id == null) return;
    await _interventionsRepository.updateAmounts(
      id: id,
      clientAmount: clientAmount,
      prestataireAmount: prestataireAmount,
      updatedBy: _currentUserId(),
    );
    _refreshSelectedIntervention();
  }

  Future<void> updateStatus({required InterventionStatus status}) async {
    final id = selectedInterventionId.value;
    if (id == null) return;
    await _interventionsRepository.updateStatus(
      id: id,
      status: status,
      updatedBy: _currentUserId(),
    );
    _refreshSelectedIntervention();
  }

  Future<void> updateSatisfaction({int? clientSatisfaction}) async {
    final id = selectedInterventionId.value;
    if (id == null) return;
    await _interventionsRepository.updateSatisfaction(
      id: id,
      clientSatisfaction: clientSatisfaction,
      updatedBy: _currentUserId(),
    );
    _refreshSelectedIntervention();
  }

  Future<void> addPhotos(List<String> filePaths, {required bool isBefore}) async {
    final intervention = selectedIntervention.value;
    if (intervention == null) return;
    final logement = _findLogement(intervention.logementId);

    final photos = isBefore ? beforePhotos : afterPhotos;
    int sequence = photos.length + 1;
    for (final path in filePaths) {
      await _photosRepository.addPhotoFromFile(
        sourcePath: path,
        logementReference: logement?.reference ?? intervention.reference,
        entityReference: intervention.reference,
        logementId: intervention.logementId,
        interventionId: intervention.id,
        photoType: isBefore
            ? PhotoType.avantIntervention
            : PhotoType.apresIntervention,
        sequence: sequence++,
        updatedBy: _currentUserId(),
      );
    }
    await _loadPhotos(intervention.id);
  }

  Future<void> deletePhoto(int photoId) async {
    await _photosRepository.delete(photoId);
    final id = selectedInterventionId.value;
    if (id != null) {
      await _loadPhotos(id);
    }
  }

  Future<void> deleteIntervention(int id) async {
    await _interventionsRepository.delete(id);
    if (selectedInterventionId.value == id) {
      selectIntervention(null);
    }
  }

  String _currentUserId() {
    final session = _sessionController.session.value;
    return session?.uid ?? 'system';
  }
}
