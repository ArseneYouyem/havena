import 'package:drift/drift.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/database/tables/logements_table.dart';

class Rapports extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get reference => text().unique()();

  IntColumn get logementId =>
      integer().references(Logements, #id).named('logement_id')();

  TextColumn get periodMonth => text().named('period_month')();

  TextColumn get generalCondition => textEnum<HousingCondition>()
      .nullable()
      .named('general_condition')();

  BoolColumn get inspectionDone => boolean()
      .withDefault(const Constant(false))
      .named('inspection_done')();

  TextColumn get anomalies => text().nullable()();

  TextColumn get interventionsDone =>
      text().nullable().named('interventions_done')();

  RealColumn get totalExpenses =>
      real().nullable().named('total_expenses')();

  TextColumn get recommendations => text().nullable()();

  TextColumn get nextActions => text().nullable().named('next_actions')();

  TextColumn get pdfLocalPath =>
      text().nullable().named('pdf_local_path')();

  DateTimeColumn get generatedAt =>
      dateTime().nullable().named('generated_at')();

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
