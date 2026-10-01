import 'package:havena/shared/widgets/layout/page_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:havena/app/theme/app_colors.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/features/rapports/controllers/rapports_controller.dart';

class RapportsContent extends GetView<RapportsController> {
  const RapportsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: 'Rapports mensuels',
            subtitle: 'Les bilans mensuels de votre activité.',
            icon: Icons.bar_chart_outlined,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) => controller.searchQuery.value = value,
                  decoration: _inputDecoration(
                    'Rechercher un rapport',
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () => _showFormDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.add),
                label: const Text('Nouveau rapport'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              final list = controller.visibleRapports();
              if (list.isEmpty && controller.searchQuery.value.isEmpty) {
                return const Center(
                  child: Text(
                    'Aucun rapport',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                );
              }
              if (list.isEmpty) {
                return const Center(
                  child: Text(
                    'Aucun résultat',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                );
              }
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final rapport = list[index];
                  return Card(
                    color: AppColors.surface,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.1,
                        ),
                        child: const Icon(
                          Icons.description,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        rapport.reference,
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.logementLabelFor(rapport.logementId),
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            rapport.periodMonth,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          if (rapport.generalCondition != null)
                            _buildConditionBadge(rapport.generalCondition!),
                          if (rapport.inspectionDone)
                            const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: AppColors.success,
                                  size: 16,
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
                                  : const Icon(Icons.picture_as_pdf),
                              color: AppColors.primary,
                              onPressed: generating
                                  ? null
                                  : () => controller.generateAndPreviewPdf(
                                      rapport.id,
                                    ),
                              tooltip: 'Générer / Aperçu PDF',
                            );
                          }),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            color: AppColors.textSecondary,
                            onPressed: () =>
                                _showFormDialog(context, rapport: rapport),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            color: AppColors.error,
                            onPressed: () => _confirmDelete(context, rapport),
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

  void _showFormDialog(BuildContext context, {Rapport? rapport}) {
    if (rapport != null) {
      controller.openEditForm(rapport);
    } else {
      controller.openCreateForm();
    }

    // Contrôleurs stables (créés une seule fois à l'ouverture du dialog) :
    // recréer un TextEditingController à chaque build, comme le faisaient
    // ces champs auparavant, empêche le pré-remplissage automatique
    // (`autoFillFromRecords`) de s'afficher, et casse la position du
    // curseur pendant la saisie (même bug déjà corrigé sur « Gestion des
    // accès »).
    final periodMonthController =
        TextEditingController(text: controller.periodMonth.value);
    final anomaliesController =
        TextEditingController(text: controller.anomalies.value);
    final interventionsDoneController =
        TextEditingController(text: controller.interventionsDone.value);
    final totalExpensesController =
        TextEditingController(text: controller.totalExpensesText.value);
    final recommendationsController =
        TextEditingController(text: controller.recommendations.value);
    final nextActionsController =
        TextEditingController(text: controller.nextActions.value);

    Future<void> autoFillAndRefresh() async {
      await controller.autoFillFromRecords();
      anomaliesController.text = controller.anomalies.value ?? '';
      interventionsDoneController.text = controller.interventionsDone.value ?? '';
      totalExpensesController.text = controller.totalExpensesText.value;
      recommendationsController.text = controller.recommendations.value ?? '';
    }

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.border),
        ),
        title: Text(
          rapport == null ? 'Nouveau rapport' : 'Modifier le rapport',
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() {
                  final logementsList = controller.logements;
                  return DropdownButtonFormField<int?>(
                    initialValue: controller.logementId.value,
                    decoration: _inputDecoration('Logement *'),
                    items: [
                      const DropdownMenuItem<int?>(
                        value: null,
                        child: Text('Sélectionner un logement'),
                      ),
                      ...logementsList.map((logement) {
                        return DropdownMenuItem<int?>(
                          value: logement.id,
                          child: Text(
                            '${logement.reference} — ${logement.address}',
                          ),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      controller.logementId.value = value;
                      autoFillAndRefresh();
                    },
                  );
                }),
                const SizedBox(height: 16),
                TextField(
                  controller: periodMonthController,
                  onChanged: (value) {
                    controller.periodMonth.value = value;
                    autoFillAndRefresh();
                  },
                  decoration: _inputDecoration(
                    'Mois de période * (format YYYY-MM)',
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                const SizedBox(height: 16),
                Obx(() {
                  return DropdownButtonFormField<HousingCondition?>(
                    initialValue: controller.generalCondition.value,
                    decoration: _inputDecoration('État général (optionnel)'),
                    items: [
                      const DropdownMenuItem<HousingCondition?>(
                        value: null,
                        child: Text('Aucun'),
                      ),
                      ...HousingCondition.values.map((condition) {
                        return DropdownMenuItem<HousingCondition?>(
                          value: condition,
                          child: Text(condition.name),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      controller.generalCondition.value = value;
                    },
                  );
                }),
                const SizedBox(height: 16),
                Obx(() {
                  return SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Inspection réalisée'),
                    value: controller.inspectionDone.value,
                    onChanged: (value) {
                      controller.inspectionDone.value = value;
                    },
                  );
                }),
                const SizedBox(height: 16),
                TextField(
                  controller: anomaliesController,
                  onChanged: (value) => controller.anomalies.value = value,
                  decoration: _inputDecoration('Anomalies (optionnel)'),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: interventionsDoneController,
                  onChanged: (value) =>
                      controller.interventionsDone.value = value,
                  decoration: _inputDecoration(
                    'Interventions réalisées (optionnel)',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: totalExpensesController,
                  onChanged: (value) =>
                      controller.totalExpensesText.value = value,
                  decoration: _inputDecoration('Dépenses totales (optionnel)'),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: recommendationsController,
                  onChanged: (value) =>
                      controller.recommendations.value = value,
                  decoration: _inputDecoration('Recommandations (optionnel)'),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nextActionsController,
                  onChanged: (value) => controller.nextActions.value = value,
                  decoration: _inputDecoration(
                    'Prochaines actions (optionnel)',
                  ),
                  maxLines: 3,
                ),
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
            final saving = controller.isSaving.value;
            return ElevatedButton(
              onPressed: saving ? null : controller.submitForm,
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
