import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:havena/app/theme/app_colors.dart';
import 'package:havena/features/dashboard/controllers/dashboard_controller.dart';

class DashboardContent extends GetView<DashboardController> {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tableau de bord',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Obx(
            () => Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _IndicatorCard(
                  label: 'Clients',
                  value: controller.clientsCount.value.toString(),
                  icon: Icons.people_outline,
                ),
                _IndicatorCard(
                  label: 'Logements',
                  value: controller.logementsCount.value.toString(),
                  icon: Icons.home_work_outlined,
                ),
                _IndicatorCard(
                  label: 'Interventions en cours',
                  value: controller.interventionsEnCours.value.toString(),
                  icon: Icons.build_outlined,
                ),
                _IndicatorCard(
                  label: 'Abonnements actifs',
                  value: controller.abonnementsActifs.value.toString(),
                  icon: Icons.card_membership_outlined,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IndicatorCard extends StatelessWidget {
  const _IndicatorCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Card(
        elevation: 0,
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
