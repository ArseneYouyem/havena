import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:havena/app/theme/app_colors.dart';
import 'package:havena/features/documents/controllers/documents_controller.dart';

/// Bouton « Générer le document » affiché dans un drawer de détail
/// (retour utilisateur : pouvoir générer directement le document lié à
/// l'entité consultée, sans passer par les menus déroulants de la page
/// Documents). Réutilise [DocumentsController], enregistré en permanence
/// par `DocumentsBinding` aux côtés de tous les autres modules métier.
/// Avec plusieurs [kinds] (ex. Intervention : fiche / devis / facture),
/// affiche un menu de choix au clic.
class GenerateDocumentButton extends StatelessWidget {
  const GenerateDocumentButton({
    super.key,
    required this.entityId,
    required this.kinds,
  }) : assert(kinds.length > 0);

  final int entityId;
  final List<DocumentKind> kinds;

  Future<void> _generate(DocumentKind kind) async {
    final controller = Get.find<DocumentsController>();
    await controller.generateAndPreviewFor(kind, entityId);
    final error = controller.error.value;
    if (error != null) {
      Get.snackbar(
        'Erreur',
        error,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _handleTap(BuildContext context) async {
    if (kinds.length == 1) {
      await _generate(kinds.first);
      return;
    }
    final box = context.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        box.localToGlobal(Offset.zero, ancestor: overlay),
        box.localToGlobal(box.size.bottomLeft(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    final selected = await showMenu<DocumentKind>(
      context: context,
      position: position,
      items: kinds
          .map((kind) => PopupMenuItem(
                value: kind,
                child: Text(documentKindLabels[kind]!),
              ))
          .toList(),
    );
    if (selected != null) {
      await _generate(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DocumentsController>();
    return Obx(() {
      final isGenerating = controller.isGenerating.value;
      final label = kinds.length == 1
          ? 'Générer : ${documentKindLabels[kinds.first]}'
          : 'Générer un document';
      return OutlinedButton.icon(
        onPressed: isGenerating ? null : () => _handleTap(context),
        icon: isGenerating
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.picture_as_pdf_outlined),
        label: Text(isGenerating ? 'Génération...' : label),
      );
    });
  }
}
