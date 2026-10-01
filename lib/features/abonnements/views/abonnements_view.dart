import 'package:havena/shared/widgets/layout/page_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:havena/app/theme/app_colors.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/features/abonnements/controllers/abonnements_controller.dart';

class AbonnementsContent extends GetView<AbonnementsController> {
  const AbonnementsContent({super.key});

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              final list = controller.visibleAbonnements();
              if (list.isEmpty && controller.searchQuery.value.isEmpty) {
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
                      title: Text(
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
                          Text(
                            controller.clientLabelFor(abonnement.clientId),
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            controller.logementLabelFor(abonnement.logementId),
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

  void _showFormDialog(BuildContext context, {Abonnement? abonnement}) {
    if (abonnement != null) {
      controller.openEditForm(abonnement);
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
          abonnement == null
              ? 'Ajouter un abonnement'
              : 'Modifier l\'abonnement',
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
