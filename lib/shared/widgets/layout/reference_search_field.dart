import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:havena/app/controllers/reference_search_controller.dart';
import 'package:havena/app/theme/app_colors.dart';
import 'package:havena/shared/widgets/copyable_reference.dart';

/// Recherche transversale par référence HAVENA (cahier des charges §9) :
/// accessible depuis la topbar, quelle que soit la section active.
class ReferenceSearchField extends StatefulWidget {
  const ReferenceSearchField({super.key});

  @override
  State<ReferenceSearchField> createState() => _ReferenceSearchFieldState();
}

class _ReferenceSearchFieldState extends State<ReferenceSearchField> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _runSearch() {
    final query = _textController.text;
    if (query.trim().isEmpty) return;
    final controller = Get.find<ReferenceSearchController>();
    final results = controller.search(query);
    if (results.isEmpty) {
      Get.snackbar(
        'Recherche HAVENA',
        'Aucun résultat pour « $query ».',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
    if (results.length == 1) {
      _openDetail(results.first);
      return;
    }
    _showResultsDialog(results);
  }

  void _showResultsDialog(List<ReferenceSearchResult> results) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.border),
        ),
        title: const Text(
          'Résultats de recherche',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: SizedBox(
          width: 480,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];
              return ListTile(
                leading: Icon(_iconFor(result.type), color: AppColors.primary),
                title: CopyableReference(result.reference),
                subtitle: Text(
                  '${referenceTypeLabels[result.type]} - ${result.label}',
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  Get.back();
                  _openDetail(result);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Fermer',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  void _openDetail(ReferenceSearchResult result) {
    final selected = result.obs;

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.border),
        ),
        title: Obx(() {
          final current = selected.value;
          return Row(
            children: [
              Icon(_iconFor(current.type), color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      '${referenceTypeLabels[current.type]} - ',
                      style: const TextStyle(color: AppColors.textPrimary),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Flexible(
                      child: CopyableReference(
                        current.reference,
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
        content: SizedBox(
          width: 480,
          child: Obx(() {
            final current = selected.value;
            final controller = Get.find<ReferenceSearchController>();
            final details = controller.detailsFor(current);
            final related = controller.relatedFor(current);
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    current.label,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...details.map((entry) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 130,
                              child: Text(
                                entry.key,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                entry.value,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      )),
                  if (related.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Éléments liés',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ...related.map((r) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          leading:
                              Icon(_iconFor(r.type), color: AppColors.primary),
                          title: CopyableReference(r.reference),
                          subtitle: Text(
                            '${referenceTypeLabels[r.type]} - ${r.label}',
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: const Icon(Icons.chevron_right,
                              color: AppColors.textSecondary),
                          onTap: () => selected.value = r,
                        )),
                  ],
                ],
              ),
            );
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Fermer',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(ReferenceEntityType type) {
    switch (type) {
      case ReferenceEntityType.client:
        return Icons.people_outline;
      case ReferenceEntityType.logement:
        return Icons.home_work_outlined;
      case ReferenceEntityType.abonnement:
        return Icons.card_membership_outlined;
      case ReferenceEntityType.intervention:
        return Icons.build_outlined;
      case ReferenceEntityType.prestataire:
        return Icons.engineering_outlined;
      case ReferenceEntityType.finance:
        return Icons.account_balance_wallet_outlined;
      case ReferenceEntityType.rapport:
        return Icons.bar_chart_outlined;
      case ReferenceEntityType.inspection:
        return Icons.fact_check_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 38,
      child: TextField(
        controller: _textController,
        onSubmitted: (_) => _runSearch(),
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Référence HAVENA...',
          hintStyle: const TextStyle(fontSize: 13),
          prefixIcon: const Icon(Icons.search, size: 18),
          suffixIcon: IconButton(
            icon: const Icon(Icons.arrow_forward, size: 16),
            tooltip: 'Rechercher',
            onPressed: _runSearch,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}
