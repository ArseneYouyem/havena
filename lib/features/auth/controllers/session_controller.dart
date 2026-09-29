import 'package:get/get.dart';
import 'package:havena/core/auth/role_permissions.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/features/auth/models/auth_session.dart';

class SessionController extends GetxController {
  final Rxn<AuthSession> session = Rxn<AuthSession>();

  AppRole? get role => session.value?.role;

  bool get isFondatrice => role != null && RolePermissions.isFondatrice(role!);

  bool get isLoggedIn => session.value != null;

  bool canAccess(String route) =>
      role != null && RolePermissions.canAccess(role!, route);

  void setSession(AuthSession newSession) => session.value = newSession;

  void clear() => session.value = null;
}
