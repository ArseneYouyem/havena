import 'dart:io' show File;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:havena/app/theme/app_colors.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/features/interventions/controllers/interventions_controller.dart';

class InterventionsContent extends GetView<InterventionsController> {
  const InterventionsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedId = controller.selectedInterventionId.value;
      if (selectedId == null) {
        return _buildListView(context);
      }
      return _buildDetailView(context);
    });
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
          const Text(
            'Interventions',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) => controller.searchQuery.value = value,
                  decoration: _inputDecoration(
                    'Rechercher une intervention',
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () => _showCreateInterventionDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.add),
                label: const Text('Nouvelle intervention'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              final list = controller.visibleInterventions;
              if (list.isEmpty && controller.searchQuery.value.isEmpty) {
                return const Center(
                  child: Text(
                    'Aucune intervention',
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
                  final intervention = list[index];
                  return Card(
                    color: AppColors.surface,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      onTap: () =>
                          controller.selectIntervention(intervention.id),
                      leading: CircleAvatar(
                        backgroundColor:
                            AppColors.primary.withValues(alpha: 0.1),
                        child: const Icon(Icons.build,
                            color: AppColors.primary),
                      ),
                      title: Text(
                        intervention.reference,
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            intervention.problemDescription,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            controller.logementLabelFor(intervention.logementId),
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
                          _buildUrgencyBadge(intervention.urgencyLevel),
                          const SizedBox(width: 4),
                          _buildStatusBadge(intervention.status),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            color: AppColors.error,
                            onPressed: () =>
                                _confirmDelete(context, intervention),
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

  // ---------------------------------------------------------------------------
  // VUE DÉTAIL
  // ---------------------------------------------------------------------------
  Widget _buildDetailView(BuildContext context) {
    return Obx(() {
      final intervention = controller.selectedIntervention.value;
      if (intervention == null) {
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
                  onPressed: () => controller.selectIntervention(null),
                ),
                const SizedBox(width: 8),
                Text(
                  intervention.reference,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildInformationsSection(intervention),
            const SizedBox(height: 24),
            _buildPrestataireSection(intervention),
            const SizedBox(height: 24),
            _buildDevisSection(intervention),
            const SizedBox(height: 24),
            _buildPlanificationSection(intervention),
            const SizedBox(height: 24),
            _buildMontantsSection(intervention),
            const SizedBox(height: 24),
            _buildStatutSection(intervention),
            const SizedBox(height: 24),
            _buildSatisfactionSection(intervention),
            const SizedBox(height: 24),
            _buildPhotosSection(context),
          ],
        ),
      );
    });
  }

  // 1. Informations
  Widget _buildInformationsSection(Intervention intervention) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Client : ${controller.clientLabelFor(intervention.clientId)}',
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        const SizedBox(height: 4),
        Text(
          'Logement : ${controller.logementLabelFor(intervention.logementId)}',
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        const SizedBox(height: 16),
        _InterventionTextField(
          label: 'Description du problème',
          initialValue: intervention.problemDescription,
          maxLines: 3,
          onChanged: (value) {
            final current = controller.selectedIntervention.value;
            controller.updateProblem(
              problemDescription: value,
              category: current?.category,
              urgencyLevel: current?.urgencyLevel ?? UrgencyLevel.normale,
            );
          },
        ),
        const SizedBox(height: 16),
        _InterventionTextField(
          label: 'Catégorie',
          initialValue: intervention.category ?? '',
          onChanged: (value) {
            final current = controller.selectedIntervention.value;
            controller.updateProblem(
              problemDescription: current?.problemDescription ?? '',
              category: value.isEmpty ? null : value,
              urgencyLevel: current?.urgencyLevel ?? UrgencyLevel.normale,
            );
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<UrgencyLevel>(
          initialValue: intervention.urgencyLevel,
          decoration: _inputDecoration('Urgence'),
          items: UrgencyLevel.values.map((level) {
            return DropdownMenuItem<UrgencyLevel>(
              value: level,
              child: Text(level.name),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              final current = controller.selectedIntervention.value;
              controller.updateProblem(
                problemDescription: current?.problemDescription ?? '',
                category: current?.category,
                urgencyLevel: value,
              );
            }
          },
        ),
      ],
    );
  }

  // 2. Prestataire
  Widget _buildPrestataireSection(Intervention intervention) {
    return DropdownButtonFormField<int?>(
      initialValue: intervention.prestataireId,
      decoration: _inputDecoration('Prestataire'),
      items: [
        const DropdownMenuItem<int?>(
          value: null,
          child: Text('Non assigné'),
        ),
        ...controller.prestataires.map((prestataire) {
          return DropdownMenuItem<int?>(
            value: prestataire.id,
            child: Text(prestataire.fullName),
          );
        }),
      ],
      onChanged: (value) {
        controller.updatePrestataire(prestataireId: value);
      },
    );
  }

  // 3. Devis
  Widget _buildDevisSection(Intervention intervention) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InterventionTextField(
          label: 'Montant du devis',
          initialValue: intervention.quoteAmount?.toString() ?? '',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (value) {
            final current = controller.selectedIntervention.value;
            final quoteAmount = double.tryParse(value.replaceAll(',', '.'));
            controller.updateQuoteAndValidation(
              quoteAmount: quoteAmount,
              clientValidated: current?.clientValidated ?? false,
            );
          },
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          title: const Text('Devis validé par le client'),
          value: intervention.clientValidated,
          onChanged: (value) {
            final current = controller.selectedIntervention.value;
            final quoteAmount = current?.quoteAmount;
            controller.updateQuoteAndValidation(
              quoteAmount: quoteAmount,
              clientValidated: value,
            );
          },
        ),
      ],
    );
  }

  // 4. Planification
  Widget _buildPlanificationSection(Intervention intervention) {
    return _InterventionDateField(
      initialValue: intervention.interventionDate,
      onChanged: (date) {
        controller.updatePlanning(interventionDate: date);
      },
    );
  }

  // 5. Montants
  Widget _buildMontantsSection(Intervention intervention) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _InterventionTextField(
                label: 'Montant client (FCFA)',
                initialValue: intervention.clientAmount?.toString() ?? '',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  final current = controller.selectedIntervention.value;
                  final clientAmount = double.tryParse(value.replaceAll(',', '.'));
                  controller.updateAmounts(
                    clientAmount: clientAmount,
                    prestataireAmount: current?.prestataireAmount,
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _InterventionTextField(
                label: 'Montant prestataire (FCFA)',
                initialValue: intervention.prestataireAmount?.toString() ?? '',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  final current = controller.selectedIntervention.value;
                  final prestataireAmount =
                      double.tryParse(value.replaceAll(',', '.'));
                  controller.updateAmounts(
                    clientAmount: current?.clientAmount,
                    prestataireAmount: prestataireAmount,
                  );
                },
              ),
            ),
          ],
        ),
        if (intervention.havenaMargin != null) ...[
          const SizedBox(height: 12),
          Text(
            'Marge HAVENA : ${intervention.havenaMargin!.toStringAsFixed(0)} FCFA',
            style: TextStyle(
              color: intervention.havenaMargin! >= 0
                  ? AppColors.success
                  : AppColors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }

  // 6. Statut
  Widget _buildStatutSection(Intervention intervention) {
    return DropdownButtonFormField<InterventionStatus>(
      initialValue: intervention.status,
      decoration: _inputDecoration('Statut'),
      items: InterventionStatus.values.map((status) {
        return DropdownMenuItem<InterventionStatus>(
          value: status,
          child: Text(status.name),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          controller.updateStatus(status: value);
        }
      },
    );
  }

  // 7. Satisfaction client
  Widget _buildSatisfactionSection(Intervention intervention) {
    final currentSatisfaction = intervention.clientSatisfaction;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Satisfaction client',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: List.generate(5, (index) {
            final starValue = index + 1;
            final selected = currentSatisfaction != null &&
                currentSatisfaction >= starValue;
            return IconButton(
              icon: Icon(
                selected ? Icons.star : Icons.star_border,
                color: selected ? AppColors.warning : AppColors.textSecondary,
                size: 32,
              ),
              onPressed: () {
                final newValue =
                    (currentSatisfaction == starValue) ? null : starValue;
                controller.updateSatisfaction(clientSatisfaction: newValue);
              },
            );
          }),
        ),
      ],
    );
  }

  // 8. Photos avant/après
  Widget _buildPhotosSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Photos',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildPhotoSubsection(
          context,
          title: 'Avant intervention',
          photos: controller.beforePhotos,
          isBefore: true,
        ),
        const SizedBox(height: 24),
        _buildPhotoSubsection(
          context,
          title: 'Après intervention',
          photos: controller.afterPhotos,
          isBefore: false,
        ),
      ],
    );
  }

  Widget _buildPhotoSubsection(
    BuildContext context, {
    required String title,
    required RxList<Photo> photos,
    required bool isBefore,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () => _pickAndAddPhotos(context, isBefore),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.add_a_photo),
              label: const Text('Ajouter'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Obx(() {
          if (photos.isEmpty) {
            return const Text(
              'Aucune photo',
              style: TextStyle(color: AppColors.textSecondary),
            );
          }
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: photos.map((photo) {
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
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
                          child: const Icon(Icons.broken_image,
                              color: AppColors.textSecondary),
                        );
                      },
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

  Future<void> _pickAndAddPhotos(BuildContext context, bool isBefore) async {
    final files = await FilePicker.pickFiles(
      type: FileType.image,
    );
    final paths = files.map((f) => f.path).whereType<String>().toList();
    if (paths.isNotEmpty) {
      await controller.addPhotos(paths, isBefore: isBefore);
    }
  }

  // ---------------------------------------------------------------------------
  // DIALOG DE CRÉATION
  // ---------------------------------------------------------------------------
  void _showCreateInterventionDialog(BuildContext context) {
    Get.dialog(
      const _CreateInterventionDialog(),
    );
  }

  // ---------------------------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------------------------
  Widget _buildUrgencyBadge(UrgencyLevel level) {
    Color color;
    switch (level) {
      case UrgencyLevel.basse:
        color = AppColors.textSecondary;
        break;
      case UrgencyLevel.normale:
        color = AppColors.primary;
        break;
      case UrgencyLevel.haute:
        color = AppColors.warning;
        break;
      case UrgencyLevel.critique:
        color = AppColors.error;
        break;
    }
    return _buildBadge(level.name, color);
  }

  Widget _buildStatusBadge(InterventionStatus status) {
    Color color;
    switch (status) {
      case InterventionStatus.nouveau:
        color = AppColors.textSecondary;
        break;
      case InterventionStatus.enAttenteDevis:
        color = AppColors.warning;
        break;
      case InterventionStatus.valide:
      case InterventionStatus.planifie:
        color = AppColors.primary;
        break;
      case InterventionStatus.enCours:
        color = AppColors.warning;
        break;
      case InterventionStatus.termine:
      case InterventionStatus.paye:
        color = AppColors.success;
        break;
      case InterventionStatus.archive:
        color = AppColors.textSecondary;
        break;
    }
    return _buildBadge(status.name, color);
  }

  Widget _buildBadge(String label, Color color) {
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

  void _confirmDelete(BuildContext context, Intervention intervention) {
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
          'Supprimer l\'intervention ${intervention.reference} ?',
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
              controller.deleteIntervention(intervention.id);
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

// -----------------------------------------------------------------------------
// WIDGETS PRIVÉS
// -----------------------------------------------------------------------------

class _InterventionTextField extends StatefulWidget {
  const _InterventionTextField({
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.maxLines = 1,
    this.keyboardType,
  });

  final String label;
  final String initialValue;
  final ValueChanged<String> onChanged;
  final int maxLines;
  final TextInputType? keyboardType;

  @override
  State<_InterventionTextField> createState() => _InterventionTextFieldState();
}

class _InterventionTextFieldState extends State<_InterventionTextField> {
  late TextEditingController _controller;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant _InterventionTextField oldWidget) {
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
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
        minLines: widget.maxLines > 1 ? 1 : null,
        decoration: InputDecoration(
          labelText: widget.label,
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
      ),
    );
  }
}

class _InterventionDateField extends StatefulWidget {
  const _InterventionDateField({
    required this.initialValue,
    required this.onChanged,
  });

  final DateTime? initialValue;
  final ValueChanged<DateTime?> onChanged;

  @override
  State<_InterventionDateField> createState() => _InterventionDateFieldState();
}

class _InterventionDateFieldState extends State<_InterventionDateField> {
  DateTime? _date;

  @override
  void initState() {
    super.initState();
    _date = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant _InterventionDateField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != _date) {
      setState(() {
        _date = widget.initialValue;
      });
    }
  }

  Future<void> _pickDate() async {
    final initial = _date ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _date = picked;
      });
      widget.onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _pickDate,
      child: InputDecorator(
        decoration: _inputDecoration('Date d\'intervention'),
        child: Text(
          _date != null ? _formatDate(_date!) : 'Sélectionner une date',
          style: TextStyle(
            color: _date != null
                ? AppColors.textPrimary
                : AppColors.textSecondary,
          ),
        ),
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

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }
}

class _CreateInterventionDialog extends StatefulWidget {
  const _CreateInterventionDialog();

  @override
  State<_CreateInterventionDialog> createState() =>
      _CreateInterventionDialogState();
}

class _CreateInterventionDialogState extends State<_CreateInterventionDialog> {
  final _problemController = TextEditingController();
  final _categoryController = TextEditingController();
  final _selectedLogementId = Rxn<int>();
  final _selectedUrgency = Rxn<UrgencyLevel>(UrgencyLevel.normale);
  final _selectedPrestataireId = Rxn<int>();

  @override
  void dispose() {
    _problemController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final interventionsController = Get.find<InterventionsController>();
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.border),
      ),
      title: const Text(
        'Nouvelle intervention',
        style: TextStyle(color: AppColors.textPrimary),
      ),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() {
                if (interventionsController.logements.isEmpty) {
                  return const Text(
                    'Aucun logement disponible',
                    style: TextStyle(color: AppColors.textSecondary),
                  );
                }
                return DropdownButtonFormField<int>(
                  initialValue: _selectedLogementId.value,
                  decoration: _inputDecoration('Logement *'),
                  items: interventionsController.logements.map((logement) {
                    return DropdownMenuItem<int>(
                      value: logement.id,
                      child: Text(logement.address),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedLogementId.value = value;
                    });
                  },
                );
              }),
              const SizedBox(height: 16),
              TextField(
                controller: _problemController,
                decoration: _inputDecoration('Description du problème *'),
                maxLines: 3,
                minLines: 1,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _categoryController,
                decoration: _inputDecoration('Catégorie (optionnel)'),
              ),
              const SizedBox(height: 16),
              Obx(() {
                return DropdownButtonFormField<UrgencyLevel>(
                  initialValue: _selectedUrgency.value,
                  decoration: _inputDecoration('Urgence *'),
                  items: UrgencyLevel.values.map((level) {
                    return DropdownMenuItem<UrgencyLevel>(
                      value: level,
                      child: Text(level.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedUrgency.value = value;
                    });
                  },
                );
              }),
              const SizedBox(height: 16),
              Obx(() {
                return DropdownButtonFormField<int?>(
                  initialValue: _selectedPrestataireId.value,
                  decoration: _inputDecoration('Prestataire'),
                  items: [
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text('Non assigné'),
                    ),
                    ...interventionsController.prestataires.map((prestataire) {
                      return DropdownMenuItem<int?>(
                        value: prestataire.id,
                        child: Text(prestataire.fullName),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedPrestataireId.value = value;
                    });
                  },
                );
              }),
              const SizedBox(height: 16),
              Obx(() {
                final error = interventionsController.formError.value;
                if (error != null) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      error,
                      style: const TextStyle(color: AppColors.error),
                    ),
                  );
                }
                return const SizedBox.shrink();
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
        ElevatedButton(
          onPressed: () async {
            final logementId = _selectedLogementId.value;
            final problem = _problemController.text.trim();
            final category = _categoryController.text.trim();
            final urgency = _selectedUrgency.value;
            final prestataireId = _selectedPrestataireId.value;

            if (logementId == null) {
              interventionsController.formError.value =
                  'Veuillez sélectionner un logement.';
              return;
            }
            if (problem.isEmpty) {
              interventionsController.formError.value =
                  'La description du problème est obligatoire.';
              return;
            }
            if (urgency == null) {
              interventionsController.formError.value =
                  'Veuillez sélectionner une urgence.';
              return;
            }

            final result = await interventionsController.createIntervention(
              logementId: logementId,
              problemDescription: problem,
              category: category.isEmpty ? null : category,
              urgencyLevel: urgency,
              prestataireId: prestataireId,
            );
            if (result != null) {
              Get.back();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          child: const Text('Créer'),
        ),
      ],
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
