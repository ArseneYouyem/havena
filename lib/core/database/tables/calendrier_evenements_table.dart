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

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime).named('updated_at')();

  TextColumn get updatedBy => text().nullable().named('updated_by')();

  TextColumn get syncStatus => textEnum<SyncStatus>()
      .clientDefault(() => SyncStatus.local.name)
      .named('sync_status')();

  BoolColumn get isDeleted =>
      boolean().withDefault(const Constant(false)).named('is_deleted')();
}
