import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/auth_io.dart';
import 'package:havena/core/sync/google_drive_credentials_loader.dart';
import 'package:havena/core/sync/google_drive_token_cache.dart';
import 'package:havena/core/sync/shared_drive_token_gateway.dart';
import 'package:url_launcher/url_launcher.dart';

/// Authentification Google (flux OAuth « installed application », cahier
/// des charges §2/§7/§14 : Drive, Sheets, Calendar via les API GCP). Ouvre
/// le navigateur système pour le consentement puis écoute la redirection
/// sur un port local (`clientViaUserConsent`), comme prévu par
/// `googleapis_auth` pour les apps de bureau.
///
/// **Compte Drive partagé (décision utilisateur)** : le compte de
/// l'entreprise est un Gmail gratuit, donc un compte de service ne peut pas
/// s'y substituer (voir `SharedDriveTokenGateway`). Un seul appareil se
/// connecte réellement (bouton réservé à la Fondatrice côté UI,
/// `SyncStatusIndicator`) ; le refresh token obtenu est alors mis en cache
/// localement (`GoogleDriveTokenCache`, démarrage rapide sans réseau) ET
/// poussé vers Firestore (`SharedDriveTokenGateway`) pour que les autres
/// appareils le récupèrent et agissent comme le même compte Google, au lieu
/// de se connecter chacun individuellement (potentiellement avec des
/// comptes Google différents).
class GoogleDriveAuthService {
  GoogleDriveAuthService(
    this._credentialsLoader,
    this._tokenCache,
    this._sharedTokenGateway,
  );

  final GoogleDriveCredentialsLoader _credentialsLoader;
  final GoogleDriveTokenCache _tokenCache;
  final SharedDriveTokenGateway _sharedTokenGateway;

  static const List<String> scopes = [
    drive.DriveApi.driveFileScope,
    sheets.SheetsApi.spreadsheetsScope,
    calendar.CalendarApi.calendarAppCreatedScope,
  ];

  bool get isConnected => _tokenCache.read() != null;

  /// Déclenche le consentement navigateur. Ne retourne qu'une fois
  /// l'utilisateur autorisé (ou lève une exception s'il refuse/ferme). Le
  /// refresh token obtenu est partagé via Firestore ([connectedByUid], le
  /// compte HAVENA — pas Google — à l'origine de la connexion) pour que
  /// tous les appareils utilisent ensuite le même compte Google.
  Future<AutoRefreshingAuthClient> connect({
    required String connectedByUid,
  }) async {
    final clientId = await _credentialsLoader.load();
    final client = await clientViaUserConsent(clientId, scopes, (url) {
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    });
    final refreshToken = client.credentials.refreshToken;
    if (refreshToken != null) {
      await _tokenCache.save(refreshToken);
      await _sharedTokenGateway.saveRefreshToken(
        refreshToken,
        connectedByUid: connectedByUid,
      );
    }
    return client;
  }

  /// Reconstruit un client authentifié : d'abord depuis le refresh token en
  /// cache local, sinon depuis celui partagé via Firestore par l'appareil
  /// qui s'est connecté (mis en cache localement à son tour, pour ne
  /// dépendre du réseau qu'à la première synchronisation de cet appareil).
  /// Retourne `null` si jamais connecté nulle part, ou si le refresh token
  /// a été révoqué côté Google (auquel cas le cache local est nettoyé pour
  /// forcer une reconnexion propre au prochain essai).
  Future<AutoRefreshingAuthClient?> getClient() async {
    var refreshToken = _tokenCache.read();
    refreshToken ??= await _sharedTokenGateway.fetchRefreshToken();
    if (refreshToken == null) return null;
    final clientId = await _credentialsLoader.load();
    try {
      final client =
          await clientViaRefreshToken(clientId, refreshToken, scopes);
      await _tokenCache.save(refreshToken);
      return client;
    } catch (_) {
      await _tokenCache.clear();
      return null;
    }
  }

  /// Déconnecte cet appareil dans tous les cas (cache local effacé). La
  /// suppression du jeton partagé côté Firestore, elle, échoue silencieusement
  /// si l'appareil courant n'est pas la Fondatrice (seule habilitée en
  /// écriture sur ce document, voir `firestore.rules`) — un appareil qui
  /// n'a fait que réutiliser le jeton partagé ne doit pas pouvoir couper
  /// la connexion pour tout le monde.
  Future<void> disconnect() async {
    await _tokenCache.clear();
    try {
      await _sharedTokenGateway.clearRefreshToken();
    } catch (_) {
      // Permission refusée pour un appareil non-Fondatrice : attendu.
    }
  }
}
