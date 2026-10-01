import 'package:havena/shared/widgets/layout/page_header.dart';
import 'dart:io' show File;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:havena/app/theme/app_colors.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/inspections/inspection_checklist.dart';
import 'package:havena/features/inspections/controllers/inspections_controller.dart';
import 'package:havena/shared/widgets/copyable_reference.dart';
import 'package:havena/shared/widgets/photo_preview_dialog.dart';

class InspectionsContent extends GetView<InspectionsController> {
  const InspectionsContent({super.key, this.onBack});

  /// Permet de réutiliser cet écran détail hors de son propre onglet (ex.
  /// drawer latéral depuis Logements) : par défaut, le bouton retour
  /// désélectionne simplement l'inspection ; un appelant externe peut le
  /// remplacer pour fermer son propre conteneur à la place.
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    if (onBack != null) {
      // Intégré dans le drawer d'un autre module (ex. Logements) : va
      // directement au détail, sans liste ni second drawer imbriqué.
      return Obx(() {
        final selectedId = controller.selectedInspectionId.value;
        if (selectedId == null) {
          return _buildListView(context);
        }
        return _buildDetailView(context);
      });
    }
    // Onglet Inspections natif (retour utilisateur : même mode drawer que
    // depuis le détail Logement) : la liste reste visible, le détail
    // glisse depuis la droite dans son propre drawer.
    return Stack(
      children: [
        _buildListView(context),
        _buildOwnDrawer(context),
      ],
    );
  }

  Widget _buildOwnDrawer(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth / 2;
        return Obx(() {
          final isOpen = controller.selectedInspectionId.value != null;
          return Stack(
            children: [
              if (isOpen)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () => controller.selectInspection(null),
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
                  child: isOpen
                      ? _buildDetailView(context)
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          );
        });
      },
    );
  }

  // ---------------------------------------------------------------------------
  // VUE LISTE
  // ---------------------------------------------------------------------------
  Widget _buildListView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: 'Inspections',
            subtitle: 'Suivez les visites et l’état des logements.',
            icon: Icons.fact_check_outlined,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) => controller.searchQuery.value = value,
                  decoration: _inputDecoration(
                    'Rechercher une inspection',
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () => _showCreateInspectionDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.note_add),
                label: const Text('Nouvelle inspection'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildFiltersRow(context),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              final list = controller.visibleInspections;
              if (list.isEmpty && controller.inspections.isEmpty) {
                return const Center(
                  child: Text(
                    'Aucune inspection',
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
                  final inspection = list[index];
                  return Card(
                    color: AppColors.surface,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      onTap: () => controller.selectInspection(inspection.id),
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.1,
                        ),
                        child: const Icon(
                          Icons.assignment,
                          color: AppColors.primary,
                        ),
                      ),
                      title: CopyableReference(
                        inspection.reference,
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.logementLabelFor(inspection.logementId),
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            _formatDate(inspection.inspectionDate),
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
                          _buildValidationBadge(inspection.isValidated),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            color: AppColors.error,
                            onPressed: () =>
                                _confirmDelete(context, inspection),
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

  Widget _buildFiltersRow(BuildContext context) {
    return Obx(() {
      return Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<int?>(
              initialValue: controller.filterLogementId.value,
              isExpanded: true,
              decoration: _inputDecoration('Filtrer par logement'),
              items: [
                const DropdownMenuItem<int?>(
                  value: null,
                  child: Text('Tous les logements'),
                ),
                ...controller.logements.map((logement) {
                  return DropdownMenuItem<int?>(
                    value: logement.id,
                    child: Text(
                      logement.address,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }),
              ],
              onChanged: (value) => controller.filterLogementId.value = value,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<bool?>(
              initialValue: controller.filterValidated.value,
              isExpanded: true,
              decoration: _inputDecoration('Filtrer par statut'),
              items: const [
                DropdownMenuItem<bool?>(
                  value: null,
                  child: Text('Tous les statuts'),
                ),
                DropdownMenuItem<bool?>(value: true, child: Text('Validée')),
                DropdownMenuItem<bool?>(
                  value: false,
                  child: Text('Brouillon'),
                ),
              ],
              onChanged: (value) => controller.filterValidated.value = value,
            ),
          ),
        ],
      );
    });
  }

  // ---------------------------------------------------------------------------
  // VUE DÉTAIL
  // ---------------------------------------------------------------------------
  Widget _buildDetailView(BuildContext context) {
    return Obx(() {
      final inspection = controller.selectedInspection.value;
      if (inspection == null) {
        return const Center(child: CircularProgressIndicator());
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: AppColors.textPrimary,
                  onPressed: onBack ?? () => controller.selectInspection(null),
                ),
                const SizedBox(width: 8),
                CopyableReference(
                  inspection.reference,
                  iconSize: 18,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildLogementInfoCard(inspection),
            const SizedBox(height: 20),
            _buildGeneralConditionField(context),
            const SizedBox(height: 24),
            _buildChecklist(context),
            const SizedBox(height: 24),
            _buildPhotosSection(context),
            const SizedBox(height: 24),
            _buildRecommendationsField(context, inspection),
            const SizedBox(height: 24),
            _buildValidationSection(context, inspection),
          ],
        ),
      );
    });
  }

  /// Logement et date affichés en haut de la fiche (retour utilisateur :
  /// « ajoute les informations sur le logement et la date d'inspection en
  /// haut, avant les données d'inspection »).
  Widget _buildLogementInfoCard(Inspection inspection) {
    return Card(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.home_work_outlined,
                size: 18, color: AppColors.secondaryText),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                controller.logementLabelFor(inspection.logementId),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.event_outlined,
                size: 18, color: AppColors.secondaryText),
            const SizedBox(width: 8),
            Text(
              _formatDate(inspection.inspectionDate),
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralConditionField(BuildContext context) {
    final current = controller.selectedInspection.value?.generalCondition;
    return DropdownButtonFormField<HousingCondition?>(
      initialValue: current,
      decoration: _inputDecoration('Condition générale'),
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
        controller.updateGeneralCondition(value);
      },
    );
  }

  Widget _buildChecklist(BuildContext context) {
    return Obx(() {
      final items = controller.inspectionItems;
      if (items.isEmpty) {
        return const Text(
          'Aucun item de checklist',
          style: TextStyle(color: AppColors.textSecondary),
        );
      }

      final grouped = <InspectionCategory, List<InspectionItem>>{};
      for (final item in items) {
        grouped.putIfAbsent(item.category, () => []).add(item);
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Checklist',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...InspectionCategory.values.map((category) {
            final catItems = grouped[category] ?? [];
            if (catItems.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Card(
                elevation: 0,
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
                        InspectionChecklist.categoryLabels[category]!,
                        style: const TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Divider(height: 1, color: AppColors.border),
                      const SizedBox(height: 8),
                      ...catItems.map((item) => _buildItemRow(context, item)),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      );
    });
  }

  Widget _buildItemRow(BuildContext context, InspectionItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ChecklistItemRow(
          item: item,
          onStatusTap: (isOk) => controller.updateItemStatus(item.id, isOk),
        ),
        if (item.isOk == false)
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 8, bottom: 8),
            child: _ObservationField(
              item: item,
              onChanged: (value) =>
                  controller.updateItemObservation(item.id, value),
            ),
          ),
      ],
    );
  }

  Widget _buildPhotosSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Photos',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () => _pickAndAddPhotos(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.add_a_photo),
              label: const Text('Ajouter des photos'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Obx(() {
          if (controller.inspectionPhotos.isEmpty) {
            return const Text(
              'Aucune photo',
              style: TextStyle(color: AppColors.textSecondary),
            );
          }
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: controller.inspectionPhotos.map((photo) {
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: GestureDetector(
                      onTap: () => showPhotoPreview(
                        context,
                        controller.inspectionPhotos
                            .map((p) => p.localFilePath)
                            .toList(),
                        initialIndex:
                            controller.inspectionPhotos.indexOf(photo),
                      ),
                      child: Image.file(
                        File(photo.localFilePath),
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 120,
                            height: 120,
                            color: AppColors.background,
                            child: const Icon(
                              Icons.broken_image,
                              color: AppColors.textSecondary,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    right: 4,
                    top: 4,
                    child: GestureDetector(
                      onTap: () => controller.deletePhoto(photo.id),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  Future<void> _pickAndAddPhotos(BuildContext context) async {
    final files = await FilePicker.pickFiles(type: FileType.image);
    final paths = files.map((f) => f.path).whereType<String>().toList();
    if (paths.isNotEmpty) {
      await controller.addPhotos(paths);
    }
  }

  Widget _buildRecommendationsField(
    BuildContext context,
    Inspection inspection,
  ) {
    return _RecommendationsField(
      initialValue: inspection.recommendations ?? '',
      onChanged: (value) => controller.updateRecommendations(value),
    );
  }

  Widget _buildValidationSection(BuildContext context, Inspection inspection) {
    if (inspection.isValidated) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.success),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.success),
            const SizedBox(width: 8),
            Text(
              '✓ Inspection validée le ${_formatDate(inspection.validatedAt!)}',
              style: const TextStyle(
                color: AppColors.success,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => controller.validateInspection(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        icon: const Icon(Icons.check),
        label: const Text('Valider l\'inspection'),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DIALOG DE CRÉATION
  // ---------------------------------------------------------------------------
  void _showCreateInspectionDialog(BuildContext context) {
    final selectedLogementId = Rxn<int>();
    final inspectionDate = Rxn<DateTime>(DateTime.now());

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.border),
        ),
        title: const Text(
          'Nouvelle inspection',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() {
                  if (controller.logements.isEmpty) {
                    return const Text(
                      'Aucun logement disponible',
                      style: TextStyle(color: AppColors.textSecondary),
                    );
                  }
                  return DropdownButtonFormField<int>(
                    initialValue: selectedLogementId.value,
                    decoration: _inputDecoration('Logement *'),
                    items: controller.logements.map((logement) {
                      return DropdownMenuItem<int>(
                        value: logement.id,
                        child: Text(logement.address),
                      );
                    }).toList(),
                    onChanged: (value) {
                      selectedLogementId.value = value;
                    },
                  );
                }),
                const SizedBox(height: 16),
                _buildDateField(context, 'Date d\'inspection', inspectionDate),
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
          ElevatedButton(
            onPressed: () async {
              final logementId = selectedLogementId.value;
              final date = inspectionDate.value;
              if (logementId == null || date == null) {
                return;
              }
              Get.back();
              await controller.createInspection(
                logementId: logementId,
                inspectionDate: date,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------------------------
  Widget _buildDateField(
    BuildContext context,
    String label,
    Rxn<DateTime> dateField,
  ) {
    return InkWell(
      onTap: () async {
        final initial = dateField.value ?? DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: initial,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          dateField.value = picked;
        }
      },
      child: InputDecorator(
        decoration: _inputDecoration(label),
        child: Obx(() {
          final date = dateField.value;
          return Text(
            date != null ? _formatDate(date) : 'Sélectionner une date',
            style: TextStyle(
              color: date != null
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildValidationBadge(bool isValidated) {
    final color = isValidated ? AppColors.success : AppColors.textSecondary;
    final label = isValidated ? 'Validée' : 'Brouillon';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
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

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  void _confirmDelete(BuildContext context, Inspection inspection) {
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
          'Supprimer l\'inspection ${inspection.reference} ?',
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
              controller.deleteInspection(inspection.id);
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

/// Ligne de checklist avec surbrillance au survol (souris desktop) — sans
/// elle, il n'y a aucun repère visuel indiquant à quel libellé (ex.
/// « Robinets ») se rapportent les boutons OK/Problème/Non vérifié
/// affichés à droite, repéré par l'utilisateur comme difficile à suivre.
class _ChecklistItemRow extends StatefulWidget {
  const _ChecklistItemRow({required this.item, required this.onStatusTap});

  final InspectionItem item;
  final ValueChanged<bool?> onStatusTap;

  @override
  State<_ChecklistItemRow> createState() => _ChecklistItemRowState();
}

class _ChecklistItemRowState extends State<_ChecklistItemRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.secondarySurface : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                item.label,
                style: const TextStyle(color: AppColors.textPrimary),
              ),
            ),
            _buildStatusChip(
              label: 'OK',
              selected: item.isOk == true,
              color: AppColors.success,
              onTap: () => widget.onStatusTap(true),
            ),
            const SizedBox(width: 8),
            _buildStatusChip(
              label: 'Problème',
              selected: item.isOk == false,
              color: AppColors.error,
              onTap: () => widget.onStatusTap(false),
            ),
            const SizedBox(width: 8),
            _buildStatusChip(
              label: 'Non vérifié',
              selected: item.isOk == null,
              color: AppColors.textSecondary,
              onTap: () => widget.onStatusTap(null),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip({
    required String label,
    required bool selected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? color : AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? color : AppColors.textSecondary,
            fontSize: 12,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _ObservationField extends StatefulWidget {
  const _ObservationField({required this.item, required this.onChanged});

  final InspectionItem item;
  final ValueChanged<String> onChanged;

  @override
  State<_ObservationField> createState() => _ObservationFieldState();
}

class _ObservationFieldState extends State<_ObservationField> {
  late TextEditingController _controller;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.item.observation ?? '');
  }

  @override
  void didUpdateWidget(covariant _ObservationField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isFocused && widget.item.observation != _controller.text) {
      _controller.text = widget.item.observation ?? '';
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) => _isFocused = hasFocus,
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: 'Observation',
          hintStyle: const TextStyle(color: AppColors.textSecondary),
          filled: true,
          fillColor: AppColors.background,
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.border),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.border),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
        maxLines: 2,
        minLines: 1,
      ),
    );
  }
}

class _RecommendationsField extends StatefulWidget {
  const _RecommendationsField({
    required this.initialValue,
    required this.onChanged,
  });

  final String initialValue;
  final ValueChanged<String> onChanged;

  @override
  State<_RecommendationsField> createState() => _RecommendationsFieldState();
}

class _RecommendationsFieldState extends State<_RecommendationsField> {
  late TextEditingController _controller;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant _RecommendationsField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isFocused && widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) => _isFocused = hasFocus,
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          labelText: 'Recommandations',
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.border),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.border),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary),
          ),
        ),
        maxLines: 4,
        minLines: 2,
      ),
    );
  }
}
