import 'package:havena/core/database/enums.dart';
import 'package:havena/features/auth/models/auth_session.dart';
import 'package:havena/features/auth/models/user_account.dart';
import 'package:havena/features/auth/services/auth_session_cache_service.dart';
import 'package:havena/features/auth/services/firebase_auth_service.dart';
import 'package:havena/features/auth/services/firestore_users_service.dart';

class AuthRepository {
  AuthRepository({
    required FirebaseAuthService firebaseAuthService,
    required FirestoreUsersService firestoreUsersService,
    required AuthSessionCacheService authSessionCacheService,
  })  : _firebaseAuthService = firebaseAuthService,
        _firestoreUsersService = firestoreUsersService,
        _authSessionCacheService = authSessionCacheService;

  final FirebaseAuthService _firebaseAuthService;
  final FirestoreUsersService _firestoreUsersService;
  final AuthSessionCacheService _authSessionCacheService;

  AuthSession? tryResumeSession() {
    return _authSessionCacheService.read();
  }

  Future<AuthSession> login(String email, String password) async {
    final userCredential = await _firebaseAuthService.signInWithEmail(
      email,
      password,
    );
    final uid = userCredential.user!.uid;
    final userAccount = await _firestoreUsersService.fetchUser(uid);

    if (userAccount == null || !userAccount.active) {
      await _firebaseAuthService.signOut();
      throw Exception('Compte introuvable ou désactivé.');
    }

    final session = AuthSession(
      uid: uid,
      email: userAccount.email,
      fullName: userAccount.fullName,
      role: userAccount.role,
      active: userAccount.active,
      cachedAt: DateTime.now(),
    );
    await _authSessionCacheService.save(session);
    return session;
  }

  Future<void> logout() async {
    await _firebaseAuthService.signOut();
    await _authSessionCacheService.clear();
  }

  Future<AuthSession?> refreshSessionFromRemote(String uid) async {
    final userAccount = await _firestoreUsersService.fetchUser(uid);
    if (userAccount == null || !userAccount.active) {
      await _authSessionCacheService.clear();
      return null;
    }
    final session = AuthSession(
      uid: uid,
      email: userAccount.email,
      fullName: userAccount.fullName,
      role: userAccount.role,
      active: userAccount.active,
      cachedAt: DateTime.now(),
    );
    await _authSessionCacheService.save(session);
    return session;
  }

  Future<void> createAdministrator({
    required String email,
    required String password,
    required String fullName,
    required AppRole role,
    required String createdByUid,
  }) async {
    final newUid = await _firebaseAuthService.createUserWithSecondaryApp(
      email: email,
      password: password,
    );
    final account = UserAccount(
      uid: newUid,
      email: email,
      fullName: fullName,
      role: role,
      active: true,
      createdBy: createdByUid,
    );
    await _firestoreUsersService.createUser(account);
  }

  Future<List<UserAccount>> listAllUsers() async {
    return _firestoreUsersService.listUsers();
  }

  Future<void> updateAdministrator({
    required String uid,
    required String fullName,
    required AppRole role,
  }) async {
    await _firestoreUsersService.updateUser(
      uid,
      fullName: fullName,
      role: role,
    );
  }

  Future<void> setAdministratorActive({
    required String uid,
    required bool active,
  }) async {
    await _firestoreUsersService.updateUser(uid, active: active);
  }
}
