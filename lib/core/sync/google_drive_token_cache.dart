import 'package:havena/core/storage/get_storage_service.dart';

/// Persiste uniquement le refresh token OAuth (pas l'access token, qui
/// expire vite et se régénère automatiquement à partir du refresh token via
/// `clientViaRefreshToken`). Même principe que `AuthSessionCacheService`
/// pour la session Firebase.
class GoogleDriveTokenCache {
  GoogleDriveTokenCache(this._storage);

  final GetStorageService _storage;

  static const String _key = 'google_drive_refresh_token';

  String? read() => _storage.read<String>(_key);

  Future<void> save(String refreshToken) async {
    await _storage.write(_key, refreshToken);
  }

  Future<void> clear() async {
    await _storage.remove(_key);
  }
}
