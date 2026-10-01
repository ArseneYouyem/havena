import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/inspections/repositories/inspections_repository.dart';
import 'package:havena/features/interventions/repositories/interventions_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';
import 'package:havena/features/prestataires/controllers/prestataires_controller.dart';
import 'package:havena/features/prestataires/repositories/prestataires_repository.dart';

void main() {
  late AppDatabase database;
  late PrestatairesRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = PrestatairesRepository(
      database.prestatairesDao,
      ReferenceGeneratorService(database),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('crée un prestataire avec référence auto-générée et notes', () async {
    await repository.create(
      fullName: 'Plombier Test',
      phone: '+237600000000',
      specialty: 'Plomberie',
      zone: 'Bonamoussadi',
      qualityRating: 4.5,
      status: PrestataireStatus.actif,
      updatedBy: 'test-uid',
    );

    final list = await repository.watchAll().first;
    expect(list, hasLength(1));
    expect(list.first.reference, 'HAV-PRE-000001');
    expect(list.first.qualityRating, 4.5);
    expect(list.first.interventionsCount, 0);
    expect(list.first.lastInterventionDate, isNull);
  });

  test('modification préserve interventionsCount, suppression douce fonctionne',
      () async {
    await repository.create(
      fullName: 'Électricien Test',
      phone: '+237600000001',
      specialty: 'Électricité',
      status: PrestataireStatus.actif,
      updatedBy: 'test-uid',
    );
    final prestataire = (await repository.watchAll().first).first;

    await repository.update(
      id: prestataire.id,
      fullName: prestataire.fullName,
      phone: prestataire.phone,
      specialty: prestataire.specialty,
      identityVerified: true,
      referencesVerified: true,
      status: PrestataireStatus.sousSurveillance,
      updatedBy: 'test-uid',
    );
    final updated = (await repository.watchAll().first).first;
    expect(updated.identityVerified, isTrue);
    expect(updated.status, PrestataireStatus.sousSurveillance);
    expect(updated.interventionsCount, 0);

    await repository.delete(prestataire.id);
    final afterDelete = await repository.watchAll().first;
    expect(afterDelete, isEmpty);
  });

  test(
      'satisfactionRatingFor/finalRatingFor/completedInterventionsCountFor '
      'dérivés des interventions confiées au prestataire', () async {
    final referenceGenerator = ReferenceGeneratorService(database);
    final clientsRepository =
        ClientsRepository(database.clientsDao, referenceGenerator);
    final logementsRepository = LogementsRepository(
        database.logementsDao, referenceGenerator, clientsRepository);
    final inspectionsRepository = InspectionsRepository(
      database.inspectionsDao,
      database.inspectionItemsDao,
      referenceGenerator,
      logementsRepository,
    );
    final interventionsRepository = InterventionsRepository(
      database.interventionsDao,
      referenceGenerator,
      clientsRepository,
      logementsRepository,
      repository,
      inspectionsRepository,
    );

    await repository.create(
      fullName: 'Plombier Noté',
      phone: '+237600000002',
      specialty: 'Plomberie',
      qualityRating: 4.0,
      punctualityRating: 5.0,
      communicationRating: 3.0,
      status: PrestataireStatus.actif,
      updatedBy: 'test-uid',
    );
    final prestataire = (await repository.watchAll().first).first;

    await clientsRepository.create(
      fullName: 'Client Prestataire',
      phone: '+237600000003',
      country: 'Cameroun',
      city: 'Douala',
      clientType: 'particulier',
      status: ClientStatus.actif,
      updatedBy: 'test-uid',
    );
    final client = (await clientsRepository.watchAll().first).first;
    await logementsRepository.create(
        clientId: client.id, address: '1 rue du prestataire', updatedBy: 'test-uid');
    final logement = (await logementsRepository.watchAll().first).first;

    final doneId1 = await interventionsRepository.create(
      logementId: logement.id,
      clientId: client.id,
      prestataireId: prestataire.id,
      problemDescription: 'Fuite 1',
      urgencyLevel: UrgencyLevel.normale,
      updatedBy: 'test-uid',
    );
    await interventionsRepository.updateStatus(
      id: doneId1,
      status: InterventionStatus.termine,
      updatedBy: 'test-uid',
    );
    await interventionsRepository.updateSatisfaction(
      id: doneId1,
      clientSatisfaction: 5,
      updatedBy: 'test-uid',
    );

    final doneId2 = await interventionsRepository.create(
      logementId: logement.id,
      clientId: client.id,
      prestataireId: prestataire.id,
      problemDescription: 'Fuite 2',
      urgencyLevel: UrgencyLevel.normale,
      updatedBy: 'test-uid',
    );
    await interventionsRepository.updateStatus(
      id: doneId2,
      status: InterventionStatus.paye,
      updatedBy: 'test-uid',
    );
    await interventionsRepository.updateSatisfaction(
      id: doneId2,
      clientSatisfaction: 3,
      updatedBy: 'test-uid',
    );

    // Intervention encore ouverte : ne compte pas comme « effectuée ».
    await interventionsRepository.create(
      logementId: logement.id,
      clientId: client.id,
      prestataireId: prestataire.id,
      problemDescription: 'Fuite 3, pas encore traitée',
      urgencyLevel: UrgencyLevel.normale,
      updatedBy: 'test-uid',
    );

    final controller = PrestatairesController(
      repository,
      SessionController(),
      interventionsRepository,
    );
    controller.onInit();
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(controller.completedInterventionsCountFor(prestataire.id), 2);
    // Satisfaction = moyenne(5, 3) = 4.0.
    expect(controller.satisfactionRatingFor(prestataire.id), 4.0);
    // Note finale = moyenne(4.0 qualité, 5.0 ponctualité, 3.0 communication,
    // 4.0 satisfaction) = 4.0.
    expect(controller.finalRatingFor(prestataire), 4.0);

    controller.onClose();
  });
}
