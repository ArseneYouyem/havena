import 'package:drift/drift.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/tables/sync_log_table.dart';

part 'sync_log_dao.g.dart';

@DriftAccessor(tables: [SyncLog])
class SyncLogDao extends DatabaseAccessor<AppDatabase>
    with _$SyncLogDaoMixin {
  SyncLogDao(super.db);

  Stream<List<SyncLogData>> watchAll() => select(syncLog).watch();

  Future<SyncLogData?> getByTable(String tableName) => (select(syncLog)
        ..where((t) => t.entityTable.equals(tableName)))
      .getSingleOrNull();

  Future<int> upsert(SyncLogCompanion companion) =>
      into(syncLog).insertOnConflictUpdate(companion);
}
