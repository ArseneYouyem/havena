import 'package:drift/drift.dart';
import 'package:havena/core/database/enums.dart';

class Prestataires extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get reference => text().unique()();

  TextColumn get fullName => text().named('full_name')();

  TextColumn get phone => text()();

  TextColumn get specialty => text()();

  TextColumn get zone => text().nullable()();

  IntColumn get experienceYears =>
      integer().nullable().named('experience_years')();

  BoolColumn get identityVerified => boolean()
      .withDefault(const Constant(false))
      .named('identity_verified')();

  BoolColumn get referencesVerified => boolean()
      .withDefault(const Constant(false))
      .named('references_verified')();

  RealColumn get indicativeRate =>
      real().nullable().named('indicative_rate')();

  RealColumn get qualityRating =>
      real().nullable().named('quality_rating')();

  RealColumn get punctualityRating =>
      real().nullable().named('punctuality_rating')();

  RealColumn get communicationRating =>
      real().nullable().named('communication_rating')();

  TextColumn get status => textEnum<PrestataireStatus>()();

  IntColumn get interventionsCount => integer()
      .withDefault(const Constant(0))
      .named('interventions_count')();

  DateTimeColumn get lastInterventionDate =>
      dateTime().nullable().named('last_intervention_date')();

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
