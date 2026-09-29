import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/features/calendrier/repositories/calendrier_repository.dart';

void main() {
  late AppDatabase database;
  late CalendrierRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = CalendrierRepository(database.calendrierEvenementsDao);
  });

  tearDown(() async {
    await database.close();
  });

  test('crée un événement et le retrouve dans la liste', () async {
    await repository.create(
      eventType: CalendarEventType.rendezVous,
      title: 'Visite du logement',
      eventDate: DateTime(2026, 10, 5, 14, 30),
      relatedReference: 'HAV-INT-000001',
      status: CalendarEventStatus.planifie,
      updatedBy: 'test-uid',
    );

    final events = await repository.watchAll().first;
    expect(events, hasLength(1));
    expect(events.first.title, 'Visite du logement');
    expect(events.first.eventType, CalendarEventType.rendezVous);
    expect(events.first.relatedReference, 'HAV-INT-000001');
    expect(events.first.status, CalendarEventStatus.planifie);
  });

  test('modifie un événement existant', () async {
    await repository.create(
      eventType: CalendarEventType.inspection,
      title: 'Inspection initiale',
      eventDate: DateTime(2026, 10, 1, 9, 0),
      status: CalendarEventStatus.planifie,
      updatedBy: 'test-uid',
    );
    final event = (await repository.watchAll().first).first;

    await repository.update(
      id: event.id,
      eventType: event.eventType,
      title: 'Inspection initiale (mise à jour)',
      eventDate: event.eventDate,
      status: CalendarEventStatus.termine,
      updatedBy: 'test-uid',
    );

    final events = await repository.watchAll().first;
    expect(events.first.title, 'Inspection initiale (mise à jour)');
    expect(events.first.status, CalendarEventStatus.termine);
  });

  test('supprime (soft delete) un événement', () async {
    await repository.create(
      eventType: CalendarEventType.renouvellement,
      title: 'Renouvellement abonnement',
      eventDate: DateTime(2026, 11, 1),
      status: CalendarEventStatus.planifie,
      updatedBy: 'test-uid',
    );
    final event = (await repository.watchAll().first).first;

    await repository.delete(event.id);

    final events = await repository.watchAll().first;
    expect(events, isEmpty);
  });
}
