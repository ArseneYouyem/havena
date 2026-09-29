import 'package:get/get.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/interventions/controllers/interventions_controller.dart';
import 'package:havena/features/interventions/repositories/interventions_repository.dart';

class InterventionsBinding extends Bindings {
  @override
  void dependencies() {
    final db = Get.find<AppDatabase>();
    Get.lazyPut<InterventionsRepository>(
      () => InterventionsRepository(
        db.interventionsDao,
        Get.find(),
      ),
    );
    // Nécessite que LogementsBinding, ClientsBinding et PrestatairesBinding
    // soient également enregistrées sur la page pour fournir leurs repositories.
    Get.lazyPut<InterventionsController>(
      () => InterventionsController(
        interventionsRepository: Get.find(),
        logementsRepository: Get.find(),
        clientsRepository: Get.find(),
        prestatairesRepository: Get.find(),
        photosRepository: Get.find(),
        sessionController: Get.find<SessionController>(),
      ),
    );
  }
}
