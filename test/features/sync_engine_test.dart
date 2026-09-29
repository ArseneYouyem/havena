import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/core/sync/sync_engine.dart';
import 'package:havena/core/sync/sync_gateway.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/clients/sync/client_sync_adapter.dart';

void main() {
  late AppDatabase database;
  late ClientsRepository repository;
  late ClientSyncAdapter adapter;
  late InMemorySyncGateway gateway;
  late SyncEngine engine;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository =
        ClientsRepository(database.clientsDao, ReferenceGeneratorService(database));
    adapter = ClientSyncAdapter(repository);
    gateway = InMemorySyncGateway();
    engine = SyncEngine(gateway);
  });

  tearDown(() async {
    await database.close();
  });

  test('un client local jamais synchronisé est poussé vers le cloud',
      () async {
    await repository.create(
      fullName: 'Client Local',
      phone: '+237600000001',
      country: 'Cameroun',
      city: 'Douala',
      clientType: 'particulier',
      status: ClientStatus.actif,
      updatedBy: 'test-uid',
    );

    final conflicts = await engine.syncEntity(adapter, lastDeviceSyncAt: null);

    expect(conflicts, isEmpty);
    final remoteDocs = await gateway.fetchAll('clients');
    expect(remoteDocs, hasLength(1));
    expect(remoteDocs.first['fullName'], 'Client Local');
  });

  test(
      'un client existant uniquement sur le cloud est récupéré localement (créé sur un autre appareil)',
      () async {
    gateway.seed('clients', 'remote-uuid-1', {
      'reference': 'HAV-CLI-000099',
      'fullName': 'Client Distant',
      'phone': '+237600000002',
      'whatsapp': null,
      'email': null,
      'country': 'Cameroun',
      'city': 'Yaoundé',
      'clientType': 'particulier',
      'logementReference': null,
      'subscriptionFormula': null,
      'startDate': null,
      'renewalDate': null,
      'status': 'actif',
      'lastContactDate': null,
      'notes': null,
      'updatedAt': DateTime(2026, 9, 1).toIso8601String(),
      'updatedBy': 'autre-appareil',
      'isDeleted': false,
    });

    final conflicts = await engine.syncEntity(adapter, lastDeviceSyncAt: null);

    expect(conflicts, isEmpty);
    final clients = await repository.watchAll().first;
    expect(clients, hasLength(1));
    expect(clients.first.fullName, 'Client Distant');
    expect(clients.first.syncId, 'remote-uuid-1');
  });

  test(
      'un enregistrement modifié seulement à distance depuis la dernière synchro est écrasé localement sans conflit',
      () async {
    await repository.create(
      fullName: 'Ancien Nom',
      phone: '+237600000003',
      country: 'Cameroun',
      city: 'Douala',
      clientType: 'particulier',
      status: ClientStatus.actif,
      updatedBy: 'test-uid',
    );
    final local = (await repository.watchAll().first).first;
    // La dernière synchro connue est juste après la création locale : le
    // local n'a donc PAS changé depuis (seul le distant va changer après).
    final lastSync = local.updatedAt.add(const Duration(seconds: 1));

    // Simule : ce même client a été modifié sur un autre appareil APRÈS la
    // dernière synchro connue, mais PAS localement ici.
    gateway.seed('clients', local.syncId!, {
      ...adapter.toFirestoreMap(local),
      'fullName': 'Nouveau Nom (modifié ailleurs)',
      'updatedAt': lastSync.add(const Duration(days: 1)).toIso8601String(),
    });

    final conflicts =
        await engine.syncEntity(adapter, lastDeviceSyncAt: lastSync);

    expect(conflicts, isEmpty);
    final updated = await repository.findBySyncId(local.syncId!);
    expect(updated!.fullName, 'Nouveau Nom (modifié ailleurs)');
  });

  test(
      'un enregistrement modifié des deux côtés depuis la dernière synchro est signalé en conflit, sans rien écraser',
      () async {
    final lastSync = DateTime(2026, 9, 1);

    await repository.create(
      fullName: 'Nom Original',
      phone: '+237600000004',
      country: 'Cameroun',
      city: 'Douala',
      clientType: 'particulier',
      status: ClientStatus.actif,
      updatedBy: 'test-uid',
    );
    var local = (await repository.watchAll().first).first;

    // Modification locale après la dernière synchro.
    await repository.update(
      id: local.id,
      fullName: 'Nom Modifié Localement',
      phone: local.phone,
      country: local.country,
      city: local.city,
      clientType: local.clientType,
      status: local.status,
      updatedBy: 'test-uid',
    );
    local = (await repository.watchAll().first).first;
    expect(local.updatedAt.isAfter(lastSync), isTrue);

    // Modification distante, également après la dernière synchro.
    gateway.seed('clients', local.syncId!, {
      ...adapter.toFirestoreMap(local),
      'fullName': 'Nom Modifié À Distance',
      'updatedAt': lastSync.add(const Duration(days: 2)).toIso8601String(),
    });

    final conflicts =
        await engine.syncEntity(adapter, lastDeviceSyncAt: lastSync);

    expect(conflicts, hasLength(1));
    expect(conflicts.first.localData['fullName'], 'Nom Modifié Localement');
    expect(conflicts.first.remoteData['fullName'], 'Nom Modifié À Distance');

    // Rien n'a été écrasé localement en attendant la résolution.
    final untouched = await repository.findBySyncId(local.syncId!);
    expect(untouched!.fullName, 'Nom Modifié Localement');
  });

  test('resolveConflict applique la donnée choisie localement et à distance',
      () async {
    await repository.create(
      fullName: 'Nom Original',
      phone: '+237600000005',
      country: 'Cameroun',
      city: 'Douala',
      clientType: 'particulier',
      status: ClientStatus.actif,
      updatedBy: 'test-uid',
    );
    final local = (await repository.watchAll().first).first;
    final localMap = adapter.toFirestoreMap(local);
    final remoteMap = {...localMap, 'fullName': 'Nom Distant'};

    final conflict = SyncConflict(
      collectionName: 'clients',
      syncId: local.syncId!,
      localData: localMap,
      remoteData: remoteMap,
    );

    await engine.resolveConflict(adapter, conflict, remoteMap);

    final resolved = await repository.findBySyncId(local.syncId!);
    expect(resolved!.fullName, 'Nom Distant');
    final remoteDocs = await gateway.fetchAll('clients');
    expect(remoteDocs.first['fullName'], 'Nom Distant');
  });
}
