import 'package:havena/shared/widgets/layout/page_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:havena/app/theme/app_colors.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/rapports/controllers/rapports_controller.dart';
import 'package:havena/shared/widgets/copyable_reference.dart';

class RapportsContent extends GetView<RapportsController> {
  const RapportsContent({super.key});

  static const _monthLabels = [
    'Janvier',
    'Février',
    'Mars',
    'Avril',
    'Mai',
    'Juin',
    'Juillet',
    'Août',
    'Septembre',
    'Octobre',
    'Novembre',
    'Décembre',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: 'Rapports mensuels',
            subtitle:
                'Générés automatiquement pour chaque logement — sélectionnez simplement le mois.',
            icon: Icons.bar_chart_outlined,
          ),
          const SizedBox(height: 24),
          _buildMonthSelector(context),
          const SizedBox(height: 16),
          TextField(
            onChanged: (value) => controller.searchQuery.value = value,
            decoration: _inputDecoration(
              'Rechercher un rapport',
              prefixIcon: const Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              final list = controller.visibleRapports();
              if (list.isEmpty) {
                return Center(
                  child: Text(
                    controller.searchQuery.value.isEmpty
                        ? 'Aucun rapport pour ce mois'
                        : 'Aucun résultat',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                );
              }
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final rapport = list[index];
                  final clientName =
                      controller.clientNameFor(rapport.logementId);
                  final clientReference =
                      controller.clientReferenceFor(rapport.logementId);
                  final logementReference =
                      controller.logementReferenceFor(rapport.logementId);
                  return Card(
                    elevation: 0,
                    color: AppColors.surface,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: AppColors.border),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.08,
                        ),
                        child: const Icon(
                          Icons.description_outlined,
                          color: AppColors.primary,
                          size: 18,
                        ),
                      ),
                      title: Text(
                        controller.logementLabelFor(rapport.logementId),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              CopyableReference(
                                rapport.reference,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                              if (logementReference.isNotEmpty) ...[
                                const Text(' — ',
                                    style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12)),
                                CopyableReference(
                                  logementReference,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                              if (clientReference.isNotEmpty) ...[
                                const Text(' — ',
                                    style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12)),
                                Text(
                                  '$clientName ',
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                                CopyableReference(
                                  clientReference,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          if (rapport.generalCondition != null)
                            _buildConditionBadge(rapport.generalCondition!),
                          if (rapport.inspectionDone)
                            const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  color: AppColors.success,
                                  size: 14,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Inspection réalisée',
                                  style: TextStyle(
                                    color: AppColors.success,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          if (rapport.totalExpenses != null)
                            Text(
                              'Dépenses du client : ${rapport.totalExpenses!.toStringAsFixed(0)} FCFA',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          if (rapport.generatedAt != null)
                            Text(
                              'PDF généré le ${_formatDate(rapport.generatedAt!)}',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Obx(() {
                            final generating = controller.generatingIds
                                .contains(rapport.id);
                            return IconButton(
                              icon: generating
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.picture_as_pdf_outlined),
                              color: AppColors.primary,
                              onPressed: generating
                                  ? null
                                  : () => controller.generateAndPreviewPdf(
                                      rapport.id,
                                    ),
                              tooltip: 'Aperçu / impression PDF',
                            );
                          }),
                          if (Get.find<SessionController>().isFondatrice)
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              color: AppColors.error,
                              onPressed: () =>
                                  _confirmDelete(context, rapport),
                            ),
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

  Widget _buildMonthSelector(BuildContext context) {
    return Obx(() {
      final parts = controller.selectedMonth.value.split('-');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final canGenerate = controller.canGenerateForSelectedMonth;
      return Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            color: AppColors.textPrimary,
            onPressed: controller.goToPreviousMonth,
          ),
          Text(
            '${_monthLabels[month - 1]} $year',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            color: AppColors.textPrimary,
            onPressed: controller.goToNextMonth,
          ),
          const Spacer(),
          // Un mois ne peut être rapporté qu'une fois terminé (retour
          // utilisateur) : le bouton reste masqué pour le mois courant.
          if (canGenerate)
            Obx(() {
              final saving = controller.isSaving.value;
              return ElevatedButton.icon(
                onPressed:
                    saving ? null : controller.generateReportsForSelectedMonth,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                icon: saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.auto_awesome),
                label: const Text('Générer les rapports du mois'),
              );
            }),
        ],
      );
    });
  }

  Widget _buildConditionBadge(HousingCondition condition) {
    Color color;
    switch (condition) {
      case HousingCondition.bon:
        color = AppColors.success;
        break;
      case HousingCondition.moyen:
        color = AppColors.warning;
        break;
      case HousingCondition.mauvais:
        color = AppColors.error;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        condition.name,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, {Widget? prefixIcon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: prefixIcon,
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

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  void _confirmDelete(BuildContext context, Rapport rapport) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.border),
        ),
        title: const Text(
          'Confirmer la suppression',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          'Supprimer le rapport ${rapport.reference} ?',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Annuler',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteRapport(rapport.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
