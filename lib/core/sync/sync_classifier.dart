/// Décision de synchronisation pour un enregistrement donné, en comparant
/// sa date de dernière modification locale et distante à la date de la
/// dernière synchronisation réussie de cet appareil (`lastDeviceSyncAt`).
///
/// Logique pull/merge/push actée avec l'utilisateur : un changement à sens
/// unique se met à jour automatiquement (silencieux, sans risque puisque
/// rien n'est perdu) ; seul un changement des deux côtés depuis la dernière
/// synchro connue déclenche une vraie fenêtre de résolution de conflit.
enum SyncDecision {
  /// N'existe pas (encore) côté Firestore, ou local plus récent sans
  /// changement distant depuis la dernière synchro : à envoyer.
  pushLocal,

  /// N'existe pas localement, ou distant plus récent sans changement local
  /// depuis la dernière synchro : à récupérer.
  pullRemote,

  /// Les deux côtés ont changé depuis la dernière synchro connue : à
  /// soumettre à l'utilisateur (fenêtre de résolution générique).
  conflict,

  /// Rien n'a changé d'un côté ou de l'autre depuis la dernière synchro.
  noChange,
}

class SyncClassifier {
  SyncClassifier._();

  static SyncDecision classify({
    required DateTime? localUpdatedAt,
    required DateTime? remoteUpdatedAt,
    required DateTime? lastDeviceSyncAt,
  }) {
    if (remoteUpdatedAt == null) return SyncDecision.pushLocal;
    if (localUpdatedAt == null) return SyncDecision.pullRemote;

    final remoteChanged =
        lastDeviceSyncAt == null || remoteUpdatedAt.isAfter(lastDeviceSyncAt);
    final localChanged =
        lastDeviceSyncAt == null || localUpdatedAt.isAfter(lastDeviceSyncAt);

    if (remoteChanged && localChanged) return SyncDecision.conflict;
    if (remoteChanged) return SyncDecision.pullRemote;
    if (localChanged) return SyncDecision.pushLocal;
    return SyncDecision.noChange;
  }
}
