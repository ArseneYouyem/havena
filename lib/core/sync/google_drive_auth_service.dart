import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/auth_io.dart';
import 'package:havena/core/sync/google_drive_credentials_loader.dart';
import 'package:havena/core/sync/google_drive_token_cache.dart';
import 'package:url_launcher/url_launcher.dart';

/// Authentification Google (flux OAuth « installed application », cahier
/// des charges §2/§7/§14 : Drive, Sheets, Calendar via les API GCP). Ouvre
/// le navigateur système pour le consentement puis écoute la redirection
/// sur un port local (`clientViaUserConsent`), comme prévu par
/// `googleapis_auth` pour les apps de bureau. Seul le refresh token est
/// conservé localement (`GoogleDriveTokenCache`) : au démarrage suivant,
/// aucune ré-authentification navigateur n'est nécessaire tant qu'il reste
/// valide.
class GoogleDriveAuthService {
  GoogleDriveAuthService(this._credentialsLoader, this._tokenCache);

  final GoogleDriveCredentialsLoader _credentialsLoader;
  final GoogleDriveTokenCache _tokenCache;

  static const List<String> scopes = [
    drive.DriveApi.driveFileScope,
    sheets.SheetsApi.spreadsheetsScope,
  ];

  bool get isConnected => _tokenCache.read() != null;

  /// Déclenche le consentement navigateur. Ne retourne qu'une fois
  /// l'utilisateur autorisé (ou lève une exception s'il refuse/ferme).
  Future<AutoRefreshingAuthClient> connect() async {
    final clientId = await _credentialsLoader.load();
    final client = await clientViaUserConsent(clientId, scopes, (url) {
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    });
    final refreshToken = client.credentials.refreshToken;
    if (refreshToken != null) {
      await _tokenCache.save(refreshToken);
    }
    return client;
  }

  /// Reconstruit un client authentifié à partir du refresh token stocké,
  /// sans réouvrir de navigateur. Retourne `null` si jamais connecté, ou si
  /// le refresh token a été révoqué côté Google (auquel cas le cache local
  /// est nettoyé pour forcer une reconnexion propre au prochain essai).
  Future<AutoRefreshingAuthClient?> getClient() async {
    final refreshToken = _tokenCache.read();
    if (refreshToken == null) return null;
    final clientId = await _credentialsLoader.load();
    try {
      return await clientViaRefreshToken(clientId, refreshToken, scopes);
    } catch (_) {
      await _tokenCache.clear();
      return null;
    }
  }

  Future<void> disconnect() async {
    await _tokenCache.clear();
  }
}
