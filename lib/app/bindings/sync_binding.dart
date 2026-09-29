import 'package:get/get.dart';
import 'package:havena/app/controllers/sync_controller.dart';
import 'package:havena/core/storage/get_storage_service.dart';
import 'package:havena/core/sync/firestore_sync_gateway.dart';
import 'package:havena/core/sync/google_drive_auth_service.dart';
import 'package:havena/core/sync/google_drive_credentials_loader.dart';
import 'package:havena/core/sync/google_drive_sync_service.dart';
import 'package:havena/core/sync/google_drive_token_cache.dart';
import 'package:havena/core/sync/sync_engine.dart';
import 'package:havena/core/sync/sync_gateway.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/clients/sync/client_sync_adapter.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';
import 'package:havena/features/photos/repositories/photos_repository.dart';

/// Ne crée aucun repository métier : réutilise `PhotosRepository`,
/// `LogementsRepository` et `ClientsRepository` déjà enregistrés (doit
/// donc être déclarée après eux dans `AppPages`, comme
/// `DocumentsBinding`/`ReferenceSearchBinding`).
class SyncBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GoogleDriveTokenCache>(
      () => GoogleDriveTokenCache(Get.find<GetStorageService>()),
    );
    Get.lazyPut<GoogleDriveAuthService>(
      () => GoogleDriveAuthService(
        GoogleDriveCredentialsLoader(),
        Get.find<GoogleDriveTokenCache>(),
      ),
    );
    Get.lazyPut<GoogleDriveSyncService>(() => GoogleDriveSyncService());
    Get.lazyPut<SyncGateway>(() => FirestoreSyncGateway());
    Get.lazyPut<SyncEngine>(() => SyncEngine(Get.find<SyncGateway>()));
    Get.lazyPut<ClientSyncAdapter>(
      () => ClientSyncAdapter(Get.find<ClientsRepository>()),
    );
    Get.lazyPut<SyncController>(() => SyncController(
          authService: Get.find<GoogleDriveAuthService>(),
          syncService: Get.find<GoogleDriveSyncService>(),
          photosRepository: Get.find<PhotosRepository>(),
          logementsRepository: Get.find<LogementsRepository>(),
          storage: Get.find<GetStorageService>(),
          syncEngine: Get.find<SyncEngine>(),
          clientSyncAdapter: Get.find<ClientSyncAdapter>(),
        ));
  }
}
