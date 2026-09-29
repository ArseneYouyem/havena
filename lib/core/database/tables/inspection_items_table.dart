import 'package:drift/drift.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/database/tables/inspections_table.dart';

class InspectionItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get inspectionId =>
      integer().references(Inspections, #id).named('inspection_id')();

  TextColumn get category => textEnum<InspectionCategory>()();

  TextColumn get label => text()();

  BoolColumn get isOk => boolean().nullable().named('is_ok')();

  TextColumn get observation => text().nullable()();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime).named('updated_at')();

  TextColumn get updatedBy => text().nullable().named('updated_by')();

  TextColumn get syncStatus => textEnum<SyncStatus>()
      .clientDefault(() => SyncStatus.local.name)
      .named('sync_status')();

  BoolColumn get isDeleted =>
      boolean().withDefault(const Constant(false)).named('is_deleted')();
}
