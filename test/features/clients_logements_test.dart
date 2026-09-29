import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';

void main() {
  late AppDatabase database;
  late ReferenceGeneratorService referenceGenerator;
  late ClientsRepository clientsRepository;
  late LogementsRepository logementsRepository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    referenceGenerator = ReferenceGeneratorService(database);
    clientsRepository =
        ClientsRepository(database.clientsDao, referenceGenerator);
    logementsRepository =
        LogementsRepository(database.logementsDao, referenceGenerator);
  });

  tearDown(() async {
    await database.close();
  });

  test(
      'crée un client puis un logement lié, avec des références HAVENA séquentielles',
      () async {
    await clientsRepository.create(
      fullName: 'Jean Test',
      phone: '+237600000000',
      country: 'Cameroun',
      city: 'Douala',
      clientType: 'particulier',
      status: ClientStatus.actif,
      updatedBy: 'test-uid',
    );

    final clients = await clientsRepository.watchAll().first;
    expect(clients, hasLength(1));
    expect(clients.first.reference, 'HAV-CLI-000001');

    await logementsRepository.create(
      clientId: clients.first.id,
      address: '12 rue des Fleurs, Bonamoussadi',
      generalCondition: HousingCondition.bon,
      updatedBy: 'test-uid',
    );

    final logements = await logementsRepository.watchAll().first;
    expect(logements, hasLength(1));
    expect(logements.first.reference, 'HAV-DLA-000001');
    expect(logements.first.clientId, clients.first.id);
    expect(logements.first.generalCondition, HousingCondition.bon);

    // Un 2e client obtient bien la référence suivante.
    await clientsRepository.create(
      fullName: 'Awa Test',
      phone: '+237600000001',
      country: 'Cameroun',
      city: 'Yaoundé',
      clientType: 'entreprise',
      status: ClientStatus.actif,
      updatedBy: 'test-uid',
    );
    final updatedClients = await clientsRepository.watchAll().first;
    expect(
      updatedClients.map((c) => c.reference),
      containsAll(['HAV-CLI-000001', 'HAV-CLI-000002']),
    );
  });

  test('la modification et la suppression douce fonctionnent', () async {
    await clientsRepository.create(
      fullName: 'Client Modifiable',
      phone: '+237611111111',
      country: 'Cameroun',
      city: 'Douala',
      clientType: 'particulier',
      status: ClientStatus.actif,
      updatedBy: 'test-uid',
    );
    final client = (await clientsRepository.watchAll().first).first;

    await clientsRepository.update(
      id: client.id,
      fullName: 'Client Modifié',
      phone: client.phone,
      country: client.country,
      city: client.city,
      clientType: client.clientType,
      status: ClientStatus.suspendu,
      updatedBy: 'test-uid',
    );
    final updated = (await clientsRepository.watchAll().first).first;
    expect(updated.fullName, 'Client Modifié');
    expect(updated.status, ClientStatus.suspendu);
    expect(updated.reference, client.reference);

    await clientsRepository.delete(client.id);
    final afterDelete = await clientsRepository.watchAll().first;
    expect(afterDelete, isEmpty);
  });
}
