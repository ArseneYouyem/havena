import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/interventions/repositories/interventions_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';

void main() {
  late AppDatabase database;
  late ClientsRepository clientsRepository;
  late LogementsRepository logementsRepository;
  late InterventionsRepository interventionsRepository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    final referenceGenerator = ReferenceGeneratorService(database);
    clientsRepository =
        ClientsRepository(database.clientsDao, referenceGenerator);
    logementsRepository = LogementsRepository(
        database.logementsDao, referenceGenerator, clientsRepository);
    interventionsRepository = InterventionsRepository(
      database.interventionsDao,
      referenceGenerator,
    );
  });

  tearDown(() async {
    await database.close();
  });

  Future<(int clientId, int logementId)> createClientAndLogement() async {
    await clientsRepository.create(
      fullName: 'Client Intervention',
      phone: '+237600000000',
      country: 'Cameroun',
      city: 'Douala',
      clientType: 'particulier',
      status: ClientStatus.actif,
      updatedBy: 'test-uid',
    );
    final client = (await clientsRepository.watchAll().first).first;
    await logementsRepository.create(
      clientId: client.id,
      address: '3 rue de l\'intervention',
      updatedBy: 'test-uid',
    );
    final logement = (await logementsRepository.watchAll().first).first;
    return (client.id, logement.id);
  }

  test('crée une intervention avec référence et statut initial', () async {
    final (clientId, logementId) = await createClientAndLogement();

    final id = await interventionsRepository.create(
      logementId: logementId,
      clientId: clientId,
      problemDescription: 'Fuite sous évier',
      urgencyLevel: UrgencyLevel.haute,
      updatedBy: 'test-uid',
    );

    final intervention = await interventionsRepository.getById(id);
    expect(intervention, isNotNull);
    expect(intervention!.reference, 'HAV-INT-000001');
    expect(intervention.status, InterventionStatus.nouveau);
    expect(intervention.clientValidated, isFalse);
    expect(intervention.havenaMargin, isNull);
  });

  test('la marge HAVENA se calcule automatiquement quand les deux montants sont renseignés',
      () async {
    final (clientId, logementId) = await createClientAndLogement();
    final id = await interventionsRepository.create(
      logementId: logementId,
      clientId: clientId,
      problemDescription: 'Climatisation en panne',
      urgencyLevel: UrgencyLevel.normale,
      updatedBy: 'test-uid',
    );

    await interventionsRepository.updateAmounts(
      id: id,
      clientAmount: 50000,
      prestataireAmount: null,
      updatedBy: 'test-uid',
    );
    var intervention = await interventionsRepository.getById(id);
    expect(intervention!.havenaMargin, isNull);

    await interventionsRepository.updateAmounts(
      id: id,
      clientAmount: 50000,
      prestataireAmount: 35000,
      updatedBy: 'test-uid',
    );
    intervention = await interventionsRepository.getById(id);
    expect(intervention!.havenaMargin, 15000);
  });

  test('le workflow de statut avance et la suppression douce fonctionne',
      () async {
    final (clientId, logementId) = await createClientAndLogement();
    final id = await interventionsRepository.create(
      logementId: logementId,
      clientId: clientId,
      problemDescription: 'Prise électrique défectueuse',
      urgencyLevel: UrgencyLevel.critique,
      updatedBy: 'test-uid',
    );

    for (final status in [
      InterventionStatus.enAttenteDevis,
      InterventionStatus.valide,
      InterventionStatus.planifie,
      InterventionStatus.enCours,
      InterventionStatus.termine,
      InterventionStatus.paye,
      InterventionStatus.archive,
    ]) {
      await interventionsRepository.updateStatus(
        id: id,
        status: status,
        updatedBy: 'test-uid',
      );
      final intervention = await interventionsRepository.getById(id);
      expect(intervention!.status, status);
    }

    await interventionsRepository.delete(id);
    final afterDelete = await interventionsRepository.watchAll().first;
    expect(afterDelete, isEmpty);
  });
}
