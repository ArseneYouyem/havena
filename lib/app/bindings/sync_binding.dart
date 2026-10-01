import 'package:get/get.dart';
import 'package:havena/app/controllers/sync_controller.dart';
import 'package:havena/core/storage/get_storage_service.dart';
import 'package:havena/core/sync/firestore_sync_gateway.dart';
import 'package:havena/core/sync/google_calendar_sync_service.dart';
import 'package:havena/core/sync/google_drive_auth_service.dart';
import 'package:havena/core/sync/google_drive_credentials_loader.dart';
import 'package:havena/core/sync/google_drive_sync_service.dart';
import 'package:havena/core/sync/google_drive_token_cache.dart';
import 'package:havena/core/sync/entity_sync_adapter.dart';
import 'package:havena/core/sync/google_sheets_export_service.dart';
import 'package:havena/core/sync/shared_drive_token_gateway.dart';
import 'package:havena/core/sync/sync_engine.dart';
import 'package:havena/core/sync/sync_gateway.dart';
import 'package:havena/features/abonnements/repositories/abonnements_repository.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/abonnements/sync/abonnement_sync_adapter.dart';
import 'package:havena/features/calendrier/repositories/calendrier_repository.dart';
import 'package:havena/features/calendrier/sync/calendrier_sync_adapter.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/clients/sync/client_sync_adapter.dart';
import 'package:havena/features/finances/repositories/finances_repository.dart';
import 'package:havena/features/finances/sync/finance_sync_adapter.dart';
import 'package:havena/features/inspections/repositories/inspections_repository.dart';
import 'package:havena/features/inspections/sync/inspection_sync_adapter.dart';
import 'package:havena/features/interventions/repositories/interventions_repository.dart';
import 'package:havena/features/interventions/sync/intervention_sync_adapter.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';
import 'package:havena/features/logements/sync/logement_sync_adapter.dart';
import 'package:havena/features/photos/repositories/photos_repository.dart';
import 'package:havena/features/prestataires/repositories/prestataires_repository.dart';
import 'package:havena/features/prestataires/sync/prestataire_sync_adapter.dart';
import 'package:havena/features/rapports/repositories/rapports_repository.dart';
import 'package:havena/features/rapports/sync/rapport_sync_adapter.dart';

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
    Get.lazyPut<SharedDriveTokenGateway>(() => SharedDriveTokenGateway());
    Get.lazyPut<GoogleDriveAuthService>(
      () => GoogleDriveAuthService(
        GoogleDriveCredentialsLoader(),
        Get.find<GoogleDriveTokenCache>(),
        Get.find<SharedDriveTokenGateway>(),
      ),
    );
    Get.lazyPut<GoogleDriveSyncService>(() => GoogleDriveSyncService());
    Get.lazyPut<GoogleSheetsExportService>(() => GoogleSheetsExportService());
    Get.lazyPut<GoogleCalendarSyncService>(
      () => GoogleCalendarSyncService(Get.find<SharedDriveTokenGateway>()),
    );
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
    Get.lazyPut<LogementSyncAdapter>(
      () => LogementSyncAdapter(
        Get.find<LogementsRepository>(),
        Get.find<ClientsRepository>(),
      ),
    );
    Get.lazyPut<RapportSyncAdapter>(
      () => RapportSyncAdapter(
        Get.find<RapportsRepository>(),
        Get.find<LogementsRepository>(),
      ),
    );
    Get.lazyPut<AbonnementSyncAdapter>(
      () => AbonnementSyncAdapter(
        Get.find<AbonnementsRepository>(),
        Get.find<ClientsRepository>(),
        Get.find<LogementsRepository>(),
      ),
    );
    Get.lazyPut<FinanceSyncAdapter>(
      () => FinanceSyncAdapter(
        Get.find<FinancesRepository>(),
        Get.find<ClientsRepository>(),
        Get.find<PrestatairesRepository>(),
      ),
    );
    Get.lazyPut<InterventionSyncAdapter>(
      () => InterventionSyncAdapter(
        Get.find<InterventionsRepository>(),
        Get.find<ClientsRepository>(),
        Get.find<LogementsRepository>(),
        Get.find<PrestatairesRepository>(),
        Get.find<InspectionsRepository>(),
      ),
    );
    Get.lazyPut<InspectionSyncAdapter>(
      () => InspectionSyncAdapter(
        Get.find<InspectionsRepository>(),
        Get.find<LogementsRepository>(),
      ),
    );
    Get.lazyPut<SyncController>(() => SyncController(
          authService: Get.find<GoogleDriveAuthService>(),
          syncService: Get.find<GoogleDriveSyncService>(),
          sheetsExportService: Get.find<GoogleSheetsExportService>(),
          calendarSyncService: Get.find<GoogleCalendarSyncService>(),
          photosRepository: Get.find<PhotosRepository>(),
          logementsRepository: Get.find<LogementsRepository>(),
          calendrierRepository: Get.find<CalendrierRepository>(),
          storage: Get.find<GetStorageService>(),
          syncEngine: Get.find<SyncEngine>(),
          sessionController: Get.find<SessionController>(),
          // Ordre important : les parents (Clients, Logements) doivent
          // être synchronisés avant leurs enfants (Rapports, Abonnements,
          // Finances...) pour que la traduction syncId -> id local trouve
          // déjà le parent lors du premier pull sur un nouvel appareil.
          // Inspections avant Interventions depuis que ces dernières
          // portent un `inspectionSyncId` (retour utilisateur : « on ne
          // fait pas d'intervention sans inspection »).
          businessAdapters: <EntitySyncAdapter>[
            Get.find<ClientSyncAdapter>(),
            Get.find<PrestataireSyncAdapter>(),
            Get.find<LogementSyncAdapter>(),
            Get.find<RapportSyncAdapter>(),
            Get.find<AbonnementSyncAdapter>(),
            Get.find<FinanceSyncAdapter>(),
            Get.find<InspectionSyncAdapter>(),
            Get.find<InterventionSyncAdapter>(),
            Get.find<CalendrierSyncAdapter>(),
          ],
        ));
  }
}
