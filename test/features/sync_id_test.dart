import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/features/calendrier/repositories/calendrier_repository.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('chaque client créé reçoit un syncId (UUID) non nul et unique',
      () async {
    final referenceGenerator = ReferenceGeneratorService(database);
    final repository =
        ClientsRepository(database.clientsDao, referenceGenerator);

    await repository.create(
      fullName: 'Client A',
      phone: '+237600000001',
      country: 'Cameroun',
      city: 'Douala',
      clientType: 'particulier',
      status: ClientStatus.actif,
      updatedBy: 'test-uid',
    );
    await repository.create(
      fullName: 'Client B',
      phone: '+237600000002',
      country: 'Cameroun',
      city: 'Douala',
      clientType: 'particulier',
      status: ClientStatus.actif,
      updatedBy: 'test-uid',
    );

    final clients = await repository.watchAll().first;
    expect(clients, hasLength(2));
    for (final client in clients) {
      expect(client.syncId, isNotNull);
      expect(client.syncId, isNotEmpty);
    }
    expect(clients[0].syncId, isNot(equals(clients[1].syncId)));
  });

  test('un logement créé reçoit également un syncId unique', () async {
    final referenceGenerator = ReferenceGeneratorService(database);
    final clientsRepository =
        ClientsRepository(database.clientsDao, referenceGenerator);
    final repository = LogementsRepository(
        database.logementsDao, referenceGenerator, clientsRepository);

    await repository.create(address: '1 rue A', updatedBy: 'test-uid');
    await repository.create(address: '2 rue B', updatedBy: 'test-uid');

    final logements = await repository.watchAll().first;
    expect(logements[0].syncId, isNotNull);
    expect(logements[1].syncId, isNotNull);
    expect(logements[0].syncId, isNot(equals(logements[1].syncId)));
  });

  test(
      'une entité sans référence HAVENA (Calendrier) reçoit tout de même un syncId',
      () async {
    final repository = CalendrierRepository(database.calendrierEvenementsDao);

    await repository.create(
      eventType: CalendarEventType.rendezVous,
      title: 'Visite',
      eventDate: DateTime(2026, 10, 1),
      status: CalendarEventStatus.planifie,
      updatedBy: 'test-uid',
    );

    final events = await repository.watchAll().first;
    expect(events, hasLength(1));
    expect(events.first.syncId, isNotNull);
    expect(events.first.syncId, isNotEmpty);
  });
}
