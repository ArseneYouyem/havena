import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/core/sync/sync_engine.dart';
import 'package:havena/core/sync/sync_gateway.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';
import 'package:havena/features/logements/sync/logement_sync_adapter.dart';
import 'package:havena/features/rapports/repositories/rapports_repository.dart';
import 'package:havena/features/rapports/sync/rapport_sync_adapter.dart';

void main() {
  late AppDatabase database;
  late ClientsRepository clientsRepository;
  late LogementsRepository logementsRepository;
  late ReferenceGeneratorService referenceGenerator;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    referenceGenerator = ReferenceGeneratorService(database);
    clientsRepository =
        ClientsRepository(database.clientsDao, referenceGenerator);
    logementsRepository = LogementsRepository(
        database.logementsDao, referenceGenerator, clientsRepository);
  });

  tearDown(() async {
    await database.close();
  });

  group('LogementSyncAdapter (clé étrangère clientId nullable)', () {
    late LogementSyncAdapter adapter;
    late InMemorySyncGateway gateway;
    late SyncEngine engine;

    setUp(() {
      adapter = LogementSyncAdapter(logementsRepository, clientsRepository);
      gateway = InMemorySyncGateway();
      engine = SyncEngine(gateway);
    });

    test(
        'toFirestoreMap traduit clientId (entier local) en clientSyncId (UUID)',
        () async {
      await clientsRepository.create(
        fullName: 'Client Propriétaire',
        phone: '+237600000020',
        country: 'Cameroun',
        city: 'Douala',
        clientType: 'particulier',
        status: ClientStatus.actif,
        updatedBy: 'test-uid',
      );
      final client = (await clientsRepository.watchAll().first).first;
      await logementsRepository.create(
          clientId: client.id, address: '1 rue FK', updatedBy: 'test-uid');

      await adapter.allLocal();
      final logement = (await logementsRepository.watchAll().first).first;
      final map = adapter.toFirestoreMap(logement);

      expect(map['clientSyncId'], client.syncId);
      expect(map.containsKey('clientId'), isFalse);
    });

    test(
        'upsertFromRemote retrouve le client local via clientSyncId et traduit en id local',
        () async {
      await clientsRepository.create(
        fullName: 'Client Existant',
        phone: '+237600000021',
        country: 'Cameroun',
        city: 'Yaoundé',
        clientType: 'particulier',
        status: ClientStatus.actif,
        updatedBy: 'test-uid',
      );
      final client = (await clientsRepository.watchAll().first).first;

      gateway.seed('logements', 'remote-logement-1', {
        'reference': 'HAV-DLA-000099',
        'clientSyncId': client.syncId,
        'address': 'Adresse distante',
        'neighborhood': null,
        'housingType': null,
        'bedroomsCount': null,
        'occupancy': null,
        'localContact': null,
        'guardian': null,
        'keysCount': null,
        'mainEquipment': null,
        'lastInspectionDate': null,
        'nextInspectionDate': null,
        'generalCondition': null,
        'notes': null,
        'updatedAt': DateTime(2026, 9, 1).toIso8601String(),
        'updatedBy': 'autre-appareil',
        'isDeleted': false,
      });

      await engine.syncEntity(adapter, lastDeviceSyncAt: null);

      final logements = await logementsRepository.watchAll().first;
      expect(logements, hasLength(1));
      expect(logements.first.clientId, client.id);
    });

    test(
        'upsertFromRemote met clientId à null si le client référencé est introuvable localement (pas de blocage)',
        () async {
      gateway.seed('logements', 'remote-logement-2', {
        'reference': 'HAV-DLA-000100',
        'clientSyncId': 'uuid-client-jamais-synchronise',
        'address': 'Adresse orpheline',
        'neighborhood': null,
        'housingType': null,
        'bedroomsCount': null,
        'occupancy': null,
        'localContact': null,
        'guardian': null,
        'keysCount': null,
        'mainEquipment': null,
        'lastInspectionDate': null,
        'nextInspectionDate': null,
        'generalCondition': null,
        'notes': null,
        'updatedAt': DateTime(2026, 9, 1).toIso8601String(),
        'updatedBy': 'autre-appareil',
        'isDeleted': false,
      });

      await engine.syncEntity(adapter, lastDeviceSyncAt: null);

      final logements = await logementsRepository.watchAll().first;
      expect(logements, hasLength(1));
      expect(logements.first.clientId, isNull);
    });
  });

  group('RapportSyncAdapter (clé étrangère logementId obligatoire)', () {
    late RapportsRepository rapportsRepository;
    late RapportSyncAdapter adapter;
    late InMemorySyncGateway gateway;
    late SyncEngine engine;

    setUp(() {
      rapportsRepository = RapportsRepository(
          database.rapportsDao, referenceGenerator, logementsRepository);
      adapter = RapportSyncAdapter(rapportsRepository, logementsRepository);
      gateway = InMemorySyncGateway();
      engine = SyncEngine(gateway);
    });

    test(
        'toFirestoreMap traduit logementId (entier local) en logementSyncId (UUID)',
        () async {
      await logementsRepository.create(
          address: '2 rue Rapport', updatedBy: 'test-uid');
      final logement = (await logementsRepository.watchAll().first).first;
      await rapportsRepository.create(
        logementId: logement.id,
        periodMonth: '2026-09',
        inspectionDone: false,
        updatedBy: 'test-uid',
      );

      await adapter.allLocal();
      final rapport = (await rapportsRepository.watchAll().first).first;
      final map = adapter.toFirestoreMap(rapport);

      expect(map['logementSyncId'], logement.syncId);
      expect(map.containsKey('logementId'), isFalse);
    });

    test(
        'upsertFromRemote retrouve le logement local via logementSyncId et traduit en id local',
        () async {
      await logementsRepository.create(
          address: '3 rue Rapport Distant', updatedBy: 'test-uid');
      final logement = (await logementsRepository.watchAll().first).first;

      gateway.seed('rapports', 'remote-rapport-1', {
        'reference': 'HAV-RAP-000099',
        'logementSyncId': logement.syncId,
        'periodMonth': '2026-09',
        'generalCondition': null,
        'inspectionDone': true,
        'anomalies': null,
        'interventionsDone': null,
        'totalExpenses': null,
        'recommendations': null,
        'nextActions': null,
        'pdfLocalPath': null,
        'generatedAt': null,
        'updatedAt': DateTime(2026, 9, 1).toIso8601String(),
        'updatedBy': 'autre-appareil',
        'isDeleted': false,
      });

      await engine.syncEntity(adapter, lastDeviceSyncAt: null);

      final rapports = await rapportsRepository.watchAll().first;
      expect(rapports, hasLength(1));
      expect(rapports.first.logementId, logement.id);
    });

    test(
        'upsertFromRemote n\'insère rien si le logement référencé (obligatoire) est introuvable localement',
        () async {
      gateway.seed('rapports', 'remote-rapport-orphelin', {
        'reference': 'HAV-RAP-000100',
        'logementSyncId': 'uuid-logement-jamais-synchronise',
        'periodMonth': '2026-09',
        'generalCondition': null,
        'inspectionDone': false,
        'anomalies': null,
        'interventionsDone': null,
        'totalExpenses': null,
        'recommendations': null,
        'nextActions': null,
        'pdfLocalPath': null,
        'generatedAt': null,
        'updatedAt': DateTime(2026, 9, 1).toIso8601String(),
        'updatedBy': 'autre-appareil',
        'isDeleted': false,
      });

      await engine.syncEntity(adapter, lastDeviceSyncAt: null);

      final rapports = await rapportsRepository.watchAll().first;
      expect(rapports, isEmpty);
    });
  });
}
