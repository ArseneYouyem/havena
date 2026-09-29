import 'package:drift/drift.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/daos/inspection_items_dao.dart';
import 'package:havena/core/database/daos/inspections_dao.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/inspections/inspection_checklist.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:uuid/uuid.dart';

class InspectionsRepository {
  InspectionsRepository(
    this._dao,
    this._inspectionItemsDao,
    this._referenceGenerator,
  );

  final InspectionsDao _dao;
  final InspectionItemsDao _inspectionItemsDao;
  final ReferenceGeneratorService _referenceGenerator;

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
}
