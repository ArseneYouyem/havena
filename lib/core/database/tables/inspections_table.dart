import 'package:drift/drift.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/database/tables/logements_table.dart';

class Inspections extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get reference => text().unique()();

  IntColumn get logementId =>
      integer().references(Logements, #id).named('logement_id')();

  IntColumn get agentUserId =>
      integer().nullable().named('agent_user_id')();

  DateTimeColumn get inspectionDate =>
      dateTime().named('inspection_date')();

  TextColumn get generalCondition => textEnum<HousingCondition>()
      .nullable()
      .named('general_condition')();

  TextColumn get recommendations => text().nullable()();

  BoolColumn get isValidated =>
      boolean().withDefault(const Constant(false)).named('is_validated')();

  DateTimeColumn get validatedAt =>
      dateTime().nullable().named('validated_at')();

  /// Identifiant global unique (UUID) pour la synchronisation Firestore —
  /// voir `Clients.syncId`.
  TextColumn get syncId => text().nullable().unique().named('sync_id')();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime).named('updated_at')();

  TextColumn get updatedBy => text().nullable().named('updated_by')();

  TextColumn get syncStatus => textEnum<SyncStatus>()
      .clientDefault(() => SyncStatus.local.name)
      .named('sync_status')();

  BoolColumn get isDeleted =>
      boolean().withDefault(const Constant(false)).named('is_deleted')();
}
