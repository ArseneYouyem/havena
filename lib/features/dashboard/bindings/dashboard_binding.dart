import 'package:get/get.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/dashboard/controllers/dashboard_controller.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController(
          Get.find<ClientsRepository>(),
          Get.find<LogementsRepository>(),
        ));
  }
}
