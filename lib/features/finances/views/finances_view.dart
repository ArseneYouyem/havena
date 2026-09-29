import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:havena/app/theme/app_colors.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/features/finances/controllers/finances_controller.dart';

class FinancesContent extends GetView<FinancesController> {
  const FinancesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Finances',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            return Row(
              children: [
                _buildSummaryCard(
                  'Total entrées',
                  controller.totalEntrees,
                  AppColors.success,
                ),
                const SizedBox(width: 12),
                _buildSummaryCard(
                  'Total sorties',
                  controller.totalSorties,
                  AppColors.error,
                ),
                const SizedBox(width: 12),
                _buildSummaryCard(
                  'Solde',
                  controller.solde,
                  controller.solde >= 0
                      ? AppColors.success
                      : AppColors.error,
                ),
              ],
            );
          }),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) => controller.searchQuery.value = value,
                  decoration: _inputDecoration(
                    'Rechercher une transaction',
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
                label: const Text('Ajouter une transaction'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              final list = controller.visibleFinances();
              if (list.isEmpty && controller.searchQuery.value.isEmpty) {
                return const Center(
                  child: Text(
                    'Aucune transaction',
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
                  final finance = list[index];
                  return Card(
                    color: AppColors.surface,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            AppColors.primary.withValues(alpha: 0.1),
                        child: const Icon(Icons.payments,
                            color: AppColors.primary, size: 20),
                      ),
                      title: Text(
                        finance.reference,
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            finance.description,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            _formatDate(finance.transactionDate),
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${finance.transactionType == TransactionType.entree ? '+' : '-'}${finance.amount.toStringAsFixed(2)} FCFA',
                            style: TextStyle(
                              color: finance.transactionType ==
                                      TransactionType.entree
                                  ? AppColors.success
                                  : AppColors.error,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (controller
                              .clientLabelFor(finance.relatedClientId)
                              .isNotEmpty)
                            Text(
                              controller
                                  .clientLabelFor(finance.relatedClientId),
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          if (controller
                              .prestataireLabelFor(
                                  finance.relatedPrestataireId)
                              .isNotEmpty)
                            Text(
                              controller.prestataireLabelFor(
                                  finance.relatedPrestataireId),
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
                          _buildStatusBadge(finance.status),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            color: AppColors.textSecondary,
                            onPressed: () =>
                                _showFormDialog(context, finance: finance),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            color: AppColors.error,
                            onPressed: () =>
                                _confirmDelete(context, finance),
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

  Widget _buildSummaryCard(String label, double value, Color color) {
    return Expanded(
      child: Card(
        color: AppColors.surface,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${value.toStringAsFixed(2)} FCFA',
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(TransactionStatus status) {
    Color color;
    switch (status) {
      case TransactionStatus.enAttente:
        color = AppColors.warning;
        break;
      case TransactionStatus.valide:
        color = AppColors.success;
        break;
      case TransactionStatus.annule:
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

  void _showFormDialog(BuildContext context, {Finance? finance}) {
    if (finance != null) {
      controller.openEditForm(finance);
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
          finance == null
              ? 'Ajouter une transaction'
              : 'Modifier la transaction',
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDateField(
                    'Date de transaction *', controller.transactionDate),
                const SizedBox(height: 16),
                Obx(() {
                  return DropdownButtonFormField<TransactionType>(
                    initialValue: controller.transactionType.value,
                    decoration: _inputDecoration('Type de transaction *'),
                    items: TransactionType.values.map((type) {
                      return DropdownMenuItem<TransactionType>(
                        value: type,
                        child: Text(type.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      controller.transactionType.value = value;
                    },
                  );
                }),
                const SizedBox(height: 16),
                Obx(() {
                  final clientsList = controller.clients;
                  return DropdownButtonFormField<int?>(
                    initialValue: controller.relatedClientId.value,
                    decoration: _inputDecoration('Client (optionnel)'),
                    items: [
                      const DropdownMenuItem<int?>(
                        value: null,
                        child: Text('Aucun'),
                      ),
                      ...clientsList.map((client) {
                        return DropdownMenuItem<int?>(
                          value: client.id,
                          child: Text(
                              '${client.fullName} (${client.reference})'),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      controller.relatedClientId.value = value;
                    },
                  );
                }),
                const SizedBox(height: 16),
                Obx(() {
                  final prestatairesList = controller.prestataires;
                  return DropdownButtonFormField<int?>(
                    initialValue: controller.relatedPrestataireId.value,
                    decoration: _inputDecoration('Prestataire (optionnel)'),
                    items: [
                      const DropdownMenuItem<int?>(
                        value: null,
                        child: Text('Aucun'),
                      ),
                      ...prestatairesList.map((prestataire) {
                        return DropdownMenuItem<int?>(
                          value: prestataire.id,
                          child: Text(
                              '${prestataire.fullName} (${prestataire.reference})'),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      controller.relatedPrestataireId.value = value;
                    },
                  );
                }),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(
                      text: controller.description.value),
                  onChanged: (value) => controller.description.value = value,
                  decoration: _inputDecoration('Description *'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(
                      text: controller.amountText.value),
                  onChanged: (value) => controller.amountText.value = value,
                  decoration: _inputDecoration('Montant (FCFA) *'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(
                      text: controller.paymentMethod.value),
                  onChanged: (value) =>
                      controller.paymentMethod.value = value,
                  decoration:
                      _inputDecoration('Méthode de paiement (optionnel)'),
                ),
                const SizedBox(height: 16),
                Obx(() {
                  return DropdownButtonFormField<TransactionStatus>(
                    initialValue: controller.status.value,
                    decoration: _inputDecoration('Statut *'),
                    items: TransactionStatus.values.map((status) {
                      return DropdownMenuItem<TransactionStatus>(
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
                      text: controller.periodMonth.value),
                  onChanged: (value) => controller.periodMonth.value = value,
                  decoration:
                      _inputDecoration('Mois de période * (format YYYY-MM)'),
                  keyboardType: TextInputType.datetime,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(
                      text: controller.observations.value),
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

  void _confirmDelete(BuildContext context, Finance finance) {
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
          'Supprimer la transaction ${finance.reference} ?',
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
              controller.deleteFinance(finance.id);
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
