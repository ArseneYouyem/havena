import 'package:drift/drift.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/tables/inspections_table.dart';

part 'inspections_dao.g.dart';

@DriftAccessor(tables: [Inspections])
class InspectionsDao extends DatabaseAccessor<AppDatabase>
    with _$InspectionsDaoMixin {
  InspectionsDao(super.db);

  Stream<List<Inspection>> watchAll() =>
      (select(inspections)..where((t) => t.isDeleted.equals(false))).watch();

  Future<Inspection?> getById(int id) =>
      (select(inspections)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertOne(InspectionsCompanion companion) =>
      into(inspections).insert(companion);

  Future<bool> updateOne(InspectionsCompanion companion) =>
      update(inspections).replace(companion);

  Future<int> softDelete(int id) => (update(inspections)
        ..where((t) => t.id.equals(id)))
      .write(const InspectionsCompanion(isDeleted: Value(true)));
}
