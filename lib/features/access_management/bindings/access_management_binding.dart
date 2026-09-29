import 'package:get/get.dart';
import 'package:havena/features/access_management/controllers/access_management_controller.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/auth/repositories/auth_repository.dart';

class AccessManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccessManagementController>(
      () => AccessManagementController(
        authRepository: Get.find<AuthRepository>(),
        sessionController: Get.find<SessionController>(),
      ),
    );
  }
}
