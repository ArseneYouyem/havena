import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/storage/get_storage_service.dart';
import 'package:havena/core/storage/photo_category.dart';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:havena/core/sync/google_calendar_sync_service.dart';
import 'package:havena/core/sync/google_drive_auth_service.dart';
import 'package:havena/core/sync/google_drive_sync_service.dart';
import 'package:havena/core/sync/entity_sync_adapter.dart';
import 'package:havena/core/sync/google_sheets_export_service.dart';
import 'package:havena/core/sync/sync_engine.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/calendrier/repositories/calendrier_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';
import 'package:havena/features/photos/repositories/photos_repository.dart';

/// Contrôleur de synchronisation, monté au niveau du shell (topbar) — ne
/// crée aucun repository, réutilise ceux déjà enregistrés (même principe
/// que `DocumentsController`/`ReferenceSearchController`).
///
/// Deux volets, indépendants l'un de l'autre :
/// - **Données métier** (Firestore, via `SyncEngine`) : toujours possible,
///   l'authentification passe par la session Firebase déjà ouverte à la
///   connexion à l'app — pas besoin de « connexion Drive » séparée.
///   [businessAdapters] liste tous les modules déjà branchés à la
///   synchronisation (voir `SyncBinding`) — ajouter un module s'y résume à
///   ajouter son adaptateur à cette liste, aucun autre changement ici.
/// - **Photos** (Google Drive) : upload des photos locales non encore
///   synchronisées, nécessite la connexion OAuth Drive explicite
///   (`connect()`/`isConnected`).
class SyncController extends GetxController {
  SyncController({
    required GoogleDriveAuthService authService,
    required GoogleDriveSyncService syncService,
    required GoogleSheetsExportService sheetsExportService,
    required GoogleCalendarSyncService calendarSyncService,
    required PhotosRepository photosRepository,
    required LogementsRepository logementsRepository,
    required CalendrierRepository calendrierRepository,
    required GetStorageService storage,
    required SyncEngine syncEngine,
    required SessionController sessionController,
    required List<EntitySyncAdapter> businessAdapters,
  })  : _authService = authService,
        _syncService = syncService,
        _sheetsExportService = sheetsExportService,
        _calendarSyncService = calendarSyncService,
        _photosRepository = photosRepository,
        _logementsRepository = logementsRepository,
        _calendrierRepository = calendrierRepository,
        _storage = storage,
        _syncEngine = syncEngine,
        _sessionController = sessionController,
        _adaptersByCollection = {
          for (final adapter in businessAdapters)
            adapter.collectionName: adapter,
        };

  final GoogleDriveAuthService _authService;
  final GoogleDriveSyncService _syncService;
  final GoogleSheetsExportService _sheetsExportService;
  final GoogleCalendarSyncService _calendarSyncService;
  final PhotosRepository _photosRepository;
  final LogementsRepository _logementsRepository;
  final CalendrierRepository _calendrierRepository;
  final GetStorageService _storage;
  final SyncEngine _syncEngine;
  final SessionController _sessionController;
  final Map<String, EntitySyncAdapter> _adaptersByCollection;

  /// Seule la Fondatrice peut connecter/déconnecter le compte Drive partagé
  /// de l'entreprise (décision utilisateur) : le reconnecter avec un mauvais
  /// compte Google écraserait le jeton partagé pour tout le monde. Utilisé
  /// à la fois pour garder ce garde-fou ici et pour que `SyncStatusIndicator`
  /// masque les actions correspondantes aux autres rôles.
  bool get canManageDriveConnection => _sessionController.isFondatrice;

  static const String _lastSyncKey = 'google_drive_last_sync_at';
  static const String _lastBusinessSyncKey = 'business_data_last_sync_at';

  final isConnected = false.obs;
  final isSyncing = false.obs;
  final lastSyncAt = Rxn<DateTime>();
  final pendingCount = 0.obs;
  final error = Rxn<String>();
  final pendingConflicts = <SyncConflict>[].obs;

  DateTime? _lastBusinessSyncAt;
  AutoRefreshingAuthClient? _client;
  StreamSubscription<List<Photo>>? _photosSub;

  @override
  void onInit() {
    super.onInit();
    final storedSync = _storage.read<String>(_lastSyncKey);
    if (storedSync != null) {
      lastSyncAt.value = DateTime.tryParse(storedSync);
    }
    final storedBusinessSync = _storage.read<String>(_lastBusinessSyncKey);
    if (storedBusinessSync != null) {
      _lastBusinessSyncAt = DateTime.tryParse(storedBusinessSync);
    }
    _photosSub = _photosRepository.watchAll().listen((photos) {
      pendingCount.value = photos.where((p) => p.driveFileId == null).length;
    });
    _tryRestoreConnection();
  }

  @override
  void onClose() {
    _photosSub?.cancel();
    _client?.close();
    super.onClose();
  }

  Future<void> _tryRestoreConnection() async {
    final client = await _authService.getClient();
    if (client != null) {
      _client = client;
      isConnected.value = true;
    }
  }

  Future<void> connect() async {
    if (isConnected.value) return;
    if (!canManageDriveConnection) {
      error.value =
          'Seule la Fondatrice peut connecter le compte Google de l\'entreprise.';
      return;
    }
    error.value = null;
    try {
      _client = await _authService.connect(
        connectedByUid: _sessionController.session.value!.uid,
      );
      isConnected.value = true;
    } catch (_) {
      error.value = 'Connexion Google Drive refusée ou annulée.';
    }
  }

  Future<void> disconnect() async {
    if (!canManageDriveConnection) {
      error.value =
          'Seule la Fondatrice peut déconnecter le compte Google de l\'entreprise.';
      return;
    }
    _client?.close();
    _client = null;
    await _authService.disconnect();
    isConnected.value = false;
  }

  /// Synchronise les données métier (Firestore, toujours possible) puis,
  /// si connecté, les photos (Google Drive). Les conflits détectés côté
  /// données métier sont ajoutés à [pendingConflicts] pour résolution par
  /// l'utilisateur (fenêtre générique) — rien n'est écrasé pour eux.
  Future<void> syncNow() async {
    if (isSyncing.value) return;
    isSyncing.value = true;
    error.value = null;
    try {
      for (final adapter in _adaptersByCollection.values) {
        final conflicts = await _syncEngine.syncEntity(
          adapter,
          lastDeviceSyncAt: _lastBusinessSyncAt,
        );
        pendingConflicts.addAll(conflicts);
      }
      _lastBusinessSyncAt = DateTime.now();
      await _storage.write(
        _lastBusinessSyncKey,
        _lastBusinessSyncAt!.toIso8601String(),
      );

      if (isConnected.value) {
        final client = await _resolveDriveClient();
        if (client != null) {
          await _syncPhotosToDrive(client);
          await _exportSheets(client);
          await _syncCalendarToGoogle(client);
        }
      }

      lastSyncAt.value = DateTime.now();
      await _storage.write(_lastSyncKey, lastSyncAt.value!.toIso8601String());
    } catch (e) {
      error.value = 'Erreur de synchronisation : $e';
    } finally {
      isSyncing.value = false;
    }
  }

  /// Résout un client OAuth Drive/Sheets déjà en mémoire, ou le reconstruit
  /// à partir du refresh token stocké. `null` si la session a expiré
  /// (auquel cas [isConnected] est désactivé et [error] est renseigné).
  Future<AutoRefreshingAuthClient?> _resolveDriveClient() async {
    var client = _client;
    client ??= await _authService.getClient();
    if (client == null) {
      isConnected.value = false;
      error.value = 'Session Google Drive expirée, reconnecte-toi.';
      return null;
    }
    _client = client;
    return client;
  }

  Future<void> _syncPhotosToDrive(AutoRefreshingAuthClient client) async {
    final api = drive.DriveApi(client);

    final logements = await _logementsRepository.watchAll().first;
    final logementRefById = {for (final l in logements) l.id: l.reference};

    final pending = await _photosRepository.pendingSync();
    for (final photo in pending) {
      final localFile = File(photo.localFilePath);
      if (!await localFile.exists()) continue;

      final logementReference =
          logementRefById[photo.logementId] ?? 'SANS-LOGEMENT';
      final driveFileId = await _syncService.uploadFile(
        api,
        localFile: localFile,
        folderPath: [
          'HAVENA',
          'photos',
          logementReference,
          photoCategoryFolder(photo.photoType),
        ],
        fileName: photo.fileName,
      );
      await _photosRepository.markSynced(
        id: photo.id,
        driveFileId: driveFileId,
      );
    }
  }

  /// Régénère la vue tableur Google Sheets (un onglet par module,
  /// remplacée en entier à chaque synchronisation — lecture seule, jamais
  /// réinjectée dans l'app).
  Future<void> _exportSheets(AutoRefreshingAuthClient client) async {
    final driveApi = drive.DriveApi(client);
    final sheetsApi = sheets.SheetsApi(client);
    final folderId =
        await _syncService.ensureFolderPath(driveApi, const ['HAVENA']);
    final spreadsheetId = await _sheetsExportService.ensureSpreadsheet(
      sheetsApi,
      driveApi,
      folderId,
    );
    for (final adapter in _adaptersByCollection.values) {
      await _sheetsExportService.exportEntity(sheetsApi, spreadsheetId, adapter);
    }
  }

  /// Régénère le calendrier secondaire Google « HAVENA » (créé au premier
  /// passage, son id mémorisé dans Firestore) et y pousse tous les
  /// évènements du module Calendrier — création ou mise à jour selon que
  /// l'évènement a déjà un `googleEventId` (voir `GoogleCalendarSyncService`).
  Future<void> _syncCalendarToGoogle(AutoRefreshingAuthClient client) async {
    final api = calendar.CalendarApi(client);
    final calendarId = await _calendarSyncService.ensureCalendar(api);
    await _calendarSyncService.syncEvents(
      api,
      calendarId,
      _calendrierRepository,
    );
  }

  /// Applique la résolution d'un conflit métier (choix global ou champ par
  /// champ, voir `FieldMergeResolver`) et le retire de [pendingConflicts].
  /// Retrouve l'adaptateur concerné via `conflict.collectionName`.
  Future<void> resolveConflict(
    SyncConflict conflict,
    Map<String, dynamic> resolvedData,
  ) async {
    final adapter = _adaptersByCollection[conflict.collectionName];
    if (adapter == null) return;
    await _syncEngine.resolveConflict(adapter, conflict, resolvedData);
    pendingConflicts.remove(conflict);
  }
}
