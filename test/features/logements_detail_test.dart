import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/inspections/repositories/inspections_repository.dart';
import 'package:havena/features/interventions/repositories/interventions_repository.dart';
import 'package:havena/features/logements/controllers/logements_controller.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';
import 'package:havena/features/prestataires/repositories/prestataires_repository.dart';

void main() {
  late AppDatabase database;
  late ClientsRepository clientsRepository;
  late LogementsRepository logementsRepository;
  late InspectionsRepository inspectionsRepository;
  late InterventionsRepository interventionsRepository;
  late LogementsController controller;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    final referenceGenerator = ReferenceGeneratorService(database);
    clientsRepository =
        ClientsRepository(database.clientsDao, referenceGenerator);
    logementsRepository = LogementsRepository(
        database.logementsDao, referenceGenerator, clientsRepository);
    final prestatairesRepository =
        PrestatairesRepository(database.prestatairesDao, referenceGenerator);
    inspectionsRepository = InspectionsRepository(
      database.inspectionsDao,
      database.inspectionItemsDao,
      referenceGenerator,
      logementsRepository,
    );
    interventionsRepository = InterventionsRepository(
      database.interventionsDao,
      referenceGenerator,
      clientsRepository,
      logementsRepository,
      prestatairesRepository,
      inspectionsRepository,
    );

    controller = LogementsController(
      logementsRepository,
      clientsRepository,
      SessionController(),
      inspectionsRepository,
      interventionsRepository,
    );
    controller.onInit();
  });

  tearDown(() {
    controller.onClose();
    database.close();
  });

  test(
      'inspectionsForSelected/interventionsForSelected ne retournent que '
      'celles du logement sélectionné', () async {
    await clientsRepository.create(
      fullName: 'Client Détail',
      phone: '+237600000090',
      country: 'Cameroun',
      city: 'Douala',
      clientType: 'particulier',
      status: ClientStatus.actif,
      updatedBy: 'test-uid',
    );
    final client = (await clientsRepository.watchAll().first).first;

    await logementsRepository.create(
        clientId: client.id, address: 'Logement A', updatedBy: 'test-uid');
    await logementsRepository.create(
        clientId: client.id, address: 'Logement B', updatedBy: 'test-uid');
    final logements = await logementsRepository.watchAll().first;
    final logementA = logements.firstWhere((l) => l.address == 'Logement A');
    final logementB = logements.firstWhere((l) => l.address == 'Logement B');

    await inspectionsRepository.createWithChecklist(
      logementId: logementA.id,
      inspectionDate: DateTime(2026, 9, 1),
      updatedBy: 'test-uid',
    );
    await inspectionsRepository.createWithChecklist(
      logementId: logementB.id,
      inspectionDate: DateTime(2026, 9, 2),
      updatedBy: 'test-uid',
    );
    await interventionsRepository.create(
      logementId: logementA.id,
      clientId: client.id,
      problemDescription: 'Problème A',
      urgencyLevel: UrgencyLevel.normale,
      updatedBy: 'test-uid',
    );
    await interventionsRepository.create(
      logementId: logementB.id,
      clientId: client.id,
      problemDescription: 'Problème B',
      urgencyLevel: UrgencyLevel.normale,
      updatedBy: 'test-uid',
    );

    await Future<void>.delayed(const Duration(milliseconds: 50));
    controller.selectLogement(logementA.id);

    final inspections = controller.inspectionsForSelected();
    final interventions = controller.interventionsForSelected();
    expect(inspections, hasLength(1));
    expect(inspections.first.logementId, logementA.id);
    expect(interventions, hasLength(1));
    expect(interventions.first.problemDescription, 'Problème A');
  });
}
