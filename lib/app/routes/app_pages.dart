import 'package:get/get.dart';
import 'package:havena/app/routes/app_routes.dart';
import 'package:havena/app/views/app_shell_view.dart';
import 'package:havena/features/dashboard/bindings/dashboard_binding.dart';

class AppPages {
  AppPages._();

  static final routes = <GetPage>[
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const AppShellView(),
      binding: DashboardBinding(),
    ),
  ];
}
