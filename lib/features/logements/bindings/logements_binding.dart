// Nécessite que ClientsBinding soit aussi enregistré sur la page
// (pour ClientsRepository, utilisé par LogementsController).
import 'package:get/get.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/logements/controllers/logements_controller.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';

class LogementsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LogementsRepository>(() => LogementsRepository(
          Get.find<AppDatabase>().logementsDao,
          Get.find<ReferenceGeneratorService>(),
          Get.find<ClientsRepository>(),
        ));
    Get.lazyPut<LogementsController>(() => LogementsController(
          Get.find<LogementsRepository>(),
          Get.find<ClientsRepository>(),
          Get.find<SessionController>(),
        ));
  }
}
