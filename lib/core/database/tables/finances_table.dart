import 'package:drift/drift.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/database/tables/clients_table.dart';
import 'package:havena/core/database/tables/prestataires_table.dart';

class Finances extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get reference => text().unique()();

  DateTimeColumn get transactionDate =>
      dateTime().named('transaction_date')();

  TextColumn get transactionType =>
      textEnum<TransactionType>().named('transaction_type')();

  IntColumn get relatedClientId => integer()
      .nullable()
      .references(Clients, #id)
      .named('related_client_id')();

  IntColumn get relatedPrestataireId => integer()
      .nullable()
      .references(Prestataires, #id)
      .named('related_prestataire_id')();

  TextColumn get description => text()();

  RealColumn get amount => real()();

  TextColumn get paymentMethod => text().nullable().named('payment_method')();

  TextColumn get status => textEnum<TransactionStatus>()();

  TextColumn get periodMonth => text().named('period_month')();

  TextColumn get observations => text().nullable()();

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
