import 'package:flutter/material.dart';
import 'package:havena/app/theme/app_colors.dart';
import 'package:havena/shared/widgets/layout/sidebar_menu.dart';

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
          const Spacer(),
          const Text(
            '⚪ Non synchronisé',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
