import 'package:get/get.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/auth/models/user_account.dart';
import 'package:havena/features/auth/repositories/auth_repository.dart';

class AccessManagementController extends GetxController {
  AccessManagementController({
    required AuthRepository authRepository,
    required SessionController sessionController,
  })  : _authRepository = authRepository,
        _sessionController = sessionController;

  final AuthRepository _authRepository;
  final SessionController _sessionController;

  final users = <UserAccount>[].obs;
  final isLoadingUsers = false.obs;

  final newEmail = ''.obs;
  final newFullName = ''.obs;
  final newPassword = ''.obs;
  final Rxn<AppRole> newRole = Rxn<AppRole>();
  final isCreating = false.obs;
  final Rxn<String> formError = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  Future<void> loadUsers() async {
    isLoadingUsers.value = true;
    try {
      final list = await _authRepository.listAllUsers();
      users.assignAll(list);
    } catch (e) {
      formError.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoadingUsers.value = false;
    }
  }

  Future<void> addAdministrator() async {
    if (newEmail.value.trim().isEmpty ||
        newFullName.value.trim().isEmpty ||
        newPassword.value.isEmpty ||
        newRole.value == null) {
      formError.value = 'Tous les champs sont requis.';
      return;
    }

    isCreating.value = true;
    formError.value = null;
    try {
      final currentUid = _sessionController.session.value!.uid;
      await _authRepository.createAdministrator(
        email: newEmail.value.trim(),
        password: newPassword.value,
        fullName: newFullName.value.trim(),
        role: newRole.value!,
        createdByUid: currentUid,
      );
      await loadUsers();
      newEmail.value = '';
      newFullName.value = '';
      newPassword.value = '';
      newRole.value = null;
    } catch (e) {
      formError.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isCreating.value = false;
    }
  }
}
