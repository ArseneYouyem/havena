import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:havena/app/theme/app_colors.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/features/clients/controllers/clients_controller.dart';

class ClientsContent extends GetView<ClientsController> {
  const ClientsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Clients',
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
                    'Rechercher un client',
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
                label: const Text('Ajouter un client'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              final list = controller.visibleClients();
              if (list.isEmpty && controller.searchQuery.value.isEmpty) {
                return const Center(
                  child: Text(
                    'Aucun client',
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
                  final client = list[index];
                  return Card(
                    color: AppColors.surface,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            AppColors.primary.withValues(alpha: 0.1),
                        child: Text(
                          client.fullName.isNotEmpty
                              ? client.fullName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(color: AppColors.primary),
                        ),
                      ),
                      title: Text(
                        client.fullName,
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            client.reference,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${client.phone} • ${client.city}',
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
                          _buildStatusBadge(client.status),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            color: AppColors.textSecondary,
                            onPressed: () =>
                                _showFormDialog(context, client: client),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            color: AppColors.error,
                            onPressed: () => _confirmDelete(context, client),
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

  Widget _buildStatusBadge(ClientStatus status) {
    Color color;
    switch (status) {
      case ClientStatus.actif:
        color = AppColors.success;
        break;
      case ClientStatus.inactif:
        color = AppColors.textSecondary;
        break;
      case ClientStatus.suspendu:
        color = AppColors.warning;
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

  void _showFormDialog(BuildContext context, {Client? client}) {
    if (client != null) {
      controller.openEditForm(client);
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
          client == null ? 'Ajouter un client' : 'Modifier le client',
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller:
                      TextEditingController(text: controller.fullName.value),
                  onChanged: (value) => controller.fullName.value = value,
                  decoration: _inputDecoration('Nom complet *'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller:
                      TextEditingController(text: controller.phone.value),
                  onChanged: (value) => controller.phone.value = value,
                  decoration: _inputDecoration('Téléphone *'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller:
                      TextEditingController(text: controller.whatsapp.value),
                  onChanged: (value) => controller.whatsapp.value = value,
                  decoration: _inputDecoration('WhatsApp (optionnel)'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller:
                      TextEditingController(text: controller.email.value),
                  onChanged: (value) => controller.email.value = value,
                  decoration: _inputDecoration('Email (optionnel)'),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(
                            text: controller.country.value),
                        onChanged: (value) =>
                            controller.country.value = value,
                        decoration: _inputDecoration('Pays *'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(
                            text: controller.city.value),
                        onChanged: (value) => controller.city.value = value,
                        decoration: _inputDecoration('Ville *'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(
                      text: controller.clientType.value),
                  onChanged: (value) => controller.clientType.value = value,
                  decoration: _inputDecoration('Type de client *'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(
                      text: controller.logementReference.value),
                  onChanged: (value) =>
                      controller.logementReference.value = value,
                  decoration:
                      _inputDecoration('Référence logement (optionnel)'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(
                      text: controller.subscriptionFormula.value),
                  onChanged: (value) =>
                      controller.subscriptionFormula.value = value,
                  decoration:
                      _inputDecoration('Formule abonnement (optionnel)'),
                ),
                const SizedBox(height: 16),
                _buildDateField(context, 'Date de début (optionnel)',
                    controller.startDate),
                const SizedBox(height: 16),
                _buildDateField(context, 'Date de renouvellement (optionnel)',
                    controller.renewalDate),
                const SizedBox(height: 16),
                Obx(() {
                  return DropdownButtonFormField<ClientStatus>(
                    initialValue: controller.status.value,
                    decoration: _inputDecoration('Statut *'),
                    items: ClientStatus.values.map((status) {
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
                _buildDateField(context, 'Dernier contact (optionnel)',
                    controller.lastContactDate),
                const SizedBox(height: 16),
                TextField(
                  controller:
                      TextEditingController(text: controller.notes.value),
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

  Widget _buildDateField(
      BuildContext context, String label, Rxn<DateTime> dateField) {
    return InkWell(
      onTap: () async {
        final now = DateTime.now();
        final initial = dateField.value ?? now;
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

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
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

  void _confirmDelete(BuildContext context, Client client) {
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
          'Supprimer le client ${client.fullName} ?',
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
              controller.deleteClient(client.id);
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
