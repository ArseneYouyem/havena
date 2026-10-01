import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// Affiche [filePaths] en grand, en partant de [initialIndex], avec zoom à
/// la souris et navigation entre images (flèches à l'écran + touches
/// gauche/droite du clavier) — utilisé partout où des miniatures de photos
/// sont affichées (inspections, interventions...).
void showPhotoPreview(
  BuildContext context,
  List<String> filePaths, {
  required int initialIndex,
}) {
  Get.dialog(
    _PhotoPreviewDialog(filePaths: filePaths, initialIndex: initialIndex),
  );
}

class _PhotoPreviewDialog extends StatefulWidget {
  const _PhotoPreviewDialog({
    required this.filePaths,
    required this.initialIndex,
  });

  final List<String> filePaths;
  final int initialIndex;

  @override
  State<_PhotoPreviewDialog> createState() => _PhotoPreviewDialogState();
}

class _PhotoPreviewDialogState extends State<_PhotoPreviewDialog> {
  late int _index;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _previous() {
    if (_index > 0) setState(() => _index--);
  }

  void _next() {
    if (_index < widget.filePaths.length - 1) setState(() => _index++);
  }

  @override
  Widget build(BuildContext context) {
    final hasMultiple = widget.filePaths.length > 1;
    return Dialog(
      backgroundColor: Colors.black,
      insetPadding: const EdgeInsets.all(24),
      child: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: (event) {
          if (event is! KeyDownEvent) return;
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft) _previous();
          if (event.logicalKey == LogicalKeyboardKey.arrowRight) _next();
          if (event.logicalKey == LogicalKeyboardKey.escape) Get.back();
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4,
                child: Image.file(
                  File(widget.filePaths[_index]),
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(Icons.broken_image,
                        color: Colors.white70, size: 48),
                  ),
                ),
              ),
            ),
            if (hasMultiple) ...[
              Positioned(
                left: 8,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    tooltip: 'Précédente',
                    icon: const Icon(Icons.chevron_left,
                        color: Colors.white, size: 36),
                    onPressed: _index > 0 ? _previous : null,
                  ),
                ),
              ),
              Positioned(
                right: 8,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    tooltip: 'Suivante',
                    icon: const Icon(Icons.chevron_right,
                        color: Colors.white, size: 36),
                    onPressed:
                        _index < widget.filePaths.length - 1 ? _next : null,
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    '${_index + 1} / ${widget.filePaths.length}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ],
            Positioned(
              right: 8,
              top: 8,
              child: IconButton(
                tooltip: 'Fermer',
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Get.back(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
