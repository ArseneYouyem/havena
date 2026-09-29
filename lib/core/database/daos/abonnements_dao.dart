import 'package:drift/drift.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/tables/abonnements_table.dart';

part 'abonnements_dao.g.dart';

@DriftAccessor(tables: [Abonnements])
class AbonnementsDao extends DatabaseAccessor<AppDatabase>
    with _$AbonnementsDaoMixin {
  AbonnementsDao(super.db);

  Stream<List<Abonnement>> watchAll() =>
      (select(abonnements)..where((t) => t.isDeleted.equals(false))).watch();

  Future<Abonnement?> getById(int id) =>
      (select(abonnements)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertOne(AbonnementsCompanion companion) =>
      into(abonnements).insert(companion);

  Future<bool> updateOne(AbonnementsCompanion companion) =>
      update(abonnements).replace(companion);

  Future<int> softDelete(int id) => (update(abonnements)
        ..where((t) => t.id.equals(id)))
      .write(const AbonnementsCompanion(isDeleted: Value(true)));
}
