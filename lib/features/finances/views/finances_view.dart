import 'package:havena/shared/widgets/layout/page_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:havena/app/theme/app_colors.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/features/finances/controllers/finances_controller.dart';

/// Sépare les milliers d'un montant, comme sur le tableau de bord (retour
/// utilisateur) — ex. 400000 -> "400 000 FCFA".
String _formatAmount(double amount) {
  final rounded = amount.round().abs();
  final digits = rounded.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(' ');
    buffer.write(digits[i]);
  }
  final sign = amount < 0 ? '-' : '';
  return '$sign${buffer.toString()} FCFA';
}

class FinancesContent extends GetView<FinancesController> {
  const FinancesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildListView(context),
        const _FinanceDrawer(),
      ],
    );
  }

  Widget _buildListView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: PageHeader(
                  title: 'Finances',
                  subtitle:
                      'Gardez une vue claire sur vos entrées et dépenses.',
                  icon: Icons.account_balance_wallet_outlined,
                ),
              ),
              _buildMonthFilterButton(context),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            final monthSelected = controller.selectedMonth.value != null;
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
                  // « Solde » n'a de sens que cumulé depuis le début ; sur
                  // un mois isolé, c'est une marge de la période (retour
                  // utilisateur).
                  monthSelected ? 'Marge' : 'Solde',
                  controller.solde,
                  controller.solde >= 0 ? AppColors.success : AppColors.error,
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
          const SizedBox(height: 12),
          _buildFiltersRow(context),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              final list = controller.visibleFinances();
              if (list.isEmpty && controller.finances.isEmpty) {
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
                  final isEntree =
                      finance.transactionType == TransactionType.entree;
                  final amountColor =
                      isEntree ? AppColors.success : AppColors.error;
                  return Card(
                    elevation: 0,
                    color: AppColors.surface,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: AppColors.border),
                    ),
                    child: ListTile(
                      onTap: () => controller.selectFinance(finance.id),
                      leading: CircleAvatar(
                        backgroundColor: amountColor.withValues(alpha: 0.08),
                        child: Icon(
                          isEntree
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: amountColor,
                          size: 18,
                        ),
                      ),
                      title: Text(
                        finance.description,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        _formatDate(finance.transactionDate),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      trailing: Text(
                        '${isEntree ? '+' : '-'}${_formatAmount(finance.amount)}',
                        style: TextStyle(
                          color: amountColor,
                          fontWeight: FontWeight.w600,
                        ),
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

  String _monthLabel(String period) {
    final parts = period.split('-');
    final month = int.parse(parts[1]);
    return '${_monthLabels[month - 1]} ${parts[0]}';
  }

  /// Bouton de filtre par mois (retour utilisateur) : à l'extrême droite de
  /// la ligne de titre. « Tous les mois » par défaut, sinon limite les
  /// cartes de synthèse ET la liste aux transactions du mois choisi.
  Widget _buildMonthFilterButton(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedMonth.value;
      final months = controller.availableMonths();
      return PopupMenuButton<String?>(
        tooltip: 'Filtrer par mois',
        onSelected: (value) => controller.selectedMonth.value = value,
        itemBuilder: (context) => [
          const PopupMenuItem<String?>(
            value: null,
            child: Text('Tous les mois'),
          ),
          ...months.map((month) {
            return PopupMenuItem<String?>(
              value: month,
              child: Text(_monthLabel(month)),
            );
          }),
        ],
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.calendar_month_outlined,
                size: 18,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                selected == null ? 'Tous les mois' : _monthLabel(selected),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildFiltersRow(BuildContext context) {
    return Obx(() {
      return Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<TransactionType?>(
              initialValue: controller.filterType.value,
              isExpanded: true,
              decoration: _inputDecoration('Type'),
              items: [
                const DropdownMenuItem<TransactionType?>(
                  value: null,
                  child: Text('Tous les types'),
                ),
                ...TransactionType.values.map((type) {
                  return DropdownMenuItem<TransactionType?>(
                    value: type,
                    child: Text(type.name),
                  );
                }),
              ],
              onChanged: (value) => controller.filterType.value = value,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<TransactionStatus?>(
              initialValue: controller.filterStatus.value,
              isExpanded: true,
              decoration: _inputDecoration('Statut'),
              items: [
                const DropdownMenuItem<TransactionStatus?>(
                  value: null,
                  child: Text('Tous les statuts'),
                ),
                ...TransactionStatus.values.map((status) {
                  return DropdownMenuItem<TransactionStatus?>(
                    value: status,
                    child: Text(status.name),
                  );
                }),
              ],
              onChanged: (value) => controller.filterStatus.value = value,
            ),
          ),
          const SizedBox(width: 12),
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
              initialValue: controller.filterPrestataireId.value,
              isExpanded: true,
              decoration: _inputDecoration('Prestataire'),
              items: [
                const DropdownMenuItem<int?>(
                  value: null,
                  child: Text('Tous les prestataires'),
                ),
                ...controller.prestataires.map((prestataire) {
                  return DropdownMenuItem<int?>(
                    value: prestataire.id,
                    child: Text(
                      prestataire.fullName,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }),
              ],
              onChanged: (value) =>
                  controller.filterPrestataireId.value = value,
            ),
          ),
        ],
      );
    });
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
                _formatAmount(value),
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
                  'Date de transaction *',
                  controller.transactionDate,
                ),
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
                            '${client.fullName} (${client.reference})',
                          ),
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
                            '${prestataire.fullName} (${prestataire.reference})',
                          ),
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
                    text: controller.description.value,
                  ),
                  onChanged: (value) => controller.description.value = value,
                  decoration: _inputDecoration('Description *'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(
                    text: controller.amountText.value,
                  ),
                  onChanged: (value) => controller.amountText.value = value,
                  decoration: _inputDecoration('Montant (FCFA) *'),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(
                    text: controller.paymentMethod.value,
                  ),
                  onChanged: (value) => controller.paymentMethod.value = value,
                  decoration: _inputDecoration(
                    'Méthode de paiement (optionnel)',
                  ),
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
                    text: controller.periodMonth.value,
                  ),
                  onChanged: (value) => controller.periodMonth.value = value,
                  decoration: _inputDecoration(
                    'Mois de période * (format YYYY-MM)',
                  ),
                  keyboardType: TextInputType.datetime,
                ),
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

/// Drawer qui glisse depuis la droite et s'arrête à mi-largeur de l'onglet
/// Finances (retour utilisateur : liste allégée, détails complets affichés
/// uniquement au clic) — même principe que les drawers Clients/Logements.
class _FinanceDrawer extends StatelessWidget {
  const _FinanceDrawer();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FinancesController>();
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth / 2;
        return Obx(() {
          final id = controller.selectedFinanceId.value;
          Finance? finance;
          if (id != null) {
            for (final f in controller.finances) {
              if (f.id == id) {
                finance = f;
                break;
              }
            }
          }
          final isOpen = finance != null;
          return Stack(
            children: [
              if (isOpen)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () => controller.selectFinance(null),
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
                  child: finance == null
                      ? const SizedBox.shrink()
                      : _FinanceDrawerContent(
                          finance: finance,
                          onClose: () => controller.selectFinance(null),
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

class _FinanceDrawerContent extends GetView<FinancesController> {
  const _FinanceDrawerContent({required this.finance, required this.onClose});

  final Finance finance;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    const view = FinancesContent();
    final isEntree = finance.transactionType == TransactionType.entree;
    final amountColor = isEntree ? AppColors.success : AppColors.error;
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
                  finance.reference,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              view._buildStatusBadge(finance.status),
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
                    finance.description,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${isEntree ? '+' : '-'}${_formatAmount(finance.amount)}',
                    style: TextStyle(
                      color: amountColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    Icons.event_outlined,
                    view._formatDate(finance.transactionDate),
                  ),
                  _buildInfoRow(
                    Icons.calendar_month_outlined,
                    'Période : ${finance.periodMonth}',
                  ),
                  if (controller
                      .clientLabelFor(finance.relatedClientId)
                      .isNotEmpty)
                    _buildInfoRow(
                      Icons.person_outline,
                      controller.clientLabelFor(finance.relatedClientId),
                    ),
                  if (controller
                      .prestataireLabelFor(finance.relatedPrestataireId)
                      .isNotEmpty)
                    _buildInfoRow(
                      Icons.engineering_outlined,
                      controller
                          .prestataireLabelFor(finance.relatedPrestataireId),
                    ),
                  if (finance.paymentMethod != null &&
                      finance.paymentMethod!.isNotEmpty)
                    _buildInfoRow(
                      Icons.payment_outlined,
                      finance.paymentMethod!,
                    ),
                  if (finance.observations != null &&
                      finance.observations!.isNotEmpty)
                    _buildInfoRow(
                      Icons.notes_outlined,
                      finance.observations!,
                    ),
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
                    view._showFormDialog(context, finance: finance);
                  },
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Modifier'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => view._confirmDelete(context, finance),
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
  }

  Widget _buildInfoRow(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
