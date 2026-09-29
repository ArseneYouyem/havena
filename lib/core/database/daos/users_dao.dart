import 'package:drift/drift.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/tables/users_table.dart';

part 'users_dao.g.dart';

@DriftAccessor(tables: [Users])
class UsersDao extends DatabaseAccessor<AppDatabase> with _$UsersDaoMixin {
  UsersDao(super.db);

  Stream<List<User>> watchAll() => select(users).watch();

  Future<User?> getById(int id) =>
      (select(users)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertOne(UsersCompanion companion) =>
      into(users).insert(companion);

  Future<bool> updateOne(UsersCompanion companion) =>
      update(users).replace(companion);

  Future<int> softDelete(int id) =>
      (delete(users)..where((t) => t.id.equals(id))).go();
}
