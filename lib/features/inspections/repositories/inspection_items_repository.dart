import 'package:drift/drift.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/daos/inspection_items_dao.dart';

class InspectionItemsRepository {
  InspectionItemsRepository(this._dao);

  final InspectionItemsDao _dao;

  Stream<List<InspectionItem>> watchByInspection(int inspectionId) =>
      _dao.watchByInspection(inspectionId);

  Future<void> updateStatus({
    required int itemId,
    required bool? isOk,
    required String updatedBy,
  }) async {
    final existing = await _dao.getById(itemId);
    if (existing == null) {
      throw Exception('Item introuvable');
    }
    await _dao.updateOne(InspectionItemsCompanion(
      id: Value(itemId),
      inspectionId: Value(existing.inspectionId),
      category: Value(existing.category),
      label: Value(existing.label),
      isOk: Value(isOk),
      observation: Value(existing.observation),
      updatedAt: Value(DateTime.now()),
      updatedBy: Value(updatedBy),
      syncStatus: Value(existing.syncStatus),
      isDeleted: Value(existing.isDeleted),
    ));
  }

  Future<void> updateObservation({
    required int itemId,
    required String observation,
    required String updatedBy,
  }) async {
    final existing = await _dao.getById(itemId);
    if (existing == null) {
      throw Exception('Item introuvable');
    }
    await _dao.updateOne(InspectionItemsCompanion(
      id: Value(itemId),
      inspectionId: Value(existing.inspectionId),
      category: Value(existing.category),
      label: Value(existing.label),
      isOk: Value(existing.isOk),
      observation: Value(observation),
      updatedAt: Value(DateTime.now()),
      updatedBy: Value(updatedBy),
      syncStatus: Value(existing.syncStatus),
      isDeleted: Value(existing.isDeleted),
    ));
  }
}
