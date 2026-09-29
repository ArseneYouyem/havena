import 'package:drift/drift.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/database/tables/clients_table.dart';
import 'package:havena/core/database/tables/logements_table.dart';
import 'package:havena/core/database/tables/prestataires_table.dart';

class Interventions extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get reference => text().unique()();

  IntColumn get logementId =>
      integer().references(Logements, #id).named('logement_id')();

  IntColumn get clientId =>
      integer().references(Clients, #id).named('client_id')();

  TextColumn get problemDescription =>
      text().named('problem_description')();

  TextColumn get category => text().nullable()();

  TextColumn get urgencyLevel =>
      textEnum<UrgencyLevel>().named('urgency_level')();

  IntColumn get prestataireId => integer()
      .nullable()
      .references(Prestataires, #id)
      .named('prestataire_id')();

  RealColumn get quoteAmount => real().nullable().named('quote_amount')();

  BoolColumn get clientValidated => boolean()
      .withDefault(const Constant(false))
      .named('client_validated')();

  DateTimeColumn get interventionDate =>
      dateTime().nullable().named('intervention_date')();

  RealColumn get clientAmount => real().nullable().named('client_amount')();

  RealColumn get prestataireAmount =>
      real().nullable().named('prestataire_amount')();

  RealColumn get havenaMargin => real().nullable().named('havena_margin')();

  TextColumn get status => textEnum<InterventionStatus>()();

  IntColumn get clientSatisfaction =>
      integer().nullable().named('client_satisfaction')();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime).named('updated_at')();

  TextColumn get updatedBy => text().nullable().named('updated_by')();

  TextColumn get syncStatus => textEnum<SyncStatus>()
      .clientDefault(() => SyncStatus.local.name)
      .named('sync_status')();

  BoolColumn get isDeleted =>
      boolean().withDefault(const Constant(false)).named('is_deleted')();
}
