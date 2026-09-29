import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:havena/app/controllers/navigation_controller.dart';
import 'package:havena/app/routes/app_routes.dart';
import 'package:havena/app/theme/app_colors.dart';
import 'package:havena/core/auth/role_permissions.dart';
import 'package:havena/features/abonnements/views/abonnements_view.dart';
import 'package:havena/features/access_management/views/access_management_view.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/calendrier/views/calendrier_view.dart';
import 'package:havena/features/clients/views/clients_view.dart';
import 'package:havena/features/dashboard/views/dashboard_view.dart';
import 'package:havena/features/finances/views/finances_view.dart';
import 'package:havena/features/inspections/views/inspections_view.dart';
import 'package:havena/features/interventions/views/interventions_view.dart';
import 'package:havena/features/logements/views/logements_view.dart';
import 'package:havena/features/prestataires/views/prestataires_view.dart';
import 'package:havena/features/rapports/views/rapports_view.dart';
import 'package:havena/shared/widgets/layout/desktop_shell.dart';

class AppShellView extends GetView<NavigationController> {
  const AppShellView({super.key});

  @override
  Widget build(BuildContext context) {
    return DesktopShell(
      child: Obx(() => _buildGuardedContent(controller.currentRoute.value)),
    );
  }

  Widget _buildGuardedContent(String route) {
    final session = Get.find<SessionController>();
    final role = session.role;

    if (role == null) {
      // Pas de session valide : ne devrait pas arriver ici (géré par
      // initialRoute), mais on évite d'afficher du contenu protégé.
      return const _PlaceholderContent(title: 'HAVENA');
    }

    if (!RolePermissions.canAccess(role, route)) {
      final allowed = RolePermissions.routesFor(role);
      final fallback = allowed.isNotEmpty ? allowed.first : AppRoutes.dashboard;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.changeTo(fallback);
      });
      return const SizedBox.shrink();
    }

    return _buildContent(route);
  }

  Widget _buildContent(String route) {
    switch (route) {
      case AppRoutes.dashboard:
        return const DashboardContent();
      case AppRoutes.clients:
        return const ClientsContent();
      case AppRoutes.logements:
        return const LogementsContent();
      case AppRoutes.abonnements:
        return const AbonnementsContent();
      case AppRoutes.inspections:
        return const InspectionsContent();
      case AppRoutes.interventions:
        return const InterventionsContent();
      case AppRoutes.prestataires:
        return const PrestatairesContent();
      case AppRoutes.finances:
        return const FinancesContent();
      case AppRoutes.rapports:
        return const RapportsContent();
      case AppRoutes.calendrier:
        return const CalendrierContent();
      case AppRoutes.accessManagement:
        return const AccessManagementContent();
      default:
        return const _PlaceholderContent(title: 'HAVENA');
    }
  }
}

class _PlaceholderContent extends StatelessWidget {
  const _PlaceholderContent({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
