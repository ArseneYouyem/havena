import 'package:get/get.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/prestataires/controllers/prestataires_controller.dart';
import 'package:havena/features/prestataires/repositories/prestataires_repository.dart';

class PrestatairesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrestatairesRepository>(() => PrestatairesRepository(
          Get.find<AppDatabase>().prestatairesDao,
          Get.find<ReferenceGeneratorService>(),
        ));
    Get.lazyPut<PrestatairesController>(() => PrestatairesController(
          Get.find<PrestatairesRepository>(),
          Get.find<SessionController>(),
        ));
  }
}
