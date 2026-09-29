import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:havena/app/theme/app_colors.dart';
import 'package:havena/core/sync/field_merge_resolver.dart';
import 'package:havena/core/sync/sync_engine.dart';

/// Fenêtre de résolution de conflit générique (indépendante du type
/// d'entité) : actions globales (Tout garder local / Tout garder cloud /
/// Fusion automatique) + un choix individuel Local/Cloud par champ,
/// modifiable même après un choix global — décidé avec l'utilisateur.
///
/// [onResolve] reçoit le document final (fusion des choix) et doit
/// l'appliquer (ex. `SyncController.resolveClientConflict`).
class SyncConflictDialog extends StatefulWidget {
  const SyncConflictDialog({
    super.key,
    required this.conflict,
    required this.onResolve,
  });

  final SyncConflict conflict;
  final Future<void> Function(Map<String, dynamic> resolvedData) onResolve;

  @override
  State<SyncConflictDialog> createState() => _SyncConflictDialogState();
}

class _SyncConflictDialogState extends State<SyncConflictDialog> {
  late final List<String> _fields;
  final Map<String, bool> _useLocalByField = {};
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _fields = FieldMergeResolver.differingFields(
      _stripInternalKeys(widget.conflict.localData),
      _stripInternalKeys(widget.conflict.remoteData),
    );
    for (final field in _fields) {
      _useLocalByField[field] = true;
    }
  }

  Map<String, dynamic> _stripInternalKeys(Map<String, dynamic> data) {
    return {
      for (final entry in data.entries)
        if (!entry.key.startsWith('_')) entry.key: entry.value,
    };
  }

  void _applyGlobal(bool? useLocal) {
    setState(() {
      if (useLocal == null) {
        // Fusion automatique : priorité à la valeur remplie.
        final merged = FieldMergeResolver.autoMerge(
          _stripInternalKeys(widget.conflict.localData),
          _stripInternalKeys(widget.conflict.remoteData),
        );
        for (final field in _fields) {
          final localValue = widget.conflict.localData[field];
          _useLocalByField[field] = merged[field] == localValue;
        }
      } else {
        for (final field in _fields) {
          _useLocalByField[field] = useLocal;
        }
      }
    });
  }

  Future<void> _confirm() async {
    setState(() => _isSaving = true);
    final resolved = FieldMergeResolver.applyChoices(
      local: _stripInternalKeys(widget.conflict.localData),
      remote: _stripInternalKeys(widget.conflict.remoteData),
      useLocalByField: _useLocalByField,
    );
    await widget.onResolve(resolved);
    if (mounted) Get.back();
  }

  Widget _buildChoiceRow({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              size: 18,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _humanize(String field) {
    final withSpaces =
        field.replaceAllMapped(RegExp('([A-Z])'), (m) => ' ${m[1]}');
    return withSpaces[0].toUpperCase() + withSpaces.substring(1);
  }

  String _displayValue(dynamic value) {
    if (value == null) return 'Vide';
    if (value is bool) return value ? '[Oui]' : '[Non]';
    final text = value.toString();
    return text.isEmpty ? 'Vide' : text;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.border),
      ),
      title: const Text(
        'Conflit de synchronisation',
        style: TextStyle(color: AppColors.textPrimary),
      ),
      content: SizedBox(
        width: 560,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Cet enregistrement a été modifié à la fois sur cet appareil '
                'et ailleurs depuis la dernière synchronisation. Choisissez '
                'la version à conserver pour chaque champ, ou une action '
                'globale ci-dessous.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton(
                    onPressed: () => _applyGlobal(true),
                    child: const Text('Tout garder local'),
                  ),
                  OutlinedButton(
                    onPressed: () => _applyGlobal(false),
                    child: const Text('Tout garder cloud'),
                  ),
                  OutlinedButton(
                    onPressed: () => _applyGlobal(null),
                    child: const Text('Fusion automatique'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_fields.isEmpty)
                const Text(
                  'Aucune différence de champ détectée.',
                  style: TextStyle(color: AppColors.textSecondary),
                )
              else
                ..._fields.map((field) {
                  final localValue = widget.conflict.localData[field];
                  final remoteValue = widget.conflict.remoteData[field];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _humanize(field),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        _buildChoiceRow(
                          label: 'Local : ${_displayValue(localValue)}',
                          selected: _useLocalByField[field] == true,
                          onTap: () =>
                              setState(() => _useLocalByField[field] = true),
                        ),
                        _buildChoiceRow(
                          label: 'Cloud : ${_displayValue(remoteValue)}',
                          selected: _useLocalByField[field] == false,
                          onTap: () =>
                              setState(() => _useLocalByField[field] = false),
                        ),
                        const Divider(height: 1, color: AppColors.border),
                      ],
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Get.back(),
          child: const Text(
            'Plus tard',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _confirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          child: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text('Valider'),
        ),
      ],
    );
  }
}
