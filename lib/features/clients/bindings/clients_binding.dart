import 'package:get/get.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/clients/controllers/clients_controller.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';

class ClientsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClientsRepository>(() => ClientsRepository(
          Get.find<AppDatabase>().clientsDao,
          Get.find<ReferenceGeneratorService>(),
        ));
    Get.lazyPut<ClientsController>(() => ClientsController(
          Get.find<ClientsRepository>(),
          Get.find<SessionController>(),
        ));
  }
}
