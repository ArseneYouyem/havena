import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/core/sync/sync_engine.dart';
import 'package:havena/core/sync/sync_gateway.dart';
import 'package:havena/features/calendrier/repositories/calendrier_repository.dart';
import 'package:havena/features/calendrier/sync/calendrier_sync_adapter.dart';
import 'package:havena/features/prestataires/repositories/prestataires_repository.dart';
import 'package:havena/features/prestataires/sync/prestataire_sync_adapter.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  group('PrestataireSyncAdapter', () {
    late PrestatairesRepository repository;
    late PrestataireSyncAdapter adapter;
    late InMemorySyncGateway gateway;
    late SyncEngine engine;

    setUp(() {
      repository = PrestatairesRepository(
          database.prestatairesDao, ReferenceGeneratorService(database));
      adapter = PrestataireSyncAdapter(repository);
      gateway = InMemorySyncGateway();
      engine = SyncEngine(gateway);
    });

    test('un prestataire local est poussé vers le cloud avec son statut',
        () async {
      await repository.create(
        fullName: 'Plombier Test',
        phone: '+237600000010',
        specialty: 'Plomberie',
        status: PrestataireStatus.actif,
        updatedBy: 'test-uid',
      );

      final conflicts =
          await engine.syncEntity(adapter, lastDeviceSyncAt: null);

      expect(conflicts, isEmpty);
      final docs = await gateway.fetchAll('prestataires');
      expect(docs, hasLength(1));
      expect(docs.first['status'], 'actif');
      expect(docs.first['fullName'], 'Plombier Test');
    });

    test('un prestataire créé sur un autre appareil est récupéré localement',
        () async {
      gateway.seed('prestataires', 'remote-prestataire-1', {
        'reference': 'HAV-PRE-000042',
        'fullName': 'Électricien Distant',
        'phone': '+237600000011',
        'specialty': 'Électricité',
        'zone': null,
        'experienceYears': null,
        'identityVerified': false,
        'referencesVerified': false,
        'indicativeRate': null,
        'qualityRating': 4.5,
        'punctualityRating': null,
        'communicationRating': null,
        'status': 'actif',
        'interventionsCount': 0,
        'lastInterventionDate': null,
        'observations': null,
        'updatedAt': DateTime(2026, 9, 1).toIso8601String(),
        'updatedBy': 'autre-appareil',
        'isDeleted': false,
      });

      await engine.syncEntity(adapter, lastDeviceSyncAt: null);

      final all = await repository.watchAll().first;
      expect(all, hasLength(1));
      expect(all.first.fullName, 'Électricien Distant');
      expect(all.first.qualityRating, 4.5);
      expect(all.first.status, PrestataireStatus.actif);
    });

    test('modification double depuis la dernière synchro -> conflit détecté',
        () async {
      // Date fixe dans le passé : "maintenant" (création + modification du
      // test) est nécessairement après, sans dépendre d'un écart de timing
      // serré entre deux DateTime.now() successifs.
      final lastSync = DateTime(2026, 9, 1);

      await repository.create(
        fullName: 'Nom Original',
        phone: '+237600000012',
        specialty: 'Peinture',
        status: PrestataireStatus.actif,
        updatedBy: 'test-uid',
      );
      var local = (await repository.watchAll().first).first;

      await repository.update(
        id: local.id,
        fullName: 'Nom Modifié Localement',
        phone: local.phone,
        specialty: local.specialty,
        identityVerified: local.identityVerified,
        referencesVerified: local.referencesVerified,
        status: local.status,
        updatedBy: 'test-uid',
      );
      local = (await repository.watchAll().first).first;

      gateway.seed('prestataires', local.syncId!, {
        ...adapter.toFirestoreMap(local),
        'fullName': 'Nom Modifié À Distance',
        'updatedAt':
            lastSync.add(const Duration(days: 1)).toIso8601String(),
      });

      final conflicts =
          await engine.syncEntity(adapter, lastDeviceSyncAt: lastSync);

      expect(conflicts, hasLength(1));
      expect(conflicts.first.localData['fullName'], 'Nom Modifié Localement');
      expect(conflicts.first.remoteData['fullName'], 'Nom Modifié À Distance');
    });
  });

  group('CalendrierSyncAdapter', () {
    late CalendrierRepository repository;
    late CalendrierSyncAdapter adapter;
    late InMemorySyncGateway gateway;
    late SyncEngine engine;

    setUp(() {
      repository = CalendrierRepository(database.calendrierEvenementsDao);
      adapter = CalendrierSyncAdapter(repository);
      gateway = InMemorySyncGateway();
      engine = SyncEngine(gateway);
    });

    test('un événement local est poussé vers le cloud', () async {
      await repository.create(
        eventType: CalendarEventType.rendezVous,
        title: 'Visite logement',
        eventDate: DateTime(2026, 10, 5, 10, 0),
        relatedReference: 'HAV-DLA-000001',
        status: CalendarEventStatus.planifie,
        updatedBy: 'test-uid',
      );

      final conflicts =
          await engine.syncEntity(adapter, lastDeviceSyncAt: null);

      expect(conflicts, isEmpty);
      final docs = await gateway.fetchAll('calendrier_evenements');
      expect(docs, hasLength(1));
      expect(docs.first['title'], 'Visite logement');
      expect(docs.first['eventType'], 'rendezVous');
    });

    test('un événement créé sur un autre appareil est récupéré localement',
        () async {
      gateway.seed('calendrier_evenements', 'remote-event-1', {
        'eventType': 'inspection',
        'title': 'Inspection à distance',
        'eventDate': DateTime(2026, 10, 10).toIso8601String(),
        'relatedReference': null,
        'responsibleUserId': null,
        'status': 'planifie',
        'updatedAt': DateTime(2026, 9, 1).toIso8601String(),
        'updatedBy': 'autre-appareil',
        'isDeleted': false,
      });

      await engine.syncEntity(adapter, lastDeviceSyncAt: null);

      final all = await repository.watchAll().first;
      expect(all, hasLength(1));
      expect(all.first.title, 'Inspection à distance');
      expect(all.first.eventType, CalendarEventType.inspection);
    });
  });
}
