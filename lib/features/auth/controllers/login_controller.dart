import 'package:get/get.dart';
import 'package:havena/app/controllers/navigation_controller.dart';
import 'package:havena/app/routes/app_routes.dart';
import 'package:havena/core/auth/role_permissions.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/auth/repositories/auth_repository.dart';

class LoginController extends GetxController {
  LoginController({
    required AuthRepository authRepository,
    required SessionController sessionController,
  })  : _authRepository = authRepository,
        _sessionController = sessionController;

  final AuthRepository _authRepository;
  final SessionController _sessionController;

  final email = ''.obs;
  final password = ''.obs;
  final isLoading = false.obs;
  final errorMessage = Rxn<String>();

  Future<void> submit() async {
    if (email.value.trim().isEmpty || password.value.isEmpty) {
      errorMessage.value = 'Email et mot de passe sont requis.';
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;
    try {
      final session = await _authRepository.login(
        email.value.trim(),
        password.value,
      );
      _sessionController.setSession(session);
      final allowedRoutes = RolePermissions.routesFor(session.role);
      Get.find<NavigationController>().changeTo(
        allowedRoutes.isNotEmpty ? allowedRoutes.first : AppRoutes.dashboard,
      );
      Get.offAllNamed(AppRoutes.dashboard);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }
}
