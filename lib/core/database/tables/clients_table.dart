import 'package:drift/drift.dart';
import 'package:havena/core/database/enums.dart';

class Clients extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get reference => text().unique()();

  TextColumn get fullName => text().named('full_name')();

  TextColumn get phone => text()();

  TextColumn get whatsapp => text().nullable()();

  TextColumn get email => text().nullable()();

  TextColumn get country => text()();

  TextColumn get city => text()();

  TextColumn get clientType => text().named('client_type')();

  TextColumn get logementReference =>
      text().nullable().named('logement_reference')();

  TextColumn get subscriptionFormula =>
      text().nullable().named('subscription_formula')();

  DateTimeColumn get startDate => dateTime().nullable().named('start_date')();

  DateTimeColumn get renewalDate =>
      dateTime().nullable().named('renewal_date')();

  TextColumn get status => textEnum<ClientStatus>()();

  DateTimeColumn get lastContactDate =>
      dateTime().nullable().named('last_contact_date')();

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
