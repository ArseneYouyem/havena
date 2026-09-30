import 'package:drift/drift.dart';
import 'package:havena/core/database/enums.dart';

class CalendrierEvenements extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get eventType =>
      textEnum<CalendarEventType>().named('event_type')();

  TextColumn get title => text()();

  DateTimeColumn get eventDate => dateTime().named('event_date')();

  TextColumn get relatedReference =>
      text().nullable().named('related_reference')();

  IntColumn get responsibleUserId =>
      integer().nullable().named('responsible_user_id')();

  TextColumn get status => textEnum<CalendarEventStatus>()();

  /// Identifiant global unique (UUID) pour la synchronisation Firestore —
  /// voir `Clients.syncId`.
  TextColumn get syncId => text().nullable().unique().named('sync_id')();

  /// Id de l'évènement correspondant dans le calendrier secondaire Google
  /// « HAVENA » du compte Drive partagé de l'entreprise (voir
  /// `GoogleCalendarSyncService`). Propagé via la synchronisation Firestore
  /// habituelle (même champ que les autres dans `CalendrierSyncAdapter`)
  /// pour qu'un appareil qui récupère un évènement créé ailleurs ne
  /// recrée pas un doublon côté Google Calendar.
  TextColumn get googleEventId => text().nullable().named('google_event_id')();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime).named('updated_at')();

  TextColumn get updatedBy => text().nullable().named('updated_by')();

  TextColumn get syncStatus => textEnum<SyncStatus>()
      .clientDefault(() => SyncStatus.local.name)
      .named('sync_status')();

  BoolColumn get isDeleted =>
      boolean().withDefault(const Constant(false)).named('is_deleted')();
}
