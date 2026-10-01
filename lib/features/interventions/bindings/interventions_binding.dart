import 'package:get/get.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/calendrier/repositories/calendrier_repository.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/interventions/controllers/interventions_controller.dart';
import 'package:havena/features/interventions/repositories/interventions_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';
import 'package:havena/features/prestataires/repositories/prestataires_repository.dart';

class InterventionsBinding extends Bindings {
  @override
  void dependencies() {
    final db = Get.find<AppDatabase>();
    Get.lazyPut<InterventionsRepository>(
      () => InterventionsRepository(
        db.interventionsDao,
        Get.find<ReferenceGeneratorService>(),
        Get.find<ClientsRepository>(),
        Get.find<LogementsRepository>(),
        Get.find<PrestatairesRepository>(),
      ),
    );
    // Nécessite que LogementsBinding, ClientsBinding, PrestatairesBinding et
    // CalendrierBinding soient également enregistrées sur la page
    // (résolution paresseuse, voir ClientsBinding) : la création d'une
    // intervention enregistre automatiquement son évènement dans le
    // Calendrier.
    Get.lazyPut<InterventionsController>(
      () => InterventionsController(
        interventionsRepository: Get.find(),
        logementsRepository: Get.find(),
        clientsRepository: Get.find(),
        prestatairesRepository: Get.find(),
        photosRepository: Get.find(),
        sessionController: Get.find<SessionController>(),
        calendrierRepository: Get.find<CalendrierRepository>(),
      ),
    );
  }
}
