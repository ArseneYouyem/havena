// Nécessite que ClientsBinding et LogementsBinding soient aussi enregistrés
// sur la page (pour ClientsRepository et LogementsRepository, utilisés par
// AbonnementsController).
import 'package:get/get.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/features/abonnements/controllers/abonnements_controller.dart';
import 'package:havena/features/abonnements/repositories/abonnements_repository.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';

class AbonnementsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AbonnementsRepository>(() => AbonnementsRepository(
          Get.find<AppDatabase>().abonnementsDao,
          Get.find<ReferenceGeneratorService>(),
        ));
    Get.lazyPut<AbonnementsController>(() => AbonnementsController(
          Get.find<AbonnementsRepository>(),
          Get.find<ClientsRepository>(),
          Get.find<LogementsRepository>(),
          Get.find<SessionController>(),
        ));
  }
}
