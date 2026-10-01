import 'package:flutter_test/flutter_test.dart';
import 'package:havena/app/routes/app_routes.dart';
import 'package:havena/core/auth/role_permissions.dart';
import 'package:havena/core/database/enums.dart';

void main() {
  group('RolePermissions', () {
    test('la fondatrice a accès à toutes les sections, y compris la gestion des accès', () {
      expect(
        RolePermissions.canAccess(AppRole.fondatrice, AppRoutes.accessManagement),
        isTrue,
      );
      expect(
        RolePermissions.canAccess(AppRole.fondatrice, AppRoutes.finances),
        isTrue,
      );
    });

    test('le coordinateur a accès aux modules métier mais pas à la gestion des accès', () {
      expect(
        RolePermissions.canAccess(AppRole.coordinateur, AppRoutes.clients),
        isTrue,
      );
      expect(
        RolePermissions.canAccess(AppRole.coordinateur, AppRoutes.finances),
        isFalse,
      );
      expect(
        RolePermissions.canAccess(AppRole.coordinateur, AppRoutes.dashboard),
        isTrue,
      );
      expect(
        RolePermissions.canAccess(AppRole.coordinateur, AppRoutes.accessManagement),
        isFalse,
      );
    });

    test('l\'agent n\'a accès qu\'aux inspections', () {
      expect(
        RolePermissions.canAccess(AppRole.agent, AppRoutes.inspections),
        isTrue,
      );
      expect(
        RolePermissions.canAccess(AppRole.agent, AppRoutes.clients),
        isFalse,
      );
      expect(
        RolePermissions.canAccess(AppRole.agent, AppRoutes.dashboard),
        isFalse,
      );
      expect(RolePermissions.routesFor(AppRole.agent), [AppRoutes.inspections]);
    });

    test('isFondatrice ne renvoie true que pour le rôle fondatrice', () {
      expect(RolePermissions.isFondatrice(AppRole.fondatrice), isTrue);
      expect(RolePermissions.isFondatrice(AppRole.coordinateur), isFalse);
      expect(RolePermissions.isFondatrice(AppRole.agent), isFalse);
    });
  });
}
