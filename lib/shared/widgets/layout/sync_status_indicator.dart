import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:havena/app/controllers/sync_controller.dart';
import 'package:havena/app/theme/app_colors.dart';

/// Indicateur de synchronisation Google Drive dans la topbar (cahier des
/// charges : « bouton explicite, statuts de sync »). Un clic connecte le
/// compte Google (première fois) ou lance une synchronisation ; le menu
/// contextuel permet de se déconnecter.
class SyncStatusIndicator extends StatelessWidget {
  const SyncStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SyncController>();

    return Obx(() {
      final connected = controller.isConnected.value;
      final syncing = controller.isSyncing.value;
      final pending = controller.pendingCount.value;
      final lastSync = controller.lastSyncAt.value;
      final error = controller.error.value;

      final label = _labelFor(
        connected: connected,
        syncing: syncing,
        pending: pending,
        lastSync: lastSync,
        error: error,
      );
      final color = error != null
          ? AppColors.error
          : (connected ? AppColors.success : AppColors.textSecondary);

      return PopupMenuButton<String>(
        tooltip: 'Synchronisation Google Drive',
        onSelected: (value) {
          switch (value) {
            case 'connect':
            case 'sync':
              controller.syncNow();
              break;
            case 'disconnect':
              controller.disconnect();
              break;
          }
        },
        itemBuilder: (context) {
          if (!connected) {
            return const [
              PopupMenuItem(
                value: 'connect',
                child: Text('Se connecter à Google Drive'),
              ),
            ];
          }
          return const [
            PopupMenuItem(
              value: 'sync',
              child: Text('Synchroniser maintenant'),
            ),
            PopupMenuItem(
              value: 'disconnect',
              child: Text('Se déconnecter'),
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
                connected ? Icons.cloud_done_outlined : Icons.cloud_off_outlined,
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
    required bool connected,
    required bool syncing,
    required int pending,
    required DateTime? lastSync,
    required String? error,
  }) {
    if (error != null) return error;
    if (syncing) return 'Synchronisation...';
    if (!connected) return 'Non connecté';
    if (lastSync == null) {
      return pending > 0 ? '$pending en attente' : 'Connecté';
    }
    final hour = lastSync.hour.toString().padLeft(2, '0');
    final minute = lastSync.minute.toString().padLeft(2, '0');
    if (pending > 0) {
      return '$pending en attente (sync $hour:$minute)';
    }
    return 'Synchronisé à $hour:$minute';
  }
}
