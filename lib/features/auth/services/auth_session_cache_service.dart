import 'package:havena/core/storage/get_storage_service.dart';
import 'package:havena/features/auth/models/auth_session.dart';

class AuthSessionCacheService {
  AuthSessionCacheService(this._storage);

  final GetStorageService _storage;

  static const String _key = 'auth_session';

  AuthSession? read() {
    final data = _storage.read<Map<String, dynamic>>(_key);
    if (data == null) return null;
    return AuthSession.fromJson(data);
  }

  Future<void> save(AuthSession session) async {
    await _storage.write(_key, session.toJson());
  }

  Future<void> clear() async {
    await _storage.remove(_key);
  }
}
