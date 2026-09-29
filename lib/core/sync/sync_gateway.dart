/// Accès à une « collection » distante de documents génériques (clé =
/// `syncId`). Toutes les dates sont représentées en chaînes ISO 8601 dans
/// les `Map`, jamais en `Timestamp` Firestore — ça garde le moteur de
/// synchronisation (`SyncEngine`) totalement indépendant de `cloud_firestore`.
abstract class SyncGateway {
  Future<List<Map<String, dynamic>>> fetchAll(String collection);

  Future<void> upsert(
    String collection,
    String syncId,
    Map<String, dynamic> data,
  );
}

/// Implémentation en mémoire, réelle (pas un mock) : utile pour un mode
/// hors-ligne pur, et pour tester `SyncEngine` de bout en bout sans réseau
/// ni Firebase (même principe que `NativeDatabase.memory()` pour Drift).
class InMemorySyncGateway implements SyncGateway {
  final Map<String, Map<String, Map<String, dynamic>>> _store = {};

  @override
  Future<List<Map<String, dynamic>>> fetchAll(String collection) async {
    final docs = _store[collection];
    if (docs == null) return [];
    return docs.entries
        .map((entry) => {...entry.value, '_syncId': entry.key})
        .toList();
  }

  @override
  Future<void> upsert(
    String collection,
    String syncId,
    Map<String, dynamic> data,
  ) async {
    final docs = _store.putIfAbsent(collection, () => {});
    docs[syncId] = Map<String, dynamic>.from(data);
  }

  /// Pour les tests : place directement un document, comme si un autre
  /// appareil l'avait déjà synchronisé.
  void seed(String collection, String syncId, Map<String, dynamic> data) {
    final docs = _store.putIfAbsent(collection, () => {});
    docs[syncId] = Map<String, dynamic>.from(data);
  }
}
