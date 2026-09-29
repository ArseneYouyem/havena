import 'package:get/get.dart';
import 'package:havena/app/routes/app_routes.dart';

class NavigationController extends GetxController {
  final Rx<String> currentRoute = AppRoutes.dashboard.obs;

  void changeTo(String route) {
    if (currentRoute.value == route) return;
    currentRoute.value = route;
  }
}
