import 'package:get/get.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/calendrier/controllers/calendrier_controller.dart';
import 'package:havena/features/calendrier/repositories/calendrier_repository.dart';

class CalendrierBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CalendrierRepository>(() => CalendrierRepository(
          Get.find<AppDatabase>().calendrierEvenementsDao,
        ));
    Get.lazyPut<CalendrierController>(() => CalendrierController(
          Get.find<CalendrierRepository>(),
          Get.find<SessionController>(),
        ));
  }
}
