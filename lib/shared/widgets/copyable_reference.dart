import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:havena/app/theme/app_colors.dart';

/// Affiche une référence HAVENA (HAV-XXX-000001) avec une icône de copie
/// (retour utilisateur : pouvoir copier n'importe quelle référence
/// affichée dans l'app, listes comme pages détail) — réutilisé partout où
/// une référence est affichée plutôt que dupliqué module par module.
class CopyableReference extends StatelessWidget {
  const CopyableReference(
    this.reference, {
    super.key,
    this.style,
    this.iconSize = 14,
    this.iconColor,
  });

  final String reference;
  final TextStyle? style;
  final double iconSize;
  final Color? iconColor;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: reference));
    Get.snackbar(
      'Référence copiée',
      reference,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            reference,
            style: style,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 4),
        Tooltip(
          message: 'Copier la référence',
          child: InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: _copy,
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Icon(
                Icons.copy_outlined,
                size: iconSize,
                color: iconColor ?? AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// « Nom (RÉFÉRENCE) » avec une icône de copie uniquement sur la
/// référence — pour les libellés d'entité liée (ex. « Client : Henri
/// bosco (HAV-CLI-000001) ») où seule la référence doit être copiable,
/// pas le nom. `prefix` optionnel (ex. « Client : »).
class NameWithReference extends StatelessWidget {
  const NameWithReference(
    this.name,
    this.reference, {
    super.key,
    required this.style,
    this.prefix,
  });

  final String name;
  final String? reference;
  final TextStyle style;
  final String? prefix;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('${prefix ?? ''}$name', style: style),
        if (reference != null && reference!.isNotEmpty) ...[
          Text(' (', style: style),
          CopyableReference(reference!, style: style),
          Text(')', style: style),
        ],
      ],
    );
  }
}
