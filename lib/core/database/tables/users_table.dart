import 'package:drift/drift.dart';
import 'package:havena/core/database/enums.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get uid => text().unique()();

  TextColumn get fullName => text().named('full_name')();

  TextColumn get email => text()();

  TextColumn get roleId => textEnum<AppRole>()();

  BoolColumn get active => boolean().withDefault(const Constant(true))();

  DateTimeColumn get lastSyncedAt =>
      dateTime().nullable().named('last_synced_at')();
}
