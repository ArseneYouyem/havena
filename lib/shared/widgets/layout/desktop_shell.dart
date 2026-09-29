import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:havena/app/routes/app_routes.dart';
import 'package:havena/app/theme/app_colors.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/auth/repositories/auth_repository.dart';
import 'package:havena/shared/widgets/layout/reference_search_field.dart';
import 'package:havena/shared/widgets/layout/sidebar_menu.dart';
import 'package:havena/shared/widgets/layout/sync_status_indicator.dart';

class DesktopShell extends StatelessWidget {
  const DesktopShell({
    super.key,
    required this.child,
    this.title = 'HAVENA',
  });

  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          const SidebarMenu(),
          Expanded(
            child: Column(
              children: [
                _TopBar(title: title),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/splash.png',
            height: 36,
            width: 36,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 32),
          const ReferenceSearchField(),
          const Spacer(),
          const SyncStatusIndicator(),
          const SizedBox(width: 20),
          Obx(() {
            final session = Get.find<SessionController>().session.value;
            if (session == null) return const SizedBox.shrink();
            return Text(
              session.fullName,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            );
          }),
          const SizedBox(width: 12),
          IconButton(
            tooltip: 'Se déconnecter',
            icon: const Icon(
              Icons.logout,
              size: 20,
              color: AppColors.textSecondary,
            ),
            onPressed: () async {
              await Get.find<AuthRepository>().logout();
              Get.find<SessionController>().clear();
              Get.offAllNamed(AppRoutes.login);
            },
          ),
        ],
      ),
    );
  }
}
