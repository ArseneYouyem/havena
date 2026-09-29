import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:havena/app/routes/app_routes.dart';
import 'package:havena/app/theme/app_colors.dart';
import 'package:havena/features/dashboard/bindings/dashboard_binding.dart';
import 'package:havena/features/dashboard/views/dashboard_view.dart';
import 'package:havena/shared/widgets/layout/desktop_shell.dart';

class AppPages {
  AppPages._();

  static final routes = <GetPage>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const _SplashRedirect(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.clients,
      page: () => const _PlaceholderPage(
        title: 'Clients',
        route: AppRoutes.clients,
      ),
    ),
    GetPage(
      name: AppRoutes.logements,
      page: () => const _PlaceholderPage(
        title: 'Logements',
        route: AppRoutes.logements,
      ),
    ),
    GetPage(
      name: AppRoutes.abonnements,
      page: () => const _PlaceholderPage(
        title: 'Abonnements',
        route: AppRoutes.abonnements,
      ),
    ),
    GetPage(
      name: AppRoutes.inspections,
      page: () => const _PlaceholderPage(
        title: 'Inspections',
        route: AppRoutes.inspections,
      ),
    ),
    GetPage(
      name: AppRoutes.interventions,
      page: () => const _PlaceholderPage(
        title: 'Interventions',
        route: AppRoutes.interventions,
      ),
    ),
    GetPage(
      name: AppRoutes.prestataires,
      page: () => const _PlaceholderPage(
        title: 'Prestataires',
        route: AppRoutes.prestataires,
      ),
    ),
    GetPage(
      name: AppRoutes.finances,
      page: () => const _PlaceholderPage(
        title: 'Finances',
        route: AppRoutes.finances,
      ),
    ),
    GetPage(
      name: AppRoutes.rapports,
      page: () => const _PlaceholderPage(
        title: 'Rapports',
        route: AppRoutes.rapports,
      ),
    ),
    GetPage(
      name: AppRoutes.calendrier,
      page: () => const _PlaceholderPage(
        title: 'Calendrier',
        route: AppRoutes.calendrier,
      ),
    ),
  ];
}

class _SplashRedirect extends StatefulWidget {
  const _SplashRedirect();

  @override
  State<_SplashRedirect> createState() => _SplashRedirectState();
}

class _SplashRedirectState extends State<_SplashRedirect> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.offAllNamed(AppRoutes.dashboard);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({
    required this.title,
    required this.route,
  });

  final String title;
  final String route;

  @override
  Widget build(BuildContext context) {
    return DesktopShell(
      currentRoute: route,
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
