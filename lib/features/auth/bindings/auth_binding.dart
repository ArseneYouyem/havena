import 'package:get/get.dart';
import 'package:havena/features/auth/controllers/login_controller.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/auth/repositories/auth_repository.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(
        authRepository: Get.find<AuthRepository>(),
        sessionController: Get.find<SessionController>(),
      ),
    );
  }
}
