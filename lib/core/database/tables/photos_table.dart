import 'package:drift/drift.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/database/tables/inspections_table.dart';
import 'package:havena/core/database/tables/interventions_table.dart';
import 'package:havena/core/database/tables/logements_table.dart';

class Photos extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get logementId => integer()
      .nullable()
      .references(Logements, #id)
      .named('logement_id')();

  IntColumn get interventionId => integer()
      .nullable()
      .references(Interventions, #id)
      .named('intervention_id')();

  IntColumn get inspectionId => integer()
      .nullable()
      .references(Inspections, #id)
      .named('inspection_id')();

  TextColumn get photoType =>
      textEnum<PhotoType>().named('photo_type')();

  TextColumn get fileName => text().named('file_name')();

  TextColumn get localFilePath => text().named('local_file_path')();

  TextColumn get driveFileId => text().nullable().named('drive_file_id')();

  DateTimeColumn get takenAt => dateTime().named('taken_at')();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime).named('updated_at')();

  TextColumn get updatedBy => text().nullable().named('updated_by')();

  TextColumn get syncStatus => textEnum<SyncStatus>()
      .clientDefault(() => SyncStatus.local.name)
      .named('sync_status')();

  BoolColumn get isDeleted =>
      boolean().withDefault(const Constant(false)).named('is_deleted')();
}
