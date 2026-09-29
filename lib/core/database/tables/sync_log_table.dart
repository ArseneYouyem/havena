import 'package:drift/drift.dart';
import 'package:havena/core/database/enums.dart';

class SyncLog extends Table {
  TextColumn get entityTable => text().named('table_name')();

  DateTimeColumn get lastSyncedAt =>
      dateTime().nullable().named('last_synced_at')();

  TextColumn get lastSyncStatus =>
      textEnum<SyncLogStatus>().nullable().named('last_sync_status')();

  @override
  Set<Column> get primaryKey => {entityTable};
}
