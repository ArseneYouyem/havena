import 'package:havena/shared/widgets/layout/page_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:havena/app/theme/app_colors.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/features/access_management/controllers/access_management_controller.dart';
import 'package:havena/features/access_management/models/role_info.dart';
import 'package:havena/features/auth/models/user_account.dart';

class AccessManagementContent extends GetView<AccessManagementController> {
  const AccessManagementContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Mesure le contenu le plus long pour garder toutes les cartes à la
    // même hauteur, y compris lorsque la taille du texte augmente.
    var roleCardHeight = 0.0;
    for (final info in RoleInfo.all) {
      double measure(String text, TextStyle style) {
        final painter = TextPainter(
          text: TextSpan(
            text: text,
            style: DefaultTextStyle.of(context).style.merge(style),
          ),
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
        )..layout(maxWidth: 248);
        final height = painter.height;
        painter.dispose();
        return height;
      }

      final height =
          40 +
          measure(
            info.label,
            const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ) +
          measure(
            info.description,
            const TextStyle(color: AppColors.textSecondary),
          );
      if (height > roleCardHeight) roleCardHeight = height;
    }
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: 'Rôles et permissions',
            subtitle:
                'Définissez les rôles et gérez les accès de votre équipe.',
            icon: Icons.admin_panel_settings_outlined,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: RoleInfo.all.map((info) {
              final accent = info.role == AppRole.coordinateur
                  ? AppColors.secondaryText
                  : AppColors.primary;
              return Card(
                color: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: AppColors.border),
                ),
                child: Container(
                  width: 280,
                  height: roleCardHeight,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        info.label,
                        style: TextStyle(
                          color: accent,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        info.description,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          const Text(
            'Administrateurs',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () => _showAddDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.person_add),
              label: const Text('Ajouter un administrateur'),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (controller.isLoadingUsers.value) {
                return const Center(child: CircularProgressIndicator());
              }
              final userList = controller.users;
              if (userList.isEmpty) {
                return const Center(
                  child: Text(
                    'Aucun administrateur trouvé.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                );
              }
              return ListView.builder(
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  final user = userList[index];
                  return Card(
                    color: AppColors.surface,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.1,
                        ),
                        child: Text(
                          user.fullName.isNotEmpty
                              ? user.fullName[0].toUpperCase()
                              : user.email[0].toUpperCase(),
                          style: const TextStyle(color: AppColors.primary),
                        ),
                      ),
                      title: Text(
                        user.fullName,
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                      subtitle: Text(
                        user.email,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildRoleChip(user.role),
                          const SizedBox(width: 8),
                          if (controller.isSelf(user))
                            Icon(
                              user.active ? Icons.check_circle : Icons.block,
                              color: user.active
                                  ? AppColors.success
                                  : AppColors.error,
                            )
                          else ...[
                            IconButton(
                              tooltip: 'Modifier',
                              icon: const Icon(Icons.edit_outlined,
                                  color: AppColors.textSecondary),
                              onPressed: () =>
                                  _showEditDialog(context, user),
                            ),
                            IconButton(
                              tooltip: user.active
                                  ? 'Désactiver'
                                  : 'Réactiver',
                              icon: Icon(
                                user.active ? Icons.check_circle : Icons.block,
                                color: user.active
                                    ? AppColors.success
                                    : AppColors.error,
                              ),
                              onPressed: () => controller.toggleActive(user),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleChip(AppRole role) {
    final label = RoleInfo.all.firstWhere((info) => info.role == role).label;
    final accent = role == AppRole.coordinateur
        ? AppColors.secondaryText
        : AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: accent,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final isPasswordVisible = false.obs;
    controller.newEmail.value = '';
    controller.newFullName.value = '';
    controller.newPassword.value = '';
    controller.newRole.value = null;
    controller.formError.value = null;

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.border),
        ),
        title: const Text(
          'Ajouter un administrateur',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => controller.newEmail.value = value,
                decoration: _inputDecoration('Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                onChanged: (value) => controller.newFullName.value = value,
                decoration: _inputDecoration('Nom complet'),
              ),
              const SizedBox(height: 16),
              Obx(
                () => TextField(
                  onChanged: (value) => controller.newPassword.value = value,
                  decoration: _inputDecoration('Mot de passe temporaire')
                      .copyWith(
                        suffixIcon: IconButton(
                          onPressed: () => isPasswordVisible.toggle(),
                          tooltip: isPasswordVisible.value
                              ? 'Masquer le mot de passe'
                              : 'Afficher le mot de passe',
                          icon: Icon(
                            isPasswordVisible.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                  obscureText: !isPasswordVisible.value,
                ),
              ),
              const SizedBox(height: 16),
              Obx(() {
                return DropdownButtonFormField<AppRole>(
                  initialValue: controller.newRole.value,
                  decoration: _inputDecoration('Rôle'),
                  items: RoleInfo.all.map((info) {
                    return DropdownMenuItem(
                      value: info.role,
                      child: Text(info.label),
                    );
                  }).toList(),
                  onChanged: (value) {
                    controller.newRole.value = value;
                  },
                );
              }),
              Obx(() {
                final error = controller.formError.value;
                if (error == null) return const SizedBox(height: 16);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    error,
                    style: const TextStyle(color: AppColors.error),
                    textAlign: TextAlign.center,
                  ),
                );
              }),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Annuler',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Obx(() {
            final creating = controller.isCreating.value;
            return ElevatedButton(
              onPressed: creating ? null : controller.addAdministrator,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: creating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Créer'),
            );
          }),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, UserAccount user) {
    controller.openEditDialog(user);
    final fullNameController = TextEditingController(text: user.fullName);

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.border),
        ),
        title: const Text(
          'Modifier l\'administrateur',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                user.email,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: fullNameController,
                onChanged: (value) => controller.editFullName.value = value,
                decoration: _inputDecoration('Nom complet'),
              ),
              const SizedBox(height: 16),
              Obx(() {
                return DropdownButtonFormField<AppRole>(
                  initialValue: controller.editRole.value,
                  decoration: _inputDecoration('Rôle'),
                  items: RoleInfo.all.map((info) {
                    return DropdownMenuItem(
                      value: info.role,
                      child: Text(info.label),
                    );
                  }).toList(),
                  onChanged: (value) {
                    controller.editRole.value = value;
                  },
                );
              }),
              Obx(() {
                final error = controller.editFormError.value;
                if (error == null) return const SizedBox(height: 16);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    error,
                    style: const TextStyle(color: AppColors.error),
                    textAlign: TextAlign.center,
                  ),
                );
              }),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Annuler',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Obx(() {
            final saving = controller.isEditing.value;
            return ElevatedButton(
              onPressed: saving
                  ? null
                  : () async {
                      await controller.submitEdit();
                      if (controller.editingUser.value == null) Get.back();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Enregistrer'),
            );
          }),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary),
      ),
    );
  }
}
