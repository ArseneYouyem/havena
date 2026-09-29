import 'package:havena/core/sync/entity_sync_adapter.dart';
import 'package:havena/core/sync/sync_classifier.dart';
import 'package:havena/core/sync/sync_gateway.dart';

/// Un conflit détecté pour un enregistrement précis : les deux côtés ont
/// changé depuis la dernière synchronisation connue de cet appareil.
/// Généré par [SyncEngine.syncEntity] et destiné à une fenêtre de
/// résolution générique (indépendante du type d'entité) côté UI.
class SyncConflict {
  const SyncConflict({
    required this.collectionName,
    required this.syncId,
    required this.localData,
    required this.remoteData,
  });

  final String collectionName;
  final String syncId;
  final Map<String, dynamic> localData;
  final Map<String, dynamic> remoteData;
}

/// Orchestre pull → merge → push pour un type d'entité, en s'appuyant sur
/// [EntitySyncAdapter] (pont vers la table locale) et [SyncGateway] (accès
/// à la collection distante). Ne connaît ni Drift ni `cloud_firestore`
/// directement — entièrement testable avec `InMemorySyncGateway`.
class SyncEngine {
  SyncEngine(this._gateway);

  final SyncGateway _gateway;

  /// Synchronise une entité. Les conflits ne sont PAS résolus ici : ils
  /// sont retournés pour qu'une fenêtre de résolution générique les
  /// présente à l'utilisateur (cahier des charges : dernière modification
  /// gagne uniquement pour les changements à sens unique).
  Future<List<SyncConflict>> syncEntity<T>(
    EntitySyncAdapter<T> adapter, {
    required DateTime? lastDeviceSyncAt,
  }) async {
    final remoteDocs = await _gateway.fetchAll(adapter.collectionName);
    final remoteBySyncId = <String, Map<String, dynamic>>{
      for (final doc in remoteDocs) doc['_syncId'] as String: doc,
    };

    final localRows = await adapter.allLocal();
    final conflicts = <SyncConflict>[];
    final handledSyncIds = <String>{};

    for (final local in localRows) {
      final syncId = adapter.syncIdOf(local);
      handledSyncIds.add(syncId);
      final remote = remoteBySyncId[syncId];

      final decision = SyncClassifier.classify(
        localUpdatedAt: adapter.updatedAtOf(local),
        remoteUpdatedAt: remote == null
            ? null
            : DateTime.parse(remote['updatedAt'] as String),
        lastDeviceSyncAt: lastDeviceSyncAt,
      );

      switch (decision) {
        case SyncDecision.pushLocal:
        case SyncDecision.noChange:
          await _gateway.upsert(
            adapter.collectionName,
            syncId,
            adapter.toFirestoreMap(local),
          );
          break;
        case SyncDecision.pullRemote:
          await adapter.upsertLocal(remote!, syncId: syncId);
          break;
        case SyncDecision.conflict:
          conflicts.add(SyncConflict(
            collectionName: adapter.collectionName,
            syncId: syncId,
            localData: adapter.toFirestoreMap(local),
            remoteData: remote!,
          ));
          break;
      }
    }

    // Enregistrements qui n'existent que côté distant (créés sur un autre
    // appareil, jamais vus localement) : aucun conflit possible, on les
    // récupère directement.
    for (final entry in remoteBySyncId.entries) {
      if (!handledSyncIds.contains(entry.key)) {
        await adapter.upsertLocal(entry.value, syncId: entry.key);
      }
    }

    return conflicts;
  }

  /// Applique la résolution d'un conflit (choix global ou champ par champ,
  /// voir `FieldMergeResolver`) : écrit le résultat à la fois localement et
  /// sur la collection distante.
  Future<void> resolveConflict<T>(
    EntitySyncAdapter<T> adapter,
    SyncConflict conflict,
    Map<String, dynamic> resolvedData,
  ) async {
    await adapter.upsertLocal(resolvedData, syncId: conflict.syncId);
    await _gateway.upsert(
      adapter.collectionName,
      conflict.syncId,
      resolvedData,
    );
  }
}
