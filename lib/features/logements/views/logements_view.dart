import 'package:havena/shared/widgets/layout/page_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:havena/app/theme/app_colors.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/features/inspections/views/inspections_view.dart';
import 'package:havena/features/interventions/views/interventions_view.dart';
import 'package:havena/features/logements/controllers/logements_controller.dart';

class LogementsContent extends GetView<LogementsController> {
  const LogementsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(() {
          if (controller.selectedLogementId.value != null) {
            return _buildDetailView(context);
          }
          return _buildListView(context);
        }),
        const _InspectionInterventionDrawer(),
      ],
    );
  }

  Widget _buildListView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: 'Logements',
            subtitle: 'Votre parc immobilier, au même endroit.',
            icon: Icons.home_work_outlined,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) => controller.searchQuery.value = value,
                  decoration: _inputDecoration(
                    'Rechercher un logement',
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
                icon: const Icon(Icons.add_home),
                label: const Text('Ajouter un logement'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              final list = controller.visibleLogements();
              if (list.isEmpty && controller.searchQuery.value.isEmpty) {
                return const Center(
                  child: Text(
                    'Aucun logement',
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
                  final logement = list[index];
                  return Card(
                    color: AppColors.surface,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      onTap: () => controller.selectLogement(logement.id),
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.1,
                        ),
                        child: const Icon(
                          Icons.home,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        logement.address,
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            logement.reference,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          if (logement.neighborhood != null)
                            Text(
                              logement.neighborhood!,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          Text(
                            controller.clientLabelFor(logement.clientId),
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
                          if (logement.generalCondition != null)
                            _buildConditionBadge(logement.generalCondition!),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            color: AppColors.textSecondary,
                            onPressed: () =>
                                _showFormDialog(context, logement: logement),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            color: AppColors.error,
                            onPressed: () => _confirmDelete(context, logement),
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

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  /// Vue détail d'un logement (retour utilisateur) : une carte
  /// d'informations, puis une deuxième carte divisée en deux colonnes —
  /// inspections à gauche, interventions à droite, chacune cliquable pour
  /// ouvrir l'écran détail complet du module correspondant (bascule la
  /// sidebar via `NavigationController`, voir `LogementsController.
  /// openInspectionDetail`/`openInterventionDetail`).
  Widget _buildDetailView(BuildContext context) {
    return Obx(() {
      final id = controller.selectedLogementId.value;
      Logement? logement;
      for (final l in controller.logements) {
        if (l.id == id) {
          logement = l;
          break;
        }
      }
      if (logement == null) {
        return const Center(
          child: Text(
            'Logement introuvable',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        );
      }
      final currentLogement = logement;

      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: AppColors.textPrimary,
                  onPressed: () => controller.selectLogement(null),
                ),
                const SizedBox(width: 8),
                Text(
                  currentLogement.reference,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              color: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: AppColors.border),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentLogement.address,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (currentLogement.neighborhood != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        currentLogement.neighborhood!,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      'Client : ${controller.clientLabelFor(currentLogement.clientId)}',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    if (currentLogement.generalCondition != null) ...[
                      const SizedBox(height: 8),
                      _buildConditionBadge(currentLogement.generalCondition!),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildRelatedListCard(
                      title: 'Inspections',
                      icon: Icons.fact_check_outlined,
                      items: controller.inspectionsForSelected().map((i) {
                        return _RelatedListItem(
                          title: i.reference,
                          subtitle: _formatDate(i.inspectionDate),
                          trailing: i.isValidated ? 'Validée' : 'En cours',
                          trailingColor: i.isValidated
                              ? AppColors.success
                              : AppColors.textSecondary,
                          onTap: () =>
                              controller.openInspectionDetail(i.id),
                        );
                      }).toList(),
                      emptyLabel: 'Aucune inspection',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildRelatedListCard(
                      title: 'Interventions',
                      icon: Icons.build_outlined,
                      items: controller.interventionsForSelected().map((i) {
                        return _RelatedListItem(
                          title: i.reference,
                          subtitle: i.interventionDate != null
                              ? '${i.problemDescription} — ${_formatDate(i.interventionDate!)}'
                              : i.problemDescription,
                          trailing: i.status.name,
                          trailingColor: AppColors.textSecondary,
                          onTap: () =>
                              controller.openInterventionDetail(i.id),
                        );
                      }).toList(),
                      emptyLabel: 'Aucune intervention',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildRelatedListCard({
    required String title,
    required IconData icon,
    required List<_RelatedListItem> items,
    required String emptyLabel,
  }) {
    return Card(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: AppColors.secondaryText),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: 8),
            if (items.isEmpty)
              Text(
                emptyLabel,
                style: const TextStyle(color: AppColors.textSecondary),
              )
            else
              Expanded(
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, _) =>
                      const Divider(height: 1, color: AppColors.border),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      onTap: item.onTap,
                      title: Text(
                        item.title,
                        style:
                            const TextStyle(color: AppColors.textPrimary),
                      ),
                      subtitle: Text(
                        item.subtitle,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      trailing: Text(
                        item.trailing,
                        style: TextStyle(
                          color: item.trailingColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
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

  void _showFormDialog(BuildContext context, {Logement? logement}) {
    if (logement != null) {
      controller.openEditForm(logement);
    } else {
      controller.openCreateForm();
    }

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.border),
        ),
        title: Text(
          logement == null ? 'Ajouter un logement' : 'Modifier le logement',
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() {
                  final clients = controller.clients;
                  return DropdownButtonFormField<int?>(
                    initialValue: controller.clientId.value,
                    decoration: _inputDecoration('Client (optionnel)'),
                    items: [
                      const DropdownMenuItem<int?>(
                        value: null,
                        child: Text('Non assigné'),
                      ),
                      ...clients.map((client) {
                        return DropdownMenuItem<int?>(
                          value: client.id,
                          child: Text(
                            '${client.fullName} (${client.reference})',
                          ),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      controller.clientId.value = value;
                    },
                  );
                }),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(
                    text: controller.address.value,
                  ),
                  onChanged: (value) => controller.address.value = value,
                  decoration: _inputDecoration('Adresse *'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(
                    text: controller.neighborhood.value,
                  ),
                  onChanged: (value) => controller.neighborhood.value = value,
                  decoration: _inputDecoration('Quartier (optionnel)'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(
                    text: controller.housingType.value,
                  ),
                  onChanged: (value) => controller.housingType.value = value,
                  decoration: _inputDecoration('Type de logement (optionnel)'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(
                    text: controller.bedroomsCountText.value,
                  ),
                  onChanged: (value) =>
                      controller.bedroomsCountText.value = value,
                  decoration: _inputDecoration(
                    'Nombre de chambres (optionnel)',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(
                    text: controller.occupancy.value,
                  ),
                  onChanged: (value) => controller.occupancy.value = value,
                  decoration: _inputDecoration('Occupation (optionnel)'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(
                    text: controller.localContact.value,
                  ),
                  onChanged: (value) => controller.localContact.value = value,
                  decoration: _inputDecoration('Contact local (optionnel)'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(
                    text: controller.guardian.value,
                  ),
                  onChanged: (value) => controller.guardian.value = value,
                  decoration: _inputDecoration('Gardien (optionnel)'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(
                    text: controller.keysCountText.value,
                  ),
                  onChanged: (value) => controller.keysCountText.value = value,
                  decoration: _inputDecoration('Nombre de clés (optionnel)'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(
                    text: controller.mainEquipment.value,
                  ),
                  onChanged: (value) => controller.mainEquipment.value = value,
                  decoration: _inputDecoration(
                    'Équipements principaux (optionnel)',
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() {
                  return DropdownButtonFormField<HousingCondition?>(
                    initialValue: controller.generalCondition.value,
                    decoration: _inputDecoration('État général (optionnel)'),
                    items: [
                      const DropdownMenuItem<HousingCondition?>(
                        value: null,
                        child: Text('Non renseigné'),
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
                TextField(
                  controller: TextEditingController(
                    text: controller.notes.value,
                  ),
                  onChanged: (value) => controller.notes.value = value,
                  decoration: _inputDecoration('Notes (optionnel)'),
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

  void _confirmDelete(BuildContext context, Logement logement) {
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
          'Supprimer le logement ${logement.reference} ?',
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
              controller.deleteLogement(logement.id);
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

class _RelatedListItem {
  const _RelatedListItem({
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.trailingColor,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String trailing;
  final Color trailingColor;
  final VoidCallback onTap;
}

/// Drawer qui glisse depuis la droite et s'arrête à mi-largeur de l'onglet
/// Logements, pour afficher l'écran détail complet d'une inspection ou
/// d'une intervention sans changer d'onglet (retour utilisateur : la
/// bascule de sidebar précédente n'était pas souhaitée). `_lastContent` est
/// conservé pendant l'animation de fermeture pour éviter un flash de la
/// vue liste du module réutilisé pendant que le panneau glisse hors écran.
class _InspectionInterventionDrawer extends StatefulWidget {
  const _InspectionInterventionDrawer();

  @override
  State<_InspectionInterventionDrawer> createState() =>
      _InspectionInterventionDrawerState();
}

class _InspectionInterventionDrawerState
    extends State<_InspectionInterventionDrawer> {
  Widget? _lastContent;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LogementsController>();
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth / 2;
        return Obx(() {
          final inspectionId = controller.drawerInspectionId.value;
          final interventionId = controller.drawerInterventionId.value;
          final isOpen = inspectionId != null || interventionId != null;
          if (isOpen) {
            _lastContent = inspectionId != null
                ? InspectionsContent(onBack: controller.closeDrawer)
                : InterventionsContent(onBack: controller.closeDrawer);
          }
          return Stack(
            children: [
              if (isOpen)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: controller.closeDrawer,
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.25),
                    ),
                  ),
                ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                top: 0,
                bottom: 0,
                right: isOpen ? 0 : -width,
                width: width,
                child: Material(
                  elevation: 8,
                  color: AppColors.background,
                  child: _lastContent ?? const SizedBox.shrink(),
                ),
              ),
            ],
          );
        });
      },
    );
  }
}
