import 'package:havena/shared/widgets/layout/page_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:havena/app/theme/app_colors.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/features/prestataires/controllers/prestataires_controller.dart';
import 'package:havena/shared/widgets/copyable_reference.dart';

class PrestatairesContent extends GetView<PrestatairesController> {
  const PrestatairesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildListView(context),
        const _PrestataireDrawer(),
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
            title: 'Prestataires',
            subtitle: 'Retrouvez les professionnels qui vous accompagnent.',
            icon: Icons.engineering_outlined,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) => controller.searchQuery.value = value,
                  decoration: _inputDecoration(
                    'Rechercher un prestataire',
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
                icon: const Icon(Icons.person_add),
                label: const Text('Ajouter un prestataire'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              final list = controller.visiblePrestataires();
              if (list.isEmpty && controller.searchQuery.value.isEmpty) {
                return const Center(
                  child: Text(
                    'Aucun prestataire',
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
                  final prestataire = list[index];
                  return Card(
                    color: AppColors.surface,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      onTap: () =>
                          controller.selectPrestataire(prestataire.id),
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.1,
                        ),
                        child: Text(
                          prestataire.fullName.isNotEmpty
                              ? prestataire.fullName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(color: AppColors.primary),
                        ),
                      ),
                      title: Text(
                        prestataire.fullName,
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CopyableReference(
                            prestataire.reference,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            prestataire.specialty,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          if (prestataire.zone != null)
                            Text(
                              prestataire.zone!,
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
                          Builder(builder: (context) {
                            // Note finale = combinaison des 4 notes
                            // (qualité, ponctualité, communication,
                            // satisfaction client calculée) — retour
                            // utilisateur.
                            final rating =
                                controller.finalRatingFor(prestataire);
                            if (rating == null) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: AppColors.warning,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    rating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      color: AppColors.warning,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          _buildStatusBadge(prestataire.status),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            color: AppColors.textSecondary,
                            onPressed: () => _showFormDialog(
                              context,
                              prestataire: prestataire,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            color: AppColors.error,
                            onPressed: () =>
                                _confirmDelete(context, prestataire),
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

  Widget _buildStatusBadge(PrestataireStatus status) {
    Color color;
    switch (status) {
      case PrestataireStatus.actif:
        color = AppColors.success;
        break;
      case PrestataireStatus.sousSurveillance:
        color = AppColors.warning;
        break;
      case PrestataireStatus.suspendu:
        color = AppColors.error;
        break;
      case PrestataireStatus.inactif:
        color = AppColors.textSecondary;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.name,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showFormDialog(BuildContext context, {Prestataire? prestataire}) {
    if (prestataire != null) {
      controller.openEditForm(prestataire);
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
          prestataire == null
              ? 'Ajouter un prestataire'
              : 'Modifier le prestataire',
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: TextEditingController(
                    text: controller.fullName.value,
                  ),
                  onChanged: (value) => controller.fullName.value = value,
                  decoration: _inputDecoration('Nom complet *'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(
                    text: controller.phone.value,
                  ),
                  onChanged: (value) => controller.phone.value = value,
                  decoration: _inputDecoration('Téléphone *'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(
                    text: controller.specialty.value,
                  ),
                  onChanged: (value) => controller.specialty.value = value,
                  decoration: _inputDecoration('Spécialité *'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(
                    text: controller.zone.value,
                  ),
                  onChanged: (value) => controller.zone.value = value,
                  decoration: _inputDecoration('Zone (optionnel)'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(
                    text: controller.experienceYearsText.value,
                  ),
                  onChanged: (value) =>
                      controller.experienceYearsText.value = value,
                  decoration: _inputDecoration(
                    'Années d\'expérience (optionnel)',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Obx(() {
                        return SwitchListTile(
                          title: const Text('Identité vérifiée'),
                          value: controller.identityVerified.value,
                          onChanged: (value) =>
                              controller.identityVerified.value = value,
                          contentPadding: EdgeInsets.zero,
                          activeThumbColor: AppColors.primary,
                        );
                      }),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Obx(() {
                        return SwitchListTile(
                          title: const Text('Références vérifiées'),
                          value: controller.referencesVerified.value,
                          onChanged: (value) =>
                              controller.referencesVerified.value = value,
                          contentPadding: EdgeInsets.zero,
                          activeThumbColor: AppColors.primary,
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(
                    text: controller.indicativeRateText.value,
                  ),
                  onChanged: (value) =>
                      controller.indicativeRateText.value = value,
                  decoration: _inputDecoration('Tarif indicatif (optionnel)'),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(
                          text: controller.qualityRatingText.value,
                        ),
                        onChanged: (value) =>
                            controller.qualityRatingText.value = value,
                        decoration: _inputDecoration(
                          'Qualité (0-5, optionnel)',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(
                          text: controller.punctualityRatingText.value,
                        ),
                        onChanged: (value) =>
                            controller.punctualityRatingText.value = value,
                        decoration: _inputDecoration(
                          'Ponctualité (0-5, optionnel)',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(
                    text: controller.communicationRatingText.value,
                  ),
                  onChanged: (value) =>
                      controller.communicationRatingText.value = value,
                  decoration: _inputDecoration(
                    'Communication (0-5, optionnel)',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSatisfactionField(prestataire),
                const SizedBox(height: 16),
                Obx(() {
                  return DropdownButtonFormField<PrestataireStatus>(
                    initialValue: controller.status.value,
                    decoration: _inputDecoration('Statut *'),
                    items: PrestataireStatus.values.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      controller.status.value = value;
                    },
                  );
                }),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(
                    text: controller.observations.value,
                  ),
                  onChanged: (value) => controller.observations.value = value,
                  decoration: _inputDecoration('Observations (optionnel)'),
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

  /// Note de satisfaction client (retour utilisateur) : calculée à partir
  /// de l'historique des interventions, jamais saisie à la main — champ en
  /// lecture seule.
  Widget _buildSatisfactionField(Prestataire? prestataire) {
    final rating = prestataire == null
        ? null
        : Get.find<PrestatairesController>()
            .satisfactionRatingFor(prestataire.id);
    return InputDecorator(
      decoration: _inputDecoration('Satisfaction client (calculée)'),
      child: Row(
        children: [
          Icon(
            Icons.star,
            size: 18,
            color: rating == null
                ? AppColors.textSecondary
                : AppColors.warning,
          ),
          const SizedBox(width: 8),
          Text(
            rating == null
                ? 'Aucune donnée pour l\'instant'
                : '${rating.toStringAsFixed(1)} / 5',
            style: TextStyle(
              color: rating == null
                  ? AppColors.textSecondary
                  : AppColors.textPrimary,
            ),
          ),
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

  void _confirmDelete(BuildContext context, Prestataire prestataire) {
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
          'Supprimer le prestataire ${prestataire.fullName} ?',
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
              controller.deletePrestataire(prestataire.id);
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

/// Drawer qui glisse depuis la droite et s'arrête à mi-largeur de l'onglet
/// Prestataires, pour afficher les détails complets du prestataire cliqué
/// — y compris son nombre d'interventions effectuées (retour utilisateur).
class _PrestataireDrawer extends StatelessWidget {
  const _PrestataireDrawer();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PrestatairesController>();
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth / 2;
        return Obx(() {
          final id = controller.selectedPrestataireId.value;
          Prestataire? prestataire;
          if (id != null) {
            for (final p in controller.prestataires) {
              if (p.id == id) {
                prestataire = p;
                break;
              }
            }
          }
          final isOpen = prestataire != null;
          return Stack(
            children: [
              if (isOpen)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () => controller.selectPrestataire(null),
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
                  child: prestataire == null
                      ? const SizedBox.shrink()
                      : _PrestataireDrawerContent(
                          prestataire: prestataire,
                          onClose: () => controller.selectPrestataire(null),
                        ),
                ),
              ),
            ],
          );
        });
      },
    );
  }
}

class _PrestataireDrawerContent extends GetView<PrestatairesController> {
  const _PrestataireDrawerContent({
    required this.prestataire,
    required this.onClose,
  });

  final Prestataire prestataire;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    const view = PrestatairesContent();
    return Obx(() {
      // Lecture explicite pour que ce drawer se recalcule quand les
      // interventions changent (nombre effectué, satisfaction calculée).
      final interventionsCount =
          controller.completedInterventionsCountFor(prestataire.id);
      final satisfaction = controller.satisfactionRatingFor(prestataire.id);
      final rating = controller.finalRatingFor(prestataire);

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
                  onPressed: onClose,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    prestataire.fullName,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                view._buildStatusBadge(prestataire.status),
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
                    _buildInfoRow(Icons.badge_outlined, prestataire.reference,
                        copyable: true),
                    _buildInfoRow(Icons.phone_outlined, prestataire.phone),
                    _buildInfoRow(
                        Icons.engineering_outlined, prestataire.specialty),
                    if (prestataire.zone != null)
                      _buildInfoRow(
                          Icons.location_on_outlined, prestataire.zone!),
                    if (prestataire.experienceYears != null)
                      _buildInfoRow(
                        Icons.timeline_outlined,
                        '${prestataire.experienceYears} an(s) d\'expérience',
                      ),
                    if (prestataire.indicativeRate != null)
                      _buildInfoRow(
                        Icons.payments_outlined,
                        '${prestataire.indicativeRate!.toStringAsFixed(0)} FCFA (tarif indicatif)',
                      ),
                    _buildInfoRow(
                      Icons.task_alt_outlined,
                      '$interventionsCount intervention(s) effectuée(s)',
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          prestataire.identityVerified
                              ? Icons.verified_outlined
                              : Icons.remove_circle_outline,
                          size: 16,
                          color: prestataire.identityVerified
                              ? AppColors.success
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Identité vérifiée',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          prestataire.referencesVerified
                              ? Icons.verified_outlined
                              : Icons.remove_circle_outline,
                          size: 16,
                          color: prestataire.referencesVerified
                              ? AppColors.success
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Références vérifiées',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    if (prestataire.observations != null &&
                        prestataire.observations!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      _buildInfoRow(
                          Icons.notes_outlined, prestataire.observations!),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Notes',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
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
                    _buildRatingRow('Qualité', prestataire.qualityRating),
                    _buildRatingRow(
                        'Ponctualité', prestataire.punctualityRating),
                    _buildRatingRow(
                        'Communication', prestataire.communicationRating),
                    _buildRatingRow(
                        'Satisfaction client (calculée)', satisfaction),
                    const Divider(height: 20, color: AppColors.border),
                    _buildRatingRow('Note finale', rating, emphasis: true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      onClose();
                      view._showFormDialog(context, prestataire: prestataire);
                    },
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Modifier'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        view._confirmDelete(context, prestataire),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                    ),
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Supprimer'),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInfoRow(IconData icon, String value, {bool copyable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: copyable
                ? CopyableReference(
                    value,
                    style: const TextStyle(color: AppColors.textPrimary),
                  )
                : Text(
                    value,
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingRow(String label, double? value, {bool emphasis = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: emphasis ? FontWeight.w700 : FontWeight.normal,
              ),
            ),
          ),
          Icon(
            Icons.star,
            size: 16,
            color: value == null ? AppColors.textSecondary : AppColors.warning,
          ),
          const SizedBox(width: 4),
          Text(
            value == null ? 'N/A' : value.toStringAsFixed(1),
            style: TextStyle(
              color:
                  value == null ? AppColors.textSecondary : AppColors.textPrimary,
              fontWeight: emphasis ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
