import 'dart:async';

import 'package:get/get.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/calendrier/repositories/calendrier_repository.dart';
import 'package:havena/features/inspections/repositories/inspection_items_repository.dart';
import 'package:havena/features/inspections/repositories/inspections_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';
import 'package:havena/features/photos/repositories/photos_repository.dart';

class InspectionsController extends GetxController {
  InspectionsController({
    required InspectionsRepository inspectionsRepository,
    required InspectionItemsRepository inspectionItemsRepository,
    required LogementsRepository logementsRepository,
    required PhotosRepository photosRepository,
    required SessionController sessionController,
    required CalendrierRepository calendrierRepository,
  })  : _inspectionsRepository = inspectionsRepository,
        _inspectionItemsRepository = inspectionItemsRepository,
        _logementsRepository = logementsRepository,
        _photosRepository = photosRepository,
        _sessionController = sessionController,
        _calendrierRepository = calendrierRepository;

  final InspectionsRepository _inspectionsRepository;
  final InspectionItemsRepository _inspectionItemsRepository;
  final LogementsRepository _logementsRepository;
  final PhotosRepository _photosRepository;
  final SessionController _sessionController;
  final CalendrierRepository _calendrierRepository;

  final Rxn<int> selectedInspectionId = Rxn<int>();
  final Rxn<Inspection> selectedInspection = Rxn<Inspection>();
  final RxList<Inspection> inspections = <Inspection>[].obs;
  final RxList<Logement> logements = <Logement>[].obs;
  final RxList<InspectionItem> inspectionItems = <InspectionItem>[].obs;
  final RxList<Photo> inspectionPhotos = <Photo>[].obs;
  final RxString searchQuery = ''.obs;

  /// Filtres de la vue liste (retour utilisateur : filtres par logement et
  /// statut). `null` = filtre désactivé (« Tous »).
  final Rxn<int> filterLogementId = Rxn<int>();
  final Rxn<bool> filterValidated = Rxn<bool>();

  StreamSubscription<List<Inspection>>? _inspectionsSub;
  StreamSubscription<List<Logement>>? _logementsSub;
  StreamSubscription<List<InspectionItem>>? _itemsSub;

  @override
  void onInit() {
    super.onInit();
    _subscribeToCoreStreams();
  }

  @override
  void onClose() {
    _inspectionsSub?.cancel();
    _logementsSub?.cancel();
    _itemsSub?.cancel();
    super.onClose();
  }

  void _subscribeToCoreStreams() {
    _inspectionsSub = _inspectionsRepository.watchAll().listen((list) {
      inspections.assignAll(list);
      _refreshSelectedInspection();
    });
    _logementsSub = _logementsRepository.watchAll().listen((list) {
      logements.assignAll(list);
    });
  }

  void selectInspection(int? id) {
    if (id == selectedInspectionId.value) return;
    _itemsSub?.cancel();
    _itemsSub = null;
    selectedInspectionId.value = id;
    inspectionItems.clear();
    selectedInspection.value = null;
    if (id == null) return;

    _refreshSelectedInspection();
    _itemsSub = _inspectionItemsRepository
        .watchByInspection(id)
        .listen((items) => inspectionItems.assignAll(items));
    _loadPhotos(id);
  }

  Future<void> _loadPhotos(int inspectionId) async {
    final photos = await _photosRepository.forInspection(inspectionId);
    inspectionPhotos.assignAll(photos);
  }

  void _refreshSelectedInspection() {
    final id = selectedInspectionId.value;
    if (id == null) return;
    selectedInspection.value = _findInspection(id);
  }

  Inspection? _findInspection(int id) {
    for (final inspection in inspections) {
      if (inspection.id == id) return inspection;
    }
    return null;
  }

  Logement? _findLogement(int id) {
    for (final logement in logements) {
      if (logement.id == id) return logement;
    }
    return null;
  }

  String logementLabelFor(int logementId) {
    final logement = _findLogement(logementId);
    return logement != null ? logement.address : 'Logement introuvable';
  }

  List<Inspection> get visibleInspections {
    var list = inspections.toList();
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      list = list
          .where((i) => i.reference.toLowerCase().contains(query))
          .toList();
    }
    final logementId = filterLogementId.value;
    if (logementId != null) {
      list = list.where((i) => i.logementId == logementId).toList();
    }
    final validated = filterValidated.value;
    if (validated != null) {
      list = list.where((i) => i.isValidated == validated).toList();
    }
    return list;
  }

  Future<int> createInspection({
    required int logementId,
    required DateTime inspectionDate,
  }) async {
    final id = await _inspectionsRepository.createWithChecklist(
      logementId: logementId,
      inspectionDate: inspectionDate,
      updatedBy: _currentUserId(),
    );
    final logement = _findLogement(logementId);
    await _calendrierRepository.create(
      eventType: CalendarEventType.inspection,
      title: 'Inspection — ${logement?.address ?? 'Logement'}',
      eventDate: inspectionDate,
      relatedReference: logement?.reference,
      status: CalendarEventStatus.planifie,
      updatedBy: _currentUserId(),
    );
    selectInspection(id);
    return id;
  }

  Future<void> updateGeneralCondition(HousingCondition? value) async {
    final id = selectedInspectionId.value;
    if (id == null) return;
    await _inspectionsRepository.updateGeneralCondition(
      id: id,
      value: value,
      updatedBy: _currentUserId(),
    );
    // The stream will refresh selectedInspection automatically.
  }

  Future<void> updateRecommendations(String value) async {
    final id = selectedInspectionId.value;
    if (id == null) return;
    await _inspectionsRepository.updateRecommendations(
      id: id,
      value: value,
      updatedBy: _currentUserId(),
    );
  }

  Future<void> updateItemStatus(int itemId, bool? isOk) async {
    await _inspectionItemsRepository.updateStatus(
      itemId: itemId,
      isOk: isOk,
      updatedBy: _currentUserId(),
    );
  }

  Future<void> updateItemObservation(int itemId, String observation) async {
    await _inspectionItemsRepository.updateObservation(
      itemId: itemId,
      observation: observation,
      updatedBy: _currentUserId(),
    );
  }

  Future<void> validateInspection() async {
    final id = selectedInspectionId.value;
    if (id == null) return;
    await _inspectionsRepository.validate(
      id: id,
      updatedBy: _currentUserId(),
    );
  }

  Future<void> deleteInspection(int id) async {
    await _inspectionsRepository.delete(id);
    if (selectedInspectionId.value == id) {
      selectInspection(null);
    }
  }

  Future<void> addPhotos(List<String> filePaths) async {
    final inspection = selectedInspection.value;
    if (inspection == null) return;
    final logement = _findLogement(inspection.logementId);
    int sequence = inspectionPhotos.length + 1;
    for (final path in filePaths) {
      await _photosRepository.addPhotoFromFile(
        sourcePath: path,
        logementReference: logement?.reference ?? inspection.reference,
        entityReference: inspection.reference,
        logementId: inspection.logementId,
        inspectionId: inspection.id,
        photoType: PhotoType.inspection,
        sequence: sequence++,
        updatedBy: _currentUserId(),
      );
    }
    await _loadPhotos(inspection.id);
  }

  Future<void> deletePhoto(int photoId) async {
    await _photosRepository.delete(photoId);
    final id = selectedInspectionId.value;
    if (id != null) {
      await _loadPhotos(id);
    }
  }

  String _currentUserId() {
    final session = _sessionController.session.value;
    return session?.uid ?? 'system';
  }
}
