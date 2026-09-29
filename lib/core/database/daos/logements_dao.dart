import 'package:drift/drift.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/tables/logements_table.dart';

part 'logements_dao.g.dart';

@DriftAccessor(tables: [Logements])
class LogementsDao extends DatabaseAccessor<AppDatabase>
    with _$LogementsDaoMixin {
  LogementsDao(super.db);

  Stream<List<Logement>> watchAll() =>
      (select(logements)..where((t) => t.isDeleted.equals(false))).watch();

  Future<Logement?> getById(int id) =>
      (select(logements)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertOne(LogementsCompanion companion) =>
      into(logements).insert(companion);

  Future<bool> updateOne(LogementsCompanion companion) =>
      update(logements).replace(companion);

  Future<int> softDelete(int id) => (update(logements)
        ..where((t) => t.id.equals(id)))
      .write(const LogementsCompanion(isDeleted: Value(true)));
}
