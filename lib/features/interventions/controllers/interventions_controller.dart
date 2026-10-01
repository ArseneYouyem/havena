import 'dart:async';

import 'package:get/get.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/calendrier/repositories/calendrier_repository.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/inspections/repositories/inspections_repository.dart';
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
    required CalendrierRepository calendrierRepository,
    required InspectionsRepository inspectionsRepository,
  })  : _interventionsRepository = interventionsRepository,
        _logementsRepository = logementsRepository,
        _clientsRepository = clientsRepository,
        _prestatairesRepository = prestatairesRepository,
        _photosRepository = photosRepository,
        _sessionController = sessionController,
        _calendrierRepository = calendrierRepository,
        _inspectionsRepository = inspectionsRepository;

  final InterventionsRepository _interventionsRepository;
  final LogementsRepository _logementsRepository;
  final ClientsRepository _clientsRepository;
  final PrestatairesRepository _prestatairesRepository;
  final PhotosRepository _photosRepository;
  final SessionController _sessionController;
  final CalendrierRepository _calendrierRepository;
  final InspectionsRepository _inspectionsRepository;

  final Rxn<int> selectedInterventionId = Rxn<int>();
  final Rxn<Intervention> selectedIntervention = Rxn<Intervention>();
  final RxList<Intervention> interventions = <Intervention>[].obs;
  final RxList<Logement> logements = <Logement>[].obs;
  final RxList<Client> clients = <Client>[].obs;
  final RxList<Prestataire> prestataires = <Prestataire>[].obs;
  final RxList<Inspection> inspections = <Inspection>[].obs;
  final RxList<Photo> beforePhotos = <Photo>[].obs;
  final RxList<Photo> afterPhotos = <Photo>[].obs;
  final RxString searchQuery = ''.obs;
  final formError = Rxn<String>();

  /// Filtres de la vue liste (retour utilisateur : filtres par logement,
  /// client, statut, urgence). `null` = filtre désactivé (« Tous »).
  final Rxn<int> filterLogementId = Rxn<int>();
  final Rxn<int> filterClientId = Rxn<int>();
  final Rxn<InterventionStatus> filterStatus = Rxn<InterventionStatus>();
  final Rxn<UrgencyLevel> filterUrgency = Rxn<UrgencyLevel>();

  StreamSubscription<List<Intervention>>? _interventionsSub;
  StreamSubscription<List<Logement>>? _logementsSub;
  StreamSubscription<List<Client>>? _clientsSub;
  StreamSubscription<List<Prestataire>>? _prestatairesSub;
  StreamSubscription<List<Inspection>>? _inspectionsSub;

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
    _inspectionsSub?.cancel();
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
    _inspectionsSub = _inspectionsRepository.watchAll().listen((list) {
      inspections.assignAll(list);
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

  Inspection? _findInspection(int id) {
    for (final inspection in inspections) {
      if (inspection.id == id) return inspection;
    }
    return null;
  }

  String logementLabelFor(int id) {
    final logement = _findLogement(id);
    return logement != null ? logement.address : 'Logement introuvable';
  }

  /// Libellé de l'inspection d'origine affiché dans le détail de
  /// l'intervention (retour utilisateur : « à partir des détails d'une
  /// intervention, on doit savoir à quelle inspection elle est liée »).
  String inspectionLabelFor(int? id) {
    if (id == null) return 'Aucune';
    final inspection = _findInspection(id);
    if (inspection == null) return 'Introuvable';
    return '${inspection.reference} — ${_formatDate(inspection.inspectionDate)}';
  }

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
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
    var list = interventions.toList();
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      list = list
          .where((i) =>
              i.reference.toLowerCase().contains(query) ||
              i.problemDescription.toLowerCase().contains(query))
          .toList();
    }
    final logementId = filterLogementId.value;
    if (logementId != null) {
      list = list.where((i) => i.logementId == logementId).toList();
    }
    final clientId = filterClientId.value;
    if (clientId != null) {
      list = list.where((i) => i.clientId == clientId).toList();
    }
    final status = filterStatus.value;
    if (status != null) {
      list = list.where((i) => i.status == status).toList();
    }
    final urgency = filterUrgency.value;
    if (urgency != null) {
      list = list.where((i) => i.urgencyLevel == urgency).toList();
    }
    return list;
  }

  /// L'inspection remplace désormais le logement comme point d'entrée de la
  /// création (retour utilisateur : « on ne fait pas d'intervention sans
  /// inspection ») — le logement (et son client) sont dérivés de
  /// l'inspection choisie, jamais sélectionnés séparément.
  Future<int?> createIntervention({
    required int inspectionId,
    required String problemDescription,
    String? category,
    required UrgencyLevel urgencyLevel,
    int? prestataireId,
  }) async {
    final inspection = _findInspection(inspectionId);
    if (inspection == null) {
      formError.value = 'L\'inspection sélectionnée est introuvable.';
      return null;
    }
    final logement = _findLogement(inspection.logementId);
    final clientId = logement?.clientId;
    if (clientId == null) {
      formError.value = 'Le logement de cette inspection n\'a pas de client associé.';
      return null;
    }

    formError.value = null;
    final id = await _interventionsRepository.create(
      logementId: inspection.logementId,
      clientId: clientId,
      inspectionId: inspectionId,
      problemDescription: problemDescription,
      category: category,
      urgencyLevel: urgencyLevel,
      prestataireId: prestataireId,
      updatedBy: _currentUserId(),
    );
    await _calendrierRepository.create(
      eventType: CalendarEventType.intervention,
      title: 'Intervention — ${logement?.address ?? problemDescription}',
      eventDate: DateTime.now(),
      relatedReference: logement?.reference,
      status: CalendarEventStatus.planifie,
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
