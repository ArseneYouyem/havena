import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:havena/app/controllers/reference_search_controller.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/features/abonnements/repositories/abonnements_repository.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/finances/repositories/finances_repository.dart';
import 'package:havena/features/inspections/repositories/inspections_repository.dart';
import 'package:havena/features/interventions/repositories/interventions_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';
import 'package:havena/features/prestataires/repositories/prestataires_repository.dart';
import 'package:havena/features/rapports/repositories/rapports_repository.dart';

void main() {
  late AppDatabase database;
  late ClientsRepository clientsRepository;
  late LogementsRepository logementsRepository;
  late AbonnementsRepository abonnementsRepository;
  late InterventionsRepository interventionsRepository;
  late PrestatairesRepository prestatairesRepository;
  late FinancesRepository financesRepository;
  late RapportsRepository rapportsRepository;
  late InspectionsRepository inspectionsRepository;
  late ReferenceSearchController controller;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    final referenceGenerator = ReferenceGeneratorService(database);
    clientsRepository =
        ClientsRepository(database.clientsDao, referenceGenerator);
    logementsRepository = LogementsRepository(
        database.logementsDao, referenceGenerator, clientsRepository);
    abonnementsRepository = AbonnementsRepository(database.abonnementsDao,
        referenceGenerator, clientsRepository, logementsRepository);
    prestatairesRepository =
        PrestatairesRepository(database.prestatairesDao, referenceGenerator);
    interventionsRepository = InterventionsRepository(
      database.interventionsDao,
      referenceGenerator,
      clientsRepository,
      logementsRepository,
      prestatairesRepository,
    );
    financesRepository = FinancesRepository(database.financesDao,
        referenceGenerator, clientsRepository, prestatairesRepository);
    rapportsRepository = RapportsRepository(
        database.rapportsDao, referenceGenerator, logementsRepository);
    inspectionsRepository = InspectionsRepository(
      database.inspectionsDao,
      database.inspectionItemsDao,
      referenceGenerator,
      logementsRepository,
    );

    controller = ReferenceSearchController(
      clientsRepository: clientsRepository,
      logementsRepository: logementsRepository,
      abonnementsRepository: abonnementsRepository,
      interventionsRepository: interventionsRepository,
      prestatairesRepository: prestatairesRepository,
      financesRepository: financesRepository,
      rapportsRepository: rapportsRepository,
      inspectionsRepository: inspectionsRepository,
    );
  });

  tearDown(() async {
    await database.close();
  });

  Future<void> refreshControllerLists() async {
    controller.clients.value = await clientsRepository.watchAll().first;
    controller.logements.value = await logementsRepository.watchAll().first;
    controller.abonnements.value =
        await abonnementsRepository.watchAll().first;
    controller.interventions.value =
        await interventionsRepository.watchAll().first;
    controller.prestataires.value =
        await prestatairesRepository.watchAll().first;
    controller.finances.value = await financesRepository.watchAll().first;
    controller.rapports.value = await rapportsRepository.watchAll().first;
    controller.inspections.value =
        await inspectionsRepository.watchAll().first;
  }

  test(
      'retrouve un logement par référence et liste le client, l\'abonnement et l\'intervention liés',
      () async {
    await clientsRepository.create(
      fullName: 'Client Référence',
      phone: '+237600000020',
      country: 'Cameroun',
      city: 'Douala',
      clientType: 'particulier',
      status: ClientStatus.actif,
      updatedBy: 'test-uid',
    );
    final client = (await clientsRepository.watchAll().first).first;

    await logementsRepository.create(
      clientId: client.id,
      address: '1 rue de la recherche',
      updatedBy: 'test-uid',
    );
    final logement = (await logementsRepository.watchAll().first).first;

    await abonnementsRepository.create(
      clientId: client.id,
      logementId: logement.id,
      formula: 'Standard',
      monthlyPrice: 20000,
      startDate: DateTime(2026, 1, 1),
      paymentStatus: PaymentStatus.aJour,
      updatedBy: 'test-uid',
    );

    await interventionsRepository.create(
      logementId: logement.id,
      clientId: client.id,
      problemDescription: 'Panne électrique',
      urgencyLevel: UrgencyLevel.haute,
      updatedBy: 'test-uid',
    );

    await refreshControllerLists();

    final results = controller.search(logement.reference);
    expect(results, hasLength(1));
    expect(results.first.type, ReferenceEntityType.logement);
    expect(results.first.reference, logement.reference);

    final related = controller.relatedFor(results.first);
    expect(related.any((r) => r.type == ReferenceEntityType.client), isTrue);
    expect(
        related.any((r) => r.type == ReferenceEntityType.abonnement), isTrue);
    expect(related.any((r) => r.type == ReferenceEntityType.intervention),
        isTrue);

    final details = controller.detailsFor(results.first);
    expect(details.any((e) => e.key == 'Adresse'), isTrue);
  });

  test('recherche insensible à la casse sur une partie du nom du client',
      () async {
    await clientsRepository.create(
      fullName: 'Aimé Fabrice',
      phone: '+237600000021',
      country: 'Cameroun',
      city: 'Yaoundé',
      clientType: 'particulier',
      status: ClientStatus.actif,
      updatedBy: 'test-uid',
    );
    await refreshControllerLists();

    final results = controller.search('aimé');
    expect(results, hasLength(1));
    expect(results.first.type, ReferenceEntityType.client);
  });

  test('recherche sans correspondance renvoie une liste vide', () async {
    await refreshControllerLists();
    expect(controller.search('HAV-INEXISTANT'), isEmpty);
  });
}
