// Nécessite que ClientsBinding, InspectionsBinding et InterventionsBinding
// soient aussi enregistrés sur la page (pour ClientsRepository/
// InspectionsRepository/InterventionsRepository, utilisés par
// LogementsController pour afficher inspections/interventions liées dans
// la vue détail d'un logement, et InspectionsController/
// InterventionsController pour la navigation croisée vers leur écran de
// détail respectif).
import 'package:get/get.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/inspections/repositories/inspections_repository.dart';
import 'package:havena/features/interventions/repositories/interventions_repository.dart';
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
          Get.find<InspectionsRepository>(),
          Get.find<InterventionsRepository>(),
        ));
  }
}
