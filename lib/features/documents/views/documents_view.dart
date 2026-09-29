import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:havena/app/theme/app_colors.dart';
import 'package:havena/features/documents/controllers/documents_controller.dart';

class DocumentsContent extends GetView<DocumentsController> {
  const DocumentsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Documents',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Générez un modèle de document HAVENA prérempli à partir des données de l'application.",
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 24),
          Container(
            constraints: const BoxConstraints(maxWidth: 560),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return DropdownButtonFormField<DocumentKind>(
                    initialValue: controller.selectedKind.value,
                    decoration: _inputDecoration('Type de document'),
                    items: DocumentKind.values.map((kind) {
                      return DropdownMenuItem(
                        value: kind,
                        child: Text(documentKindLabels[kind]!),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) controller.selectKind(value);
                    },
                  );
                }),
                const SizedBox(height: 16),
                Obx(() {
                  if (!controller.needsEntity) return const SizedBox.shrink();
                  final options = controller.entityOptions;
                  return DropdownButtonFormField<int>(
                    initialValue: controller.selectedEntityId.value,
                    decoration: _inputDecoration('Élément concerné'),
                    items: options
                        .map((option) => DropdownMenuItem(
                              value: option.id,
                              child: Text(
                                option.label,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      controller.selectedEntityId.value = value;
                    },
                    hint: options.isEmpty
                        ? const Text('Aucun élément disponible')
                        : const Text('Sélectionner'),
                  );
                }),
                const SizedBox(height: 20),
                Obx(() {
                  final error = controller.error.value;
                  if (error == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      error,
                      style: const TextStyle(color: AppColors.error),
                    ),
                  );
                }),
                Obx(() {
                  final generating = controller.isGenerating.value;
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed:
                          generating ? null : controller.generateAndPreview,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: generating
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.picture_as_pdf),
                      label: Text(
                        generating ? 'Génération...' : 'Générer / Aperçu PDF',
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
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
}
