import 'package:get/get.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/features/abonnements/repositories/abonnements_repository.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/clients/controllers/clients_controller.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';

class ClientsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClientsRepository>(() => ClientsRepository(
          Get.find<AppDatabase>().clientsDao,
          Get.find<ReferenceGeneratorService>(),
        ));
    // `LogementsRepository`/`AbonnementsRepository` sont résolus
    // paresseusement (premier `Get.find` déclenché seulement à la
    // construction de `ClientsController`, donc après l'enregistrement de
    // tous les bindings) : leurs propres bindings peuvent rester déclarés
    // après `ClientsBinding` dans `AppPages` sans provoquer d'erreur d'ordre.
    Get.lazyPut<ClientsController>(() => ClientsController(
          Get.find<ClientsRepository>(),
          Get.find<SessionController>(),
          Get.find<LogementsRepository>(),
          Get.find<AbonnementsRepository>(),
        ));
  }
}
