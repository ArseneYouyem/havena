import 'package:get/get.dart';
import 'package:havena/app/routes/app_routes.dart';
import 'package:havena/app/views/app_shell_view.dart';
import 'package:havena/features/abonnements/bindings/abonnements_binding.dart';
import 'package:havena/features/access_management/bindings/access_management_binding.dart';
import 'package:havena/features/auth/bindings/auth_binding.dart';
import 'package:havena/features/auth/views/login_view.dart';
import 'package:havena/features/clients/bindings/clients_binding.dart';
import 'package:havena/features/dashboard/bindings/dashboard_binding.dart';
import 'package:havena/features/inspections/bindings/inspections_binding.dart';
import 'package:havena/features/logements/bindings/logements_binding.dart';
import 'package:havena/features/prestataires/bindings/prestataires_binding.dart';

class AppPages {
  AppPages._();

  static final routes = <GetPage>[
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const AppShellView(),
      bindings: [
        DashboardBinding(),
        AccessManagementBinding(),
        ClientsBinding(),
        LogementsBinding(),
        AbonnementsBinding(),
        PrestatairesBinding(),
        InspectionsBinding(),
      ],
    ),
  ];
}
