import 'package:drift/drift.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/tables/clients_table.dart';

part 'clients_dao.g.dart';

@DriftAccessor(tables: [Clients])
class ClientsDao extends DatabaseAccessor<AppDatabase> with _$ClientsDaoMixin {
  ClientsDao(super.db);

  Stream<List<Client>> watchAll() =>
      (select(clients)..where((t) => t.isDeleted.equals(false))).watch();

  Future<Client?> getById(int id) =>
      (select(clients)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> countAll() async {
    final countExp = clients.id.count();
    final query = selectOnly(clients)..addColumns([countExp]);
    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }

  Future<int> insertOne(ClientsCompanion companion) =>
      into(clients).insert(companion);

  Future<bool> updateOne(ClientsCompanion companion) =>
      update(clients).replace(companion);

  Future<int> softDelete(int id) => (update(clients)
        ..where((t) => t.id.equals(id)))
      .write(const ClientsCompanion(isDeleted: Value(true)));
}
