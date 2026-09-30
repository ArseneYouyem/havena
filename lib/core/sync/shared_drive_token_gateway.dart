import 'package:cloud_firestore/cloud_firestore.dart';

/// Point de convergence Firestore pour que **tous les appareils utilisent le
/// même compte Google** (Drive/Sheets/Calendar), décidé avec l'utilisateur :
/// le compte de l'entreprise est un Gmail gratuit, donc un compte de service
/// seul ne peut rien y écrire (aucun quota de stockage propre, et les deux
/// façons de contourner ça — Drive partagé, délégation de domaine —
/// nécessitent Google Workspace). Un seul appareil autorise l'app (flux
/// OAuth « installed application » existant, `GoogleDriveAuthService`), puis
/// son refresh token est stocké ici pour que les autres appareils le
/// réutilisent (`clientViaRefreshToken`) au lieu de se connecter chacun avec
/// un compte Google potentiellement différent.
///
/// Deux documents distincts dans `app_config`, avec des droits d'écriture
/// différents (voir `firestore.rules`) :
/// - `google_drive_token` : le refresh token lui-même (sensible — écriture
///   réservée à la Fondatrice, seule habilitée à connecter/déconnecter le
///   compte Drive partagé, cahier des charges/décision utilisateur).
/// - `google_calendar` : l'id du calendrier secondaire « HAVENA » créé au
///   premier envoi d'évènement (non sensible — n'importe quel appareil peut
///   être le premier à le créer lors d'une synchronisation).
///
/// **Limite de test connue** : nécessite `Firebase.initializeApp()`, même
/// limite que `FirestoreSyncGateway`/`GoogleDriveAuthService` (non testable
/// dans `flutter test`).
class SharedDriveTokenGateway {
  SharedDriveTokenGateway([FirebaseFirestore? firestore])
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const String _configCollection = 'app_config';
  static const String _tokenDocId = 'google_drive_token';
  static const String _calendarDocId = 'google_calendar';

  Future<String?> fetchRefreshToken() async {
    final doc = await _firestore
        .collection(_configCollection)
        .doc(_tokenDocId)
        .get();
    return doc.data()?['refreshToken'] as String?;
  }

  Future<void> saveRefreshToken(
    String refreshToken, {
    required String connectedByUid,
  }) {
    return _firestore.collection(_configCollection).doc(_tokenDocId).set({
      'refreshToken': refreshToken,
      'connectedByUid': connectedByUid,
      'connectedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> clearRefreshToken() {
    return _firestore.collection(_configCollection).doc(_tokenDocId).delete();
  }

  Future<String?> fetchCalendarId() async {
    final doc = await _firestore
        .collection(_configCollection)
        .doc(_calendarDocId)
        .get();
    return doc.data()?['calendarId'] as String?;
  }

  Future<void> saveCalendarId(String calendarId) {
    return _firestore
        .collection(_configCollection)
        .doc(_calendarDocId)
        .set({'calendarId': calendarId});
  }
}
