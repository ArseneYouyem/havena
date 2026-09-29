import 'package:drift/drift.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/tables/rapports_table.dart';

part 'rapports_dao.g.dart';

@DriftAccessor(tables: [Rapports])
class RapportsDao extends DatabaseAccessor<AppDatabase>
    with _$RapportsDaoMixin {
  RapportsDao(super.db);

  Stream<List<Rapport>> watchAll() =>
      (select(rapports)..where((t) => t.isDeleted.equals(false))).watch();

  Future<Rapport?> getById(int id) =>
      (select(rapports)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertOne(RapportsCompanion companion) =>
      into(rapports).insert(companion);

  Future<bool> updateOne(RapportsCompanion companion) =>
      update(rapports).replace(companion);

  Future<int> softDelete(int id) => (update(rapports)
        ..where((t) => t.id.equals(id)))
      .write(const RapportsCompanion(isDeleted: Value(true)));
}
