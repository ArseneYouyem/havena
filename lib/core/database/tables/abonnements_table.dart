import 'package:drift/drift.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/database/tables/clients_table.dart';
import 'package:havena/core/database/tables/logements_table.dart';

class Abonnements extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get reference => text().unique()();

  IntColumn get clientId =>
      integer().references(Clients, #id).named('client_id')();

  IntColumn get logementId =>
      integer().references(Logements, #id).named('logement_id')();

  TextColumn get formula => text()();

  RealColumn get monthlyPrice => real().named('monthly_price')();

  DateTimeColumn get startDate => dateTime().named('start_date')();

  DateTimeColumn get renewalDate =>
      dateTime().nullable().named('renewal_date')();

  DateTimeColumn get lastPaymentDate =>
      dateTime().nullable().named('last_payment_date')();

  DateTimeColumn get nextPaymentDate =>
      dateTime().nullable().named('next_payment_date')();

  TextColumn get paymentStatus =>
      textEnum<PaymentStatus>().named('payment_status')();

  DateTimeColumn get lastInspectionDate =>
      dateTime().nullable().named('last_inspection_date')();

  DateTimeColumn get nextInspectionDate =>
      dateTime().nullable().named('next_inspection_date')();

  TextColumn get observations => text().nullable()();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime).named('updated_at')();

  TextColumn get updatedBy => text().nullable().named('updated_by')();

  TextColumn get syncStatus => textEnum<SyncStatus>()
      .clientDefault(() => SyncStatus.local.name)
      .named('sync_status')();

  BoolColumn get isDeleted =>
      boolean().withDefault(const Constant(false)).named('is_deleted')();
}
