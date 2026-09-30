import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/features/abonnements/repositories/abonnements_repository.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/dashboard/controllers/dashboard_controller.dart';
import 'package:havena/features/interventions/repositories/interventions_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';
import 'package:havena/features/prestataires/repositories/prestataires_repository.dart';

void main() {
  late AppDatabase database;
  late ClientsRepository clientsRepository;
  late LogementsRepository logementsRepository;
  late InterventionsRepository interventionsRepository;
  late AbonnementsRepository abonnementsRepository;
  late DashboardController controller;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    final referenceGenerator = ReferenceGeneratorService(database);
    clientsRepository =
        ClientsRepository(database.clientsDao, referenceGenerator);
    logementsRepository = LogementsRepository(
        database.logementsDao, referenceGenerator, clientsRepository);
    final prestatairesRepository =
        PrestatairesRepository(database.prestatairesDao, referenceGenerator);
    interventionsRepository = InterventionsRepository(
      database.interventionsDao,
      referenceGenerator,
      clientsRepository,
      logementsRepository,
      prestatairesRepository,
    );
    abonnementsRepository = AbonnementsRepository(database.abonnementsDao,
        referenceGenerator, clientsRepository, logementsRepository);

    controller = DashboardController(
      clientsRepository,
      logementsRepository,
      interventionsRepository,
      abonnementsRepository,
    );
    controller.onInit();
  });

  tearDown(() {
    controller.onClose();
    database.close();
  });

  Future<(int, int)> createClientAndLogement() async {
    await clientsRepository.create(
      fullName: 'Client Dashboard',
      phone: '+237600000050',
      country: 'Cameroun',
      city: 'Douala',
      clientType: 'particulier',
      status: ClientStatus.actif,
      updatedBy: 'test-uid',
    );
    final client = (await clientsRepository.watchAll().first).first;
    await logementsRepository.create(
        clientId: client.id, address: '40 rue Dashboard', updatedBy: 'test-uid');
    final logement = (await logementsRepository.watchAll().first).first;
    return (client.id, logement.id);
  }

  test(
      'interventionsEnCours ne compte pas les interventions terminées/payées/archivées',
      () async {
    final (clientId, logementId) = await createClientAndLogement();

    final activeId = await interventionsRepository.create(
      logementId: logementId,
      clientId: clientId,
      problemDescription: 'Active',
      urgencyLevel: UrgencyLevel.normale,
      updatedBy: 'test-uid',
    );
    final doneId = await interventionsRepository.create(
      logementId: logementId,
      clientId: clientId,
      problemDescription: 'Terminée',
      urgencyLevel: UrgencyLevel.normale,
      updatedBy: 'test-uid',
    );
    await interventionsRepository.updateStatus(
      id: doneId,
      status: InterventionStatus.termine,
      updatedBy: 'test-uid',
    );
    await interventionsRepository.updateStatus(
      id: activeId,
      status: InterventionStatus.planifie,
      updatedBy: 'test-uid',
    );

    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(controller.interventionsEnCours.value, 1);
  });

  test('abonnementsActifs compte tous les abonnements non supprimés',
      () async {
    final (clientId, logementId) = await createClientAndLogement();

    await abonnementsRepository.create(
      clientId: clientId,
      logementId: logementId,
      formula: 'Standard',
      monthlyPrice: 25000,
      startDate: DateTime(2026, 1, 1),
      paymentStatus: PaymentStatus.aJour,
      updatedBy: 'test-uid',
    );
    await abonnementsRepository.create(
      clientId: clientId,
      logementId: logementId,
      formula: 'Premium',
      monthlyPrice: 45000,
      startDate: DateTime(2026, 1, 1),
      paymentStatus: PaymentStatus.enRetard,
      updatedBy: 'test-uid',
    );

    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(controller.abonnementsActifs.value, 2);
  });
}
