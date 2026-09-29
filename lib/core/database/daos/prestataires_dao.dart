import 'package:drift/drift.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/tables/prestataires_table.dart';

part 'prestataires_dao.g.dart';

@DriftAccessor(tables: [Prestataires])
class PrestatairesDao extends DatabaseAccessor<AppDatabase>
    with _$PrestatairesDaoMixin {
  PrestatairesDao(super.db);

  Stream<List<Prestataire>> watchAll() => (select(prestataires)
        ..where((t) => t.isDeleted.equals(false)))
      .watch();

  Future<Prestataire?> getById(int id) => (select(prestataires)
        ..where((t) => t.id.equals(id)))
      .getSingleOrNull();

  Future<int> countAll() async {
    final countExp = prestataires.id.count();
    final query = selectOnly(prestataires)..addColumns([countExp]);
    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }

  Future<int> insertOne(PrestatairesCompanion companion) =>
      into(prestataires).insert(companion);

  Future<bool> updateOne(PrestatairesCompanion companion) =>
      update(prestataires).replace(companion);

  Future<int> softDelete(int id) => (update(prestataires)
        ..where((t) => t.id.equals(id)))
      .write(const PrestatairesCompanion(isDeleted: Value(true)));
}
