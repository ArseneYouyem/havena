import 'package:drift/drift.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/database/tables/clients_table.dart';

class Logements extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get reference => text().unique()();

  IntColumn get clientId =>
      integer().nullable().references(Clients, #id).named('client_id')();

  TextColumn get address => text()();

  TextColumn get neighborhood => text().nullable()();

  TextColumn get housingType => text().nullable().named('housing_type')();

  IntColumn get bedroomsCount =>
      integer().nullable().named('bedrooms_count')();

  TextColumn get occupancy => text().nullable()();

  TextColumn get localContact => text().nullable().named('local_contact')();

  TextColumn get guardian => text().nullable()();

  IntColumn get keysCount => integer().nullable().named('keys_count')();

  TextColumn get mainEquipment =>
      text().nullable().named('main_equipment')();

  DateTimeColumn get lastInspectionDate =>
      dateTime().nullable().named('last_inspection_date')();

  DateTimeColumn get nextInspectionDate =>
      dateTime().nullable().named('next_inspection_date')();

  TextColumn get generalCondition => textEnum<HousingCondition>()
      .nullable()
      .named('general_condition')();

  TextColumn get notes => text().nullable()();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime).named('updated_at')();

  TextColumn get updatedBy => text().nullable().named('updated_by')();

  TextColumn get syncStatus => textEnum<SyncStatus>()
      .clientDefault(() => SyncStatus.local.name)
      .named('sync_status')();

  BoolColumn get isDeleted =>
      boolean().withDefault(const Constant(false)).named('is_deleted')();
}
