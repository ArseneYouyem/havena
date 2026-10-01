import 'package:havena/app/routes/app_routes.dart';
import 'package:havena/core/database/enums.dart';

class RolePermissions {
  RolePermissions._();

  static const Map<AppRole, Set<String>> _routesByRole = {
    AppRole.fondatrice: {
      AppRoutes.dashboard,
      AppRoutes.clients,
      AppRoutes.logements,
      AppRoutes.abonnements,
      AppRoutes.inspections,
      AppRoutes.interventions,
      AppRoutes.prestataires,
      AppRoutes.finances,
      AppRoutes.rapports,
      AppRoutes.documents,
      AppRoutes.calendrier,
      AppRoutes.accessManagement,
    },
    AppRole.coordinateur: {
      AppRoutes.dashboard,
      AppRoutes.clients,
      AppRoutes.logements,
      AppRoutes.abonnements,
      AppRoutes.inspections,
      AppRoutes.interventions,
      AppRoutes.prestataires,
      // AppRoutes.finances : retiré (retour utilisateur) — seule la
      // Fondatrice voit les finances, y compris les cards du tableau de
      // bord (voir DashboardController.isFondatrice/dashboard_view.dart).
      AppRoutes.rapports,
      AppRoutes.documents,
      AppRoutes.calendrier,
    },
    AppRole.agent: {
      AppRoutes.inspections,
    },
  };

  static bool canAccess(AppRole role, String route) {
    final routes = _routesByRole[role];
    return routes != null && routes.contains(route);
  }

  static bool isFondatrice(AppRole role) => role == AppRole.fondatrice;

  static List<String> routesFor(AppRole role) {
    final routes = _routesByRole[role];
    if (routes == null) return [];
    const order = [
      AppRoutes.dashboard,
      AppRoutes.clients,
      AppRoutes.logements,
      AppRoutes.abonnements,
      AppRoutes.inspections,
      AppRoutes.interventions,
      AppRoutes.prestataires,
      AppRoutes.finances,
      AppRoutes.rapports,
      AppRoutes.documents,
      AppRoutes.calendrier,
      AppRoutes.accessManagement,
    ];
    return order.where((route) => routes.contains(route)).toList();
  }
}
