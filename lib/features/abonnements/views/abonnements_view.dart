import 'package:havena/shared/widgets/layout/page_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:havena/app/theme/app_colors.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/features/abonnements/controllers/abonnements_controller.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/documents/controllers/documents_controller.dart';
import 'package:havena/shared/widgets/copyable_reference.dart';
import 'package:havena/shared/widgets/generate_document_button.dart';

class AbonnementsContent extends GetView<AbonnementsController> {
  const AbonnementsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildListView(context),
        const _AbonnementDrawer(),
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
            title: 'Abonnements',
            subtitle: 'Suivez les contrats et les abonnements de vos clients.',
            icon: Icons.card_membership_outlined,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) => controller.searchQuery.value = value,
                  decoration: _inputDecoration(
                    'Rechercher un abonnement',
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
                icon: const Icon(Icons.add_card),
                label: const Text('Ajouter un abonnement'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildFiltersRow(context),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              final list = controller.visibleAbonnements();
              if (list.isEmpty && controller.abonnements.isEmpty) {
                return const Center(
                  child: Text(
                    'Aucun abonnement',
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
                  final abonnement = list[index];
                  return Card(
                    color: AppColors.surface,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      onTap: () => controller.selectAbonnement(abonnement.id),
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.1,
                        ),
                        child: const Icon(
                          Icons.receipt_long,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      title: CopyableReference(
                        abonnement.reference,
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            abonnement.formula,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          NameWithReference(
                            controller.clientNameFor(abonnement.clientId),
                            controller.clientReferenceFor(abonnement.clientId),
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          NameWithReference(
                            controller
                                .logementAddressFor(abonnement.logementId),
                            controller
                                .logementReferenceFor(abonnement.logementId),
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${abonnement.monthlyPrice.toStringAsFixed(0)} FCFA',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildPaymentStatusBadge(abonnement.paymentStatus),
                          if (controller.isRenewalOrPaymentSoon(
                            abonnement,
                          )) ...[
                            const SizedBox(width: 8),
                            const Tooltip(
                              message: 'Renouvellement ou paiement proche',
                              child: Icon(
                                Icons.warning_amber_rounded,
                                color: AppColors.warning,
                                size: 20,
                              ),
                            ),
                          ],
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            color: AppColors.textSecondary,
                            onPressed: () => _showFormDialog(
                              context,
                              abonnement: abonnement,
                            ),
                          ),
                          if (Get.find<SessionController>().isFondatrice)
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              color: AppColors.error,
                              onPressed: () =>
                                  _confirmDelete(context, abonnement),
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
              initialValue: controller.filterClientId.value,
              isExpanded: true,
              decoration: _inputDecoration('Client'),
              items: [
                const DropdownMenuItem<int?>(
                  value: null,
                  child: Text('Tous les clients'),
                ),
                ...controller.clients.map((client) {
                  return DropdownMenuItem<int?>(
                    value: client.id,
                    child: Text(
                      client.fullName,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }),
              ],
              onChanged: (value) => controller.filterClientId.value = value,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<int?>(
              initialValue: controller.filterLogementId.value,
              isExpanded: true,
              decoration: _inputDecoration('Logement'),
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
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<PaymentStatus?>(
              initialValue: controller.filterStatus.value,
              isExpanded: true,
              decoration: _inputDecoration('Statut'),
              items: [
                const DropdownMenuItem<PaymentStatus?>(
                  value: null,
                  child: Text('Tous les statuts'),
                ),
                ...PaymentStatus.values.map((status) {
                  return DropdownMenuItem<PaymentStatus?>(
                    value: status,
                    child: Text(status.name),
                  );
                }),
              ],
              onChanged: (value) => controller.filterStatus.value = value,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildPaymentStatusBadge(PaymentStatus status) {
    Color color;
    switch (status) {
      case PaymentStatus.aJour:
        color = AppColors.success;
        break;
      case PaymentStatus.enRetard:
        color = AppColors.warning;
        break;
      case PaymentStatus.impaye:
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
        status.name,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// [initController] à `false` permet de rouvrir ce même formulaire sans
  /// réinitialiser l'état du controller — utilisé par le bouton
  /// « Renouveler » du drawer, qui a déjà préparé les champs via
  /// `controller.openRenewForm(...)` juste avant.
  void _showFormDialog(
    BuildContext context, {
    Abonnement? abonnement,
    bool initController = true,
    String? titleOverride,
  }) {
    if (initController) {
      if (abonnement != null) {
        controller.openEditForm(abonnement);
      } else {
        controller.openCreateForm();
      }
    }

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.border),
        ),
        title: Text(
          titleOverride ??
              (abonnement == null
                  ? 'Ajouter un abonnement'
                  : 'Modifier l\'abonnement'),
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() {
                  final clientsList = controller.clients;
                  return DropdownButtonFormField<int?>(
                    initialValue: controller.clientId.value,
                    decoration: _inputDecoration('Client *'),
                    items: clientsList.map((client) {
                      return DropdownMenuItem<int?>(
                        value: client.id,
                        child: Text('${client.fullName} (${client.reference})'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      controller.clientId.value = value;
                    },
                  );
                }),
                const SizedBox(height: 16),
                Obx(() {
                  final logementsList = controller.logements;
                  return DropdownButtonFormField<int?>(
                    initialValue: controller.logementId.value,
                    decoration: _inputDecoration('Logement *'),
                    items: logementsList.map((logement) {
                      return DropdownMenuItem<int?>(
                        value: logement.id,
                        child: Text(
                          '${logement.reference} — ${logement.address}',
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      controller.logementId.value = value;
                    },
                  );
                }),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(
                    text: controller.formula.value,
                  ),
                  onChanged: (value) => controller.formula.value = value,
                  decoration: _inputDecoration('Formule *'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(
                    text: controller.monthlyPriceText.value,
                  ),
                  onChanged: (value) =>
                      controller.monthlyPriceText.value = value,
                  decoration: _inputDecoration('Prix mensuel (FCFA) *'),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDateField('Date de début *', controller.startDate),
                const SizedBox(height: 16),
                _buildDateField(
                  'Date de renouvellement',
                  controller.renewalDate,
                ),
                const SizedBox(height: 16),
                _buildDateField('Dernier paiement', controller.lastPaymentDate),
                const SizedBox(height: 16),
                _buildDateField(
                  'Prochain paiement',
                  controller.nextPaymentDate,
                ),
                const SizedBox(height: 16),
                Obx(() {
                  return DropdownButtonFormField<PaymentStatus?>(
                    initialValue: controller.paymentStatus.value,
                    decoration: _inputDecoration('Statut de paiement *'),
                    items: PaymentStatus.values.map((status) {
                      return DropdownMenuItem<PaymentStatus?>(
                        value: status,
                        child: Text(status.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      controller.paymentStatus.value = value;
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

  Widget _buildDateField(String label, Rxn<DateTime> dateField) {
    return Obx(() {
      final date = dateField.value;
      final textController = TextEditingController(
        text: date == null ? '' : _formatDate(date),
      );
      return TextField(
        controller: textController,
        readOnly: true,
        onTap: () async {
          final picked = await showDatePicker(
            context: Get.context!,
            initialDate: date ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (picked != null) {
            dateField.value = picked;
          }
        },
        decoration: _inputDecoration(label),
      );
    });
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  void _confirmDelete(BuildContext context, Abonnement abonnement) {
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
          'Supprimer l\'abonnement ${abonnement.reference} ?',
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
              controller.deleteAbonnement(abonnement.id);
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
/// Abonnements, pour afficher les détails complets de l'abonnement cliqué
/// (client, logement...) avec un bouton « Renouveler » qui préremplit le
/// formulaire de création d'un NOUVEL abonnement.
class _AbonnementDrawer extends StatelessWidget {
  const _AbonnementDrawer();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AbonnementsController>();
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth / 2;
        return Obx(() {
          final id = controller.selectedAbonnementId.value;
          Abonnement? abonnement;
          if (id != null) {
            for (final a in controller.abonnements) {
              if (a.id == id) {
                abonnement = a;
                break;
              }
            }
          }
          final isOpen = abonnement != null;
          return Stack(
            children: [
              if (isOpen)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () => controller.selectAbonnement(null),
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
                  child: abonnement == null
                      ? const SizedBox.shrink()
                      : _AbonnementDrawerContent(
                          abonnement: abonnement,
                          onClose: () => controller.selectAbonnement(null),
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

class _AbonnementDrawerContent extends GetView<AbonnementsController> {
  const _AbonnementDrawerContent({
    required this.abonnement,
    required this.onClose,
  });

  final Abonnement abonnement;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    const view = AbonnementsContent();
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
                child: CopyableReference(
                  abonnement.reference,
                  iconSize: 18,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              view._buildPaymentStatusBadge(abonnement.paymentStatus),
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
                    abonnement.formula,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${abonnement.monthlyPrice.toStringAsFixed(0)} FCFA / mois',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRowWidget(
                    Icons.person_outline,
                    NameWithReference(
                      controller.clientNameFor(abonnement.clientId),
                      controller.clientReferenceFor(abonnement.clientId),
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                  ),
                  _buildInfoRowWidget(
                    Icons.home_work_outlined,
                    NameWithReference(
                      controller.logementAddressFor(abonnement.logementId),
                      controller.logementReferenceFor(abonnement.logementId),
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                  ),
                  _buildInfoRow(
                    Icons.event_outlined,
                    'Début : ${view._formatDate(abonnement.startDate)}',
                  ),
                  if (abonnement.renewalDate != null)
                    _buildInfoRow(
                      Icons.event_repeat_outlined,
                      'Renouvellement : ${view._formatDate(abonnement.renewalDate!)}',
                    ),
                  if (abonnement.lastPaymentDate != null)
                    _buildInfoRow(
                      Icons.payments_outlined,
                      'Dernier paiement : ${view._formatDate(abonnement.lastPaymentDate!)}',
                    ),
                  if (abonnement.nextPaymentDate != null)
                    _buildInfoRow(
                      Icons.schedule_outlined,
                      'Prochain paiement : ${view._formatDate(abonnement.nextPaymentDate!)}',
                    ),
                  if (abonnement.observations != null &&
                      abonnement.observations!.isNotEmpty)
                    _buildInfoRow(
                      Icons.notes_outlined,
                      abonnement.observations!,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          GenerateDocumentButton(
            entityId: abonnement.id,
            kinds: const [DocumentKind.contratAbonnement],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                controller.openRenewForm(abonnement);
                onClose();
                view._showFormDialog(
                  context,
                  initController: false,
                  titleOverride: 'Renouveler l\'abonnement',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.autorenew),
              label: const Text('Renouveler'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String value) {
    return _buildInfoRowWidget(
      icon,
      Text(
        value,
        style: const TextStyle(color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildInfoRowWidget(IconData icon, Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(child: child),
        ],
      ),
    );
  }
}
