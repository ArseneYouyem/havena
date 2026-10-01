import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/core/sync/sync_engine.dart';
import 'package:havena/core/sync/sync_gateway.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/inspections/repositories/inspections_repository.dart';
import 'package:havena/features/inspections/sync/inspection_sync_adapter.dart';
import 'package:havena/features/interventions/repositories/interventions_repository.dart';
import 'package:havena/features/interventions/sync/intervention_sync_adapter.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';
import 'package:havena/features/prestataires/repositories/prestataires_repository.dart';

void main() {
  late AppDatabase database;
  late ClientsRepository clientsRepository;
  late LogementsRepository logementsRepository;
  late PrestatairesRepository prestatairesRepository;
  late ReferenceGeneratorService referenceGenerator;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    referenceGenerator = ReferenceGeneratorService(database);
    clientsRepository =
        ClientsRepository(database.clientsDao, referenceGenerator);
    logementsRepository = LogementsRepository(
        database.logementsDao, referenceGenerator, clientsRepository);
    prestatairesRepository =
        PrestatairesRepository(database.prestatairesDao, referenceGenerator);
  });

  tearDown(() async {
    await database.close();
  });

  Future<(int, int)> createClientAndLogement() async {
    await clientsRepository.create(
      fullName: 'Client Intervention Sync',
      phone: '+237600000040',
      country: 'Cameroun',
      city: 'Douala',
      clientType: 'particulier',
      status: ClientStatus.actif,
      updatedBy: 'test-uid',
    );
    final client = (await clientsRepository.watchAll().first).first;
    await logementsRepository.create(
        clientId: client.id, address: '20 rue Sync', updatedBy: 'test-uid');
    final logement = (await logementsRepository.watchAll().first).first;
    return (client.id, logement.id);
  }

  group('InterventionSyncAdapter (3 clés étrangères : 2 obligatoires + 1 nullable)',
      () {
    late InterventionsRepository interventionsRepository;
    late InspectionsRepository inspectionsRepository;
    late InterventionSyncAdapter adapter;
    late InMemorySyncGateway gateway;
    late SyncEngine engine;

    setUp(() {
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
      adapter = InterventionSyncAdapter(
          interventionsRepository,
          clientsRepository,
          logementsRepository,
          prestatairesRepository,
          inspectionsRepository);
      gateway = InMemorySyncGateway();
      engine = SyncEngine(gateway);
    });

    test(
        'toFirestoreMap traduit logementId/clientId et laisse prestataireSyncId absent quand prestataireId est nul',
        () async {
      final (clientId, logementId) = await createClientAndLogement();
      await interventionsRepository.create(
        logementId: logementId,
        clientId: clientId,
        problemDescription: 'Fuite',
        urgencyLevel: UrgencyLevel.normale,
        updatedBy: 'test-uid',
      );

      await adapter.allLocal();
      final intervention =
          (await interventionsRepository.watchAll().first).first;
      final map = adapter.toFirestoreMap(intervention);

      expect(map['logementSyncId'], isNotNull);
      expect(map['clientSyncId'], isNotNull);
      expect(map['prestataireSyncId'], isNull);
      expect(map.containsKey('logementId'), isFalse);
      expect(map.containsKey('clientId'), isFalse);
      expect(map.containsKey('prestataireId'), isFalse);
    });

    test(
        'upsertFromRemote retrouve les 3 parents (dont le prestataire optionnel) et traduit en id local',
        () async {
      final (clientId, logementId) = await createClientAndLogement();
      final client = (await clientsRepository.watchAll().first)
          .firstWhere((c) => c.id == clientId);
      final logement = (await logementsRepository.watchAll().first)
          .firstWhere((l) => l.id == logementId);
      await prestatairesRepository.create(
        fullName: 'Plombier Sync',
        phone: '+237600000041',
        specialty: 'Plomberie',
        status: PrestataireStatus.actif,
        updatedBy: 'test-uid',
      );
      final prestataire =
          (await prestatairesRepository.watchAll().first).first;

      gateway.seed('interventions', 'remote-intervention-1', {
        'reference': 'HAV-INT-000099',
        'logementSyncId': logement.syncId,
        'clientSyncId': client.syncId,
        'problemDescription': 'Panne électrique',
        'category': null,
        'urgencyLevel': 'haute',
        'prestataireSyncId': prestataire.syncId,
        'quoteAmount': null,
        'clientValidated': false,
        'interventionDate': null,
        'clientAmount': null,
        'prestataireAmount': null,
        'havenaMargin': null,
        'status': 'nouveau',
        'clientSatisfaction': null,
        'updatedAt': DateTime(2026, 9, 1).toIso8601String(),
        'updatedBy': 'autre-appareil',
        'isDeleted': false,
      });

      await engine.syncEntity(adapter, lastDeviceSyncAt: null);

      final interventions = await interventionsRepository.watchAll().first;
      expect(interventions, hasLength(1));
      expect(interventions.first.logementId, logement.id);
      expect(interventions.first.clientId, client.id);
      expect(interventions.first.prestataireId, prestataire.id);
    });

    test(
        'upsertFromRemote n\'insère rien si un parent obligatoire (logement ou client) est introuvable',
        () async {
      gateway.seed('interventions', 'remote-intervention-orphelin', {
        'reference': 'HAV-INT-000100',
        'logementSyncId': 'uuid-logement-jamais-synchronise',
        'clientSyncId': 'uuid-client-jamais-synchronise',
        'problemDescription': 'Fuite orpheline',
        'category': null,
        'urgencyLevel': 'normale',
        'prestataireSyncId': null,
        'quoteAmount': null,
        'clientValidated': false,
        'interventionDate': null,
        'clientAmount': null,
        'prestataireAmount': null,
        'havenaMargin': null,
        'status': 'nouveau',
        'clientSatisfaction': null,
        'updatedAt': DateTime(2026, 9, 1).toIso8601String(),
        'updatedBy': 'autre-appareil',
        'isDeleted': false,
      });

      await engine.syncEntity(adapter, lastDeviceSyncAt: null);

      final interventions = await interventionsRepository.watchAll().first;
      expect(interventions, isEmpty);
    });
  });

  group('InspectionSyncAdapter (1 clé étrangère obligatoire + agentUserId non traduit)',
      () {
    late InspectionsRepository inspectionsRepository;
    late InspectionSyncAdapter adapter;
    late InMemorySyncGateway gateway;
    late SyncEngine engine;

    setUp(() {
      inspectionsRepository = InspectionsRepository(
        database.inspectionsDao,
        database.inspectionItemsDao,
        referenceGenerator,
        logementsRepository,
      );
      adapter =
          InspectionSyncAdapter(inspectionsRepository, logementsRepository);
      gateway = InMemorySyncGateway();
      engine = SyncEngine(gateway);
    });

    test('toFirestoreMap traduit logementId et transmet agentUserId tel quel',
        () async {
      await logementsRepository.create(
          address: '30 rue Inspection Sync', updatedBy: 'test-uid');
      final logement = (await logementsRepository.watchAll().first).first;
      await inspectionsRepository.createWithChecklist(
        logementId: logement.id,
        inspectionDate: DateTime(2026, 9, 15),
        updatedBy: 'test-uid',
      );

      await adapter.allLocal();
      final inspection = (await inspectionsRepository.watchAll().first).first;
      final map = adapter.toFirestoreMap(inspection);

      expect(map['logementSyncId'], logement.syncId);
      expect(map['agentUserId'], inspection.agentUserId);
      expect(map.containsKey('logementId'), isFalse);
    });

    test(
        'upsertFromRemote n\'insère rien si le logement obligatoire est introuvable',
        () async {
      gateway.seed('inspections', 'remote-inspection-orpheline', {
        'reference': 'HAV-INS-000100',
        'logementSyncId': 'uuid-logement-jamais-synchronise',
        'agentUserId': null,
        'inspectionDate': DateTime(2026, 9, 1).toIso8601String(),
        'generalCondition': null,
        'recommendations': null,
        'isValidated': false,
        'validatedAt': null,
        'updatedAt': DateTime(2026, 9, 1).toIso8601String(),
        'updatedBy': 'autre-appareil',
        'isDeleted': false,
      });

      await engine.syncEntity(adapter, lastDeviceSyncAt: null);

      final inspections = await inspectionsRepository.watchAll().first;
      expect(inspections, isEmpty);
    });
  });
}
