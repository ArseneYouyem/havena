// Nécessite que LogementsBinding et ClientsBinding soient aussi enregistrés
// sur la page (pour LogementsRepository et ClientsRepository, utilisés par
// RapportsController).
import 'package:get/get.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';
import 'package:havena/features/rapports/controllers/rapports_controller.dart';
import 'package:havena/features/rapports/repositories/rapports_repository.dart';

class RapportsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RapportsRepository>(() => RapportsRepository(
          Get.find<AppDatabase>().rapportsDao,
          Get.find<ReferenceGeneratorService>(),
        ));
    Get.lazyPut<RapportsController>(() => RapportsController(
          Get.find<RapportsRepository>(),
          Get.find<LogementsRepository>(),
          Get.find<ClientsRepository>(),
          Get.find<SessionController>(),
        ));
  }
}
