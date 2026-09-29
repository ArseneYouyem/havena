import 'package:get/get.dart';
import 'package:havena/app/controllers/sync_controller.dart';
import 'package:havena/core/storage/get_storage_service.dart';
import 'package:havena/core/sync/firestore_sync_gateway.dart';
import 'package:havena/core/sync/google_drive_auth_service.dart';
import 'package:havena/core/sync/google_drive_credentials_loader.dart';
import 'package:havena/core/sync/google_drive_sync_service.dart';
import 'package:havena/core/sync/google_drive_token_cache.dart';
import 'package:havena/core/sync/entity_sync_adapter.dart';
import 'package:havena/core/sync/sync_engine.dart';
import 'package:havena/core/sync/sync_gateway.dart';
import 'package:havena/features/calendrier/repositories/calendrier_repository.dart';
import 'package:havena/features/calendrier/sync/calendrier_sync_adapter.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/clients/sync/client_sync_adapter.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';
import 'package:havena/features/photos/repositories/photos_repository.dart';
import 'package:havena/features/prestataires/repositories/prestataires_repository.dart';
import 'package:havena/features/prestataires/sync/prestataire_sync_adapter.dart';

/// Ne crée aucun repository métier : réutilise ceux déjà enregistrés par
/// les autres bindings (doit donc être déclarée après eux dans
/// `AppPages`, comme `DocumentsBinding`/`ReferenceSearchBinding`).
///
/// Pour ajouter un module à la synchronisation Firestore : créer son
/// adaptateur (voir `ClientSyncAdapter` comme référence), l'enregistrer
/// ci-dessous, l'ajouter à `businessAdapters` — rien d'autre à changer.
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
    Get.lazyPut<PrestataireSyncAdapter>(
      () => PrestataireSyncAdapter(Get.find<PrestatairesRepository>()),
    );
    Get.lazyPut<CalendrierSyncAdapter>(
      () => CalendrierSyncAdapter(Get.find<CalendrierRepository>()),
    );
    Get.lazyPut<SyncController>(() => SyncController(
          authService: Get.find<GoogleDriveAuthService>(),
          syncService: Get.find<GoogleDriveSyncService>(),
          photosRepository: Get.find<PhotosRepository>(),
          logementsRepository: Get.find<LogementsRepository>(),
          storage: Get.find<GetStorageService>(),
          syncEngine: Get.find<SyncEngine>(),
          businessAdapters: <EntitySyncAdapter>[
            Get.find<ClientSyncAdapter>(),
            Get.find<PrestataireSyncAdapter>(),
            Get.find<CalendrierSyncAdapter>(),
          ],
        ));
  }
}
