import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:havena/app/controllers/sync_controller.dart';
import 'package:havena/app/theme/app_colors.dart';
import 'package:havena/shared/widgets/layout/sync_conflict_dialog.dart';

/// Indicateur de synchronisation dans la topbar (cahier des charges :
/// « bouton explicite, statuts de sync »). « Synchroniser maintenant »
/// couvre toujours les données métier (Firestore) et, si connecté, les
/// photos (Google Drive) — la connexion Drive reste une action séparée.
class SyncStatusIndicator extends StatelessWidget {
  const SyncStatusIndicator({super.key});

  Future<void> _syncAndResolveConflicts(SyncController controller) async {
    await controller.syncNow();
    while (controller.pendingConflicts.isNotEmpty) {
      final conflict = controller.pendingConflicts.first;
      await Get.dialog(
        SyncConflictDialog(
          conflict: conflict,
          onResolve: (resolved) =>
              controller.resolveConflict(conflict, resolved),
        ),
        barrierDismissible: false,
      );
      // Sécurité anti-boucle infinie si l'utilisateur ferme sans résoudre.
      if (controller.pendingConflicts.contains(conflict)) {
        controller.pendingConflicts.remove(conflict);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SyncController>();

    return Obx(() {
      final connected = controller.isConnected.value;
      final syncing = controller.isSyncing.value;
      final pending = controller.pendingCount.value;
      final conflictsCount = controller.pendingConflicts.length;
      final lastSync = controller.lastSyncAt.value;
      final error = controller.error.value;

      final label = _labelFor(
        syncing: syncing,
        pending: pending,
        conflictsCount: conflictsCount,
        lastSync: lastSync,
        error: error,
      );
      final color = error != null || conflictsCount > 0
          ? AppColors.warning
          : (lastSync != null ? AppColors.success : AppColors.textSecondary);

      return PopupMenuButton<String>(
        tooltip: 'Synchronisation',
        onSelected: (value) {
          switch (value) {
            case 'sync':
              _syncAndResolveConflicts(controller);
              break;
            case 'connect':
              controller.connect();
              break;
            case 'disconnect':
              controller.disconnect();
              break;
          }
        },
        itemBuilder: (context) {
          return [
            const PopupMenuItem(
              value: 'sync',
              child: Text('Synchroniser maintenant'),
            ),
            // Seule la Fondatrice peut (re)connecter le compte Google
            // partagé de l'entreprise : le reconnecter avec un mauvais
            // compte écraserait le jeton partagé pour tout le monde (voir
            // `SyncController.canManageDriveConnection`).
            if (controller.canManageDriveConnection)
              PopupMenuItem(
                value: connected ? 'disconnect' : 'connect',
                child: Text(
                  connected
                      ? 'Se déconnecter du compte Google de l\'entreprise'
                      : 'Connecter le compte Google de l\'entreprise',
                ),
              ),
          ];
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (syncing)
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Icon(
                conflictsCount > 0
                    ? Icons.warning_amber_outlined
                    : Icons.cloud_outlined,
                size: 16,
                color: color,
              ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(fontSize: 13, color: color),
            ),
          ],
        ),
      );
    });
  }

  String _labelFor({
    required bool syncing,
    required int pending,
    required int conflictsCount,
    required DateTime? lastSync,
    required String? error,
  }) {
    if (error != null) return error;
    if (syncing) return 'Synchronisation...';
    if (conflictsCount > 0) return '$conflictsCount conflit(s) à résoudre';
    if (lastSync == null) {
      return pending > 0 ? '$pending photo(s) en attente' : 'Non synchronisé';
    }
    final hour = lastSync.hour.toString().padLeft(2, '0');
    final minute = lastSync.minute.toString().padLeft(2, '0');
    if (pending > 0) {
      return '$pending photo(s) en attente (sync $hour:$minute)';
    }
    return 'Synchronisé à $hour:$minute';
  }
}
