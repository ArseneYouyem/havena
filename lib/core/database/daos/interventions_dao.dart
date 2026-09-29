import 'package:drift/drift.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/tables/interventions_table.dart';

part 'interventions_dao.g.dart';

@DriftAccessor(tables: [Interventions])
class InterventionsDao extends DatabaseAccessor<AppDatabase>
    with _$InterventionsDaoMixin {
  InterventionsDao(super.db);

  Stream<List<Intervention>> watchAll() => (select(interventions)
        ..where((t) => t.isDeleted.equals(false)))
      .watch();

  Future<Intervention?> getById(int id) => (select(interventions)
        ..where((t) => t.id.equals(id)))
      .getSingleOrNull();

  Future<int> insertOne(InterventionsCompanion companion) =>
      into(interventions).insert(companion);

  Future<bool> updateOne(InterventionsCompanion companion) =>
      update(interventions).replace(companion);

  Future<int> softDelete(int id) => (update(interventions)
        ..where((t) => t.id.equals(id)))
      .write(const InterventionsCompanion(isDeleted: Value(true)));
}
