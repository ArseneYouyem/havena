import 'package:get/get.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/inspections/controllers/inspections_controller.dart';
import 'package:havena/features/inspections/repositories/inspection_items_repository.dart';
import 'package:havena/features/inspections/repositories/inspections_repository.dart';

class InspectionsBinding extends Bindings {
  @override
  void dependencies() {
    final db = Get.find<AppDatabase>();
    Get.lazyPut<InspectionsRepository>(
      () => InspectionsRepository(
        db.inspectionsDao,
        db.inspectionItemsDao,
        Get.find(),
      ),
    );
    Get.lazyPut<InspectionItemsRepository>(
      () => InspectionItemsRepository(db.inspectionItemsDao),
    );
    // Nécessite que LogementsBinding soit également enregistrée sur la page
    // pour fournir LogementsRepository.
    Get.lazyPut<InspectionsController>(
      () => InspectionsController(
        inspectionsRepository: Get.find(),
        inspectionItemsRepository: Get.find(),
        logementsRepository: Get.find(),
        photosRepository: Get.find(),
        sessionController: Get.find<SessionController>(),
      ),
    );
  }
}
