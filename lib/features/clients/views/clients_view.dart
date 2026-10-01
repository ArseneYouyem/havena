import 'package:havena/shared/widgets/layout/page_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:havena/app/theme/app_colors.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/clients/controllers/clients_controller.dart';
import 'package:havena/features/documents/controllers/documents_controller.dart';
import 'package:havena/shared/widgets/copyable_reference.dart';
import 'package:havena/shared/widgets/generate_document_button.dart';

class ClientsContent extends GetView<ClientsController> {
  const ClientsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildListView(context),
        const _ClientDrawer(),
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
            title: 'Clients',
            subtitle: 'Les contacts et informations de vos clients.',
            icon: Icons.people_outline,
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
                      onTap: () => controller.selectClient(client.id),
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.1,
                        ),
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
                          CopyableReference(
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
                          Obx(() => _buildAbonnementIcon(
                              controller.abonnementStatusFor(client.id))),
                          const SizedBox(width: 8),
                          _buildStatusBadge(client.status),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            color: AppColors.textSecondary,
                            onPressed: () =>
                                _showFormDialog(context, client: client),
                          ),
                          if (Get.find<SessionController>().isFondatrice)
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              color: AppColors.error,
                              onPressed: () =>
                                  _confirmDelete(context, client),
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

  Widget _buildAbonnementIcon(ClientAbonnementStatus status) {
    switch (status) {
      case ClientAbonnementStatus.none:
        return const Tooltip(
          message: 'Aucun abonnement',
          child: Icon(
            Icons.card_membership_outlined,
            color: AppColors.textSecondary,
            size: 18,
          ),
        );
      case ClientAbonnementStatus.active:
        return const Tooltip(
          message: 'Abonnement actif',
          child: Icon(
            Icons.verified_outlined,
            color: AppColors.success,
            size: 18,
          ),
        );
      case ClientAbonnementStatus.renewingSoon:
        return const Tooltip(
          message: 'Renouvellement proche',
          child: Icon(
            Icons.hourglass_bottom_outlined,
            color: AppColors.alertOrange,
            size: 18,
          ),
        );
    }
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
                    text: controller.whatsapp.value,
                  ),
                  onChanged: (value) => controller.whatsapp.value = value,
                  decoration: _inputDecoration('WhatsApp (optionnel)'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(
                    text: controller.email.value,
                  ),
                  onChanged: (value) => controller.email.value = value,
                  decoration: _inputDecoration('Email (optionnel)'),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(
                          text: controller.country.value,
                        ),
                        onChanged: (value) => controller.country.value = value,
                        decoration: _inputDecoration('Pays *'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(
                          text: controller.city.value,
                        ),
                        onChanged: (value) => controller.city.value = value,
                        decoration: _inputDecoration('Ville *'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(
                    text: controller.clientType.value,
                  ),
                  onChanged: (value) => controller.clientType.value = value,
                  decoration: _inputDecoration('Type de client *'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(
                    text: controller.logementReference.value,
                  ),
                  onChanged: (value) =>
                      controller.logementReference.value = value,
                  decoration: _inputDecoration(
                    'Référence logement (optionnel)',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(
                    text: controller.subscriptionFormula.value,
                  ),
                  onChanged: (value) =>
                      controller.subscriptionFormula.value = value,
                  decoration: _inputDecoration(
                    'Formule abonnement (optionnel)',
                  ),
                ),
                const SizedBox(height: 16),
                _buildDateField(
                  context,
                  'Date de début (optionnel)',
                  controller.startDate,
                ),
                const SizedBox(height: 16),
                _buildDateField(
                  context,
                  'Date de renouvellement (optionnel)',
                  controller.renewalDate,
                ),
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
                _buildDateField(
                  context,
                  'Dernier contact (optionnel)',
                  controller.lastContactDate,
                ),
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

  Widget _buildDateField(
    BuildContext context,
    String label,
    Rxn<DateTime> dateField,
  ) {
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

/// Drawer qui glisse depuis la droite et s'arrête à mi-largeur de l'onglet
/// Clients pour afficher les détails du client cliqué et la liste de ses
/// logements enregistrés, sans changer d'onglet.
class _ClientDrawer extends StatelessWidget {
  const _ClientDrawer();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientsController>();
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth / 2;
        return Obx(() {
          final id = controller.selectedClientId.value;
          Client? client;
          if (id != null) {
            for (final c in controller.clients) {
              if (c.id == id) {
                client = c;
                break;
              }
            }
          }
          final isOpen = client != null;
          return Stack(
            children: [
              if (isOpen)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () => controller.selectClient(null),
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
                  child: client == null
                      ? const SizedBox.shrink()
                      : _ClientDrawerContent(
                          client: client,
                          onClose: () => controller.selectClient(null),
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

class _ClientDrawerContent extends GetView<ClientsController> {
  const _ClientDrawerContent({required this.client, required this.onClose});

  final Client client;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
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
                  client.fullName,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GenerateDocumentButton(
            entityId: client.id,
            kinds: const [DocumentKind.ficheClient],
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
                  _buildInfoRow(Icons.badge_outlined, client.reference,
                      copyable: true),
                  _buildInfoRow(Icons.phone_outlined, client.phone),
                  if (client.whatsapp != null && client.whatsapp!.isNotEmpty)
                    _buildInfoRow(Icons.chat_outlined, client.whatsapp!),
                  if (client.email != null && client.email!.isNotEmpty)
                    _buildInfoRow(Icons.email_outlined, client.email!),
                  _buildInfoRow(
                    Icons.location_on_outlined,
                    '${client.city}, ${client.country}',
                  ),
                  _buildInfoRow(Icons.category_outlined, client.clientType),
                  if (client.subscriptionFormula != null &&
                      client.subscriptionFormula!.isNotEmpty)
                    _buildInfoRow(
                      Icons.card_membership_outlined,
                      client.subscriptionFormula!,
                    ),
                  if (client.notes != null && client.notes!.isNotEmpty)
                    _buildInfoRow(Icons.notes_outlined, client.notes!),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.home_work_outlined,
                  size: 18, color: AppColors.secondaryText),
              const SizedBox(width: 8),
              const Text(
                'Logements',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() {
            final logements = controller.logementsForClient(client.id);
            if (logements.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Aucun logement enregistré',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              );
            }
            return Column(
              children: logements.map((logement) {
                return Card(
                  color: AppColors.surface,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.home, color: AppColors.primary),
                    title: Text(
                      logement.address,
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                    subtitle: CopyableReference(
                      logement.reference,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.card_membership_outlined,
                  size: 18, color: AppColors.secondaryText),
              const SizedBox(width: 8),
              const Text(
                'Historique des abonnements',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() {
            final abonnements = controller.abonnementsForClient(client.id);
            if (abonnements.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Aucun abonnement enregistré',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              );
            }
            return Column(
              children: abonnements.map((abonnement) {
                return Card(
                  color: AppColors.surface,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  child: ListTile(
                    leading:
                        const Icon(Icons.receipt_long, color: AppColors.primary),
                    title: Text(
                      abonnement.formula,
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                    subtitle: Text(
                      'Souscrit le ${_formatDate(abonnement.startDate)}'
                      '${abonnement.renewalDate != null ? ' — expire le ${_formatDate(abonnement.renewalDate!)}' : ''}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
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
}
