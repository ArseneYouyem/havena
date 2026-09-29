import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:havena/app/controllers/navigation_controller.dart';
import 'package:havena/app/routes/app_routes.dart';
import 'package:havena/app/theme/app_colors.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({super.key});

  static const double width = 240;

  static const List<_MenuItem> _items = [
    _MenuItem(
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
      route: AppRoutes.dashboard,
    ),
    _MenuItem(
      label: 'Clients',
      icon: Icons.people_outline,
      route: AppRoutes.clients,
    ),
    _MenuItem(
      label: 'Logements',
      icon: Icons.home_work_outlined,
      route: AppRoutes.logements,
    ),
    _MenuItem(
      label: 'Abonnements',
      icon: Icons.card_membership_outlined,
      route: AppRoutes.abonnements,
    ),
    _MenuItem(
      label: 'Inspections',
      icon: Icons.fact_check_outlined,
      route: AppRoutes.inspections,
    ),
    _MenuItem(
      label: 'Interventions',
      icon: Icons.build_outlined,
      route: AppRoutes.interventions,
    ),
    _MenuItem(
      label: 'Prestataires',
      icon: Icons.engineering_outlined,
      route: AppRoutes.prestataires,
    ),
    _MenuItem(
      label: 'Finances',
      icon: Icons.account_balance_wallet_outlined,
      route: AppRoutes.finances,
    ),
    _MenuItem(
      label: 'Rapports',
      icon: Icons.bar_chart_outlined,
      route: AppRoutes.rapports,
    ),
    _MenuItem(
      label: 'Calendrier',
      icon: Icons.calendar_month_outlined,
      route: AppRoutes.calendrier,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      color: AppColors.surface,
      child: Column(
        children: [
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
            child: const Text(
              'HAVENA',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          Expanded(
            child: Obx(() {
              final currentRoute =
                  Get.find<NavigationController>().currentRoute.value;
              return ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: _items
                    .map(
                      (item) => _SidebarMenuItem(
                        item: item,
                        isActive: currentRoute == item.route,
                      ),
                    )
                    .toList(),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem({
    required this.label,
    required this.icon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final String route;
}

class _SidebarMenuItem extends StatelessWidget {
  const _SidebarMenuItem({
    required this.item,
    required this.isActive,
  });

  final _MenuItem item;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.textSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: isActive
            ? AppColors.primary.withValues(alpha: 0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () =>
              Get.find<NavigationController>().changeTo(item.route),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 20,
                  color: color,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
