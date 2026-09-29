import 'package:drift/drift.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/tables/finances_table.dart';

part 'finances_dao.g.dart';

@DriftAccessor(tables: [Finances])
class FinancesDao extends DatabaseAccessor<AppDatabase>
    with _$FinancesDaoMixin {
  FinancesDao(super.db);

  Stream<List<Finance>> watchAll() =>
      (select(finances)..where((t) => t.isDeleted.equals(false))).watch();

  Future<Finance?> getById(int id) =>
      (select(finances)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertOne(FinancesCompanion companion) =>
      into(finances).insert(companion);

  Future<bool> updateOne(FinancesCompanion companion) =>
      update(finances).replace(companion);

  Future<int> softDelete(int id) => (update(finances)
        ..where((t) => t.id.equals(id)))
      .write(const FinancesCompanion(isDeleted: Value(true)));
}
