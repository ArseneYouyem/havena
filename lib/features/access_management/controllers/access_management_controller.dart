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

  final Rxn<UserAccount> editingUser = Rxn<UserAccount>();
  final editFullName = ''.obs;
  final Rxn<AppRole> editRole = Rxn<AppRole>();
  final isEditing = false.obs;
  final Rxn<String> editFormError = Rxn<String>();

  /// Un compte ne peut jamais modifier/désactiver sa propre ligne (même
  /// garde-fou que `firestore.rules` : `request.auth.uid != uid` sur
  /// `update`) — évite une tentative vouée à échouer côté serveur.
  bool isSelf(UserAccount user) =>
      user.uid == _sessionController.session.value?.uid;

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

  void openEditDialog(UserAccount user) {
    editingUser.value = user;
    editFullName.value = user.fullName;
    editRole.value = user.role;
    editFormError.value = null;
  }

  Future<void> submitEdit() async {
    final user = editingUser.value;
    if (user == null) return;
    if (editFullName.value.trim().isEmpty || editRole.value == null) {
      editFormError.value = 'Tous les champs sont requis.';
      return;
    }

    isEditing.value = true;
    editFormError.value = null;
    try {
      await _authRepository.updateAdministrator(
        uid: user.uid,
        fullName: editFullName.value.trim(),
        role: editRole.value!,
      );
      await loadUsers();
      editingUser.value = null;
    } catch (e) {
      editFormError.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isEditing.value = false;
    }
  }

  Future<void> toggleActive(UserAccount user) async {
    if (isSelf(user)) return;
    try {
      await _authRepository.setAdministratorActive(
        uid: user.uid,
        active: !user.active,
      );
      await loadUsers();
    } catch (e) {
      formError.value = e.toString().replaceFirst('Exception: ', '');
    }
  }
}
