import 'package:drift/drift.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/tables/inspection_items_table.dart';

part 'inspection_items_dao.g.dart';

@DriftAccessor(tables: [InspectionItems])
class InspectionItemsDao extends DatabaseAccessor<AppDatabase>
    with _$InspectionItemsDaoMixin {
  InspectionItemsDao(super.db);

  Stream<List<InspectionItem>> watchAll() => (select(inspectionItems)
        ..where((t) => t.isDeleted.equals(false)))
      .watch();

  Stream<List<InspectionItem>> watchByInspection(int inspectionId) =>
      (select(inspectionItems)
            ..where((t) =>
                t.inspectionId.equals(inspectionId) &
                t.isDeleted.equals(false)))
          .watch();

  Future<InspectionItem?> getById(int id) => (select(inspectionItems)
        ..where((t) => t.id.equals(id)))
      .getSingleOrNull();

  Future<int> insertOne(InspectionItemsCompanion companion) =>
      into(inspectionItems).insert(companion);

  Future<bool> updateOne(InspectionItemsCompanion companion) =>
      update(inspectionItems).replace(companion);

  Future<int> softDelete(int id) => (update(inspectionItems)
        ..where((t) => t.id.equals(id)))
      .write(const InspectionItemsCompanion(isDeleted: Value(true)));
}
