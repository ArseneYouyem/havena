import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:havena/core/sync/sync_gateway.dart';

/// Implémentation `SyncGateway` réelle, adossée à Firestore. Le document
/// Firestore garde le même id que `syncId` (pas d'id auto-généré Firestore).
///
/// **Limite de test connue** : nécessite `Firebase.initializeApp()`, qui ne
/// fonctionne pas dans `flutter test` (même limitation que l'auth Firebase
/// et Google Drive — voir `GoogleDriveAuthService`). La logique
/// d'orchestration (`SyncEngine`) est testée séparément avec
/// `InMemorySyncGateway`, qui respecte le même contrat.
class FirestoreSyncGateway implements SyncGateway {
  FirestoreSyncGateway([FirebaseFirestore? firestore])
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Future<List<Map<String, dynamic>>> fetchAll(String collection) async {
    final snapshot = await _firestore.collection(collection).get();
    return snapshot.docs
        .map((doc) => {...doc.data(), '_syncId': doc.id})
        .toList();
  }

  @override
  Future<void> upsert(
    String collection,
    String syncId,
    Map<String, dynamic> data,
  ) {
    return _firestore.collection(collection).doc(syncId).set(data);
  }
}
