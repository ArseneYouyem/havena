import 'package:drift/drift.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/daos/inspection_items_dao.dart';
import 'package:havena/core/database/daos/inspections_dao.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/inspections/inspection_checklist.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';
import 'package:uuid/uuid.dart';

class InspectionsRepository {
  InspectionsRepository(
    this._dao,
    this._inspectionItemsDao,
    this._referenceGenerator,
    this._logementsRepository,
  );

  final InspectionsDao _dao;
  final InspectionItemsDao _inspectionItemsDao;
  final ReferenceGeneratorService _referenceGenerator;
  final LogementsRepository _logementsRepository;

  Stream<List<Inspection>> watchAll() => _dao.watchAll();

  Future<Inspection?> getById(int id) => _dao.getById(id);

  Future<int> createWithChecklist({
    required int logementId,
    required DateTime inspectionDate,
    required String updatedBy,
  }) async {
    final reference = await _referenceGenerator.nextInspectionReference();

    final inspectionId = await _dao.insertOne(InspectionsCompanion(
      reference: Value(reference),
      syncId: Value(const Uuid().v4()),
      logementId: Value(logementId),
      inspectionDate: Value(inspectionDate),
      updatedAt: Value(DateTime.now()),
      updatedBy: Value(updatedBy),
    ));

    InspectionChecklist.items.forEach((category, labels) {
      for (final label in labels) {
        _inspectionItemsDao.insertOne(InspectionItemsCompanion(
          inspectionId: Value(inspectionId),
          category: Value(category),
          label: Value(label),
          updatedAt: Value(DateTime.now()),
          updatedBy: Value(updatedBy),
        ));
      }
    });

    return inspectionId;
  }

  Future<void> updateGeneralCondition({
    required int id,
    required HousingCondition? value,
    required String updatedBy,
  }) async {
    final existing = await _dao.getById(id);
    if (existing == null) {
      throw Exception('Inspection introuvable');
    }
    await _dao.updateOne(InspectionsCompanion(
      id: Value(id),
      reference: Value(existing.reference),
      logementId: Value(existing.logementId),
      agentUserId: Value(existing.agentUserId),
      inspectionDate: Value(existing.inspectionDate),
      generalCondition: Value(value),
      recommendations: Value(existing.recommendations),
      isValidated: Value(existing.isValidated),
      validatedAt: Value(existing.validatedAt),
      updatedAt: Value(DateTime.now()),
      updatedBy: Value(updatedBy),
      syncStatus: Value(existing.syncStatus),
      isDeleted: Value(existing.isDeleted),
    ));
  }

  Future<void> updateRecommendations({
    required int id,
    required String value,
    required String updatedBy,
  }) async {
    final existing = await _dao.getById(id);
    if (existing == null) {
      throw Exception('Inspection introuvable');
    }
    await _dao.updateOne(InspectionsCompanion(
      id: Value(id),
      reference: Value(existing.reference),
      logementId: Value(existing.logementId),
      agentUserId: Value(existing.agentUserId),
      inspectionDate: Value(existing.inspectionDate),
      generalCondition: Value(existing.generalCondition),
      recommendations: Value(value),
      isValidated: Value(existing.isValidated),
      validatedAt: Value(existing.validatedAt),
      updatedAt: Value(DateTime.now()),
      updatedBy: Value(updatedBy),
      syncStatus: Value(existing.syncStatus),
      isDeleted: Value(existing.isDeleted),
    ));
  }

  Future<void> validate({
    required int id,
    required String updatedBy,
  }) async {
    final existing = await _dao.getById(id);
    if (existing == null) {
      throw Exception('Inspection introuvable');
    }
    await _dao.updateOne(InspectionsCompanion(
      id: Value(id),
      reference: Value(existing.reference),
      logementId: Value(existing.logementId),
      agentUserId: Value(existing.agentUserId),
      inspectionDate: Value(existing.inspectionDate),
      generalCondition: Value(existing.generalCondition),
      recommendations: Value(existing.recommendations),
      isValidated: const Value(true),
      validatedAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
      updatedBy: Value(updatedBy),
      syncStatus: Value(existing.syncStatus),
      isDeleted: Value(existing.isDeleted),
    ));
  }

  Future<void> delete(int id) => _dao.softDelete(id);

  Future<Inspection?> findBySyncId(String syncId) async {
    final all = await _dao.watchAll().first;
    for (final inspection in all) {
      if (inspection.syncId == syncId) return inspection;
    }
    return null;
  }

  /// Crée ou met à jour la ligne locale correspondant à [syncId] à partir
  /// d'un document Firestore générique. Traduit `logementSyncId` en
  /// `logementId` local (obligatoire : parent introuvable -> abandon
  /// silencieux, retenté à la prochaine synchronisation). `agentUserId`
  /// n'est PAS traduit (pas de table Users locale pour l'instant, transmis
  /// tel quel comme entier brut, comme dans le formulaire de création).
  Future<void> upsertFromRemote({
    required String syncId,
    required Map<String, dynamic> data,
  }) async {
    final logementSyncId = data['logementSyncId'] as String?;
    if (logementSyncId == null) {
      return;
    }
    final logement = await _logementsRepository.findBySyncId(logementSyncId);
    if (logement == null) {
      return;
    }

    final existing = await findBySyncId(syncId);
    final companion = InspectionsCompanion(
      id: existing != null ? Value(existing.id) : const Value.absent(),
      syncId: Value(syncId),
      reference: Value(data['reference'] as String),
      logementId: Value(logement.id),
      agentUserId: Value(data['agentUserId'] as int?),
      inspectionDate: Value(DateTime.parse(data['inspectionDate'] as String)),
      generalCondition: Value(data['generalCondition'] == null
          ? null
          : HousingCondition.values
              .byName(data['generalCondition'] as String)),
      recommendations: Value(data['recommendations'] as String?),
      isValidated: Value(data['isValidated'] as bool? ?? false),
      validatedAt: Value(_parseDate(data['validatedAt'])),
      updatedAt: Value(DateTime.parse(data['updatedAt'] as String)),
      updatedBy: Value(data['updatedBy'] as String?),
      isDeleted: Value(data['isDeleted'] as bool? ?? false),
      syncStatus: const Value(SyncStatus.synced),
    );

    if (existing != null) {
      await _dao.updateOne(companion);
    } else {
      await _dao.insertOne(companion);
    }
  }

  DateTime? _parseDate(Object? value) {
    if (value == null) return null;
    return DateTime.parse(value as String);
  }
}
