/// Pont entre une table Drift locale et une collection Firestore
/// générique, pour un type d'entité [T]. Chaque module métier fournit sa
/// propre implémentation (ex. `ClientSyncAdapter` dans
/// `features/clients/sync/`) ; `SyncEngine` reste totalement générique et
/// ne connaît que cette interface.
///
/// Les clés étrangères (`logementId`, `clientId`...) restent des entiers
/// locaux dans les tables Drift — c'est à l'implémentation de
/// [toFirestoreMap]/[upsertLocal] de faire la traduction id local <->
/// `syncId` du parent, en s'appuyant sur le repository de ce parent.
abstract class EntitySyncAdapter<T> {
  /// Nom de la collection Firestore (ex. `'clients'`).
  String get collectionName;

  String syncIdOf(T row);

  DateTime updatedAtOf(T row);

  Future<List<T>> allLocal();

  /// Convertit une ligne locale en document générique. Les dates doivent
  /// être sérialisées en ISO 8601 (`DateTime.toIso8601String()`), jamais en
  /// `Timestamp` — voir `SyncGateway`.
  Map<String, dynamic> toFirestoreMap(T row);

  /// Crée ou met à jour la ligne locale correspondant à [syncId] à partir
  /// d'un document distant.
  Future<void> upsertLocal(Map<String, dynamic> data, {required String syncId});
}
