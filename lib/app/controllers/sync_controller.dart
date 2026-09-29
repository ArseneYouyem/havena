import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/storage/get_storage_service.dart';
import 'package:havena/core/storage/photo_category.dart';
import 'package:havena/core/sync/google_drive_auth_service.dart';
import 'package:havena/core/sync/google_drive_sync_service.dart';
import 'package:havena/core/sync/sync_engine.dart';
import 'package:havena/features/clients/sync/client_sync_adapter.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';
import 'package:havena/features/photos/repositories/photos_repository.dart';

/// Contrôleur de synchronisation, monté au niveau du shell (topbar) — ne
/// crée aucun repository, réutilise ceux déjà enregistrés (même principe
/// que `DocumentsController`/`ReferenceSearchController`).
///
/// Deux volets, indépendants l'un de l'autre :
/// - **Données métier** (Firestore, via `SyncEngine`) : toujours possible,
///   l'authentification passe par la session Firebase déjà ouverte à la
///   connexion à l'app — pas besoin de « connexion Drive » séparée. Seul
///   `ClientSyncAdapter` est branché pour l'instant (entité de référence,
///   les autres modules suivront le même pattern).
/// - **Photos** (Google Drive) : upload des photos locales non encore
///   synchronisées, nécessite la connexion OAuth Drive explicite
///   (`connect()`/`isConnected`).
class SyncController extends GetxController {
  SyncController({
    required GoogleDriveAuthService authService,
    required GoogleDriveSyncService syncService,
    required PhotosRepository photosRepository,
    required LogementsRepository logementsRepository,
    required GetStorageService storage,
    required SyncEngine syncEngine,
    required ClientSyncAdapter clientSyncAdapter,
  })  : _authService = authService,
        _syncService = syncService,
        _photosRepository = photosRepository,
        _logementsRepository = logementsRepository,
        _storage = storage,
        _syncEngine = syncEngine,
        _clientSyncAdapter = clientSyncAdapter;

  final GoogleDriveAuthService _authService;
  final GoogleDriveSyncService _syncService;
  final PhotosRepository _photosRepository;
  final LogementsRepository _logementsRepository;
  final GetStorageService _storage;
  final SyncEngine _syncEngine;
  final ClientSyncAdapter _clientSyncAdapter;

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
    error.value = null;
    try {
      _client = await _authService.connect();
      isConnected.value = true;
    } catch (_) {
      error.value = 'Connexion Google Drive refusée ou annulée.';
    }
  }

  Future<void> disconnect() async {
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
      final conflicts = await _syncEngine.syncEntity(
        _clientSyncAdapter,
        lastDeviceSyncAt: _lastBusinessSyncAt,
      );
      pendingConflicts.addAll(conflicts);
      _lastBusinessSyncAt = DateTime.now();
      await _storage.write(
        _lastBusinessSyncKey,
        _lastBusinessSyncAt!.toIso8601String(),
      );

      if (isConnected.value) {
        await _syncPhotosToDrive();
      }

      lastSyncAt.value = DateTime.now();
      await _storage.write(_lastSyncKey, lastSyncAt.value!.toIso8601String());
    } catch (e) {
      error.value = 'Erreur de synchronisation : $e';
    } finally {
      isSyncing.value = false;
    }
  }

  Future<void> _syncPhotosToDrive() async {
    var client = _client;
    client ??= await _authService.getClient();
    if (client == null) {
      isConnected.value = false;
      error.value = 'Session Google Drive expirée, reconnecte-toi.';
      return;
    }
    _client = client;
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

  /// Applique la résolution d'un conflit métier (choix global ou champ par
  /// champ, voir `FieldMergeResolver`) et le retire de [pendingConflicts].
  Future<void> resolveClientConflict(
    SyncConflict conflict,
    Map<String, dynamic> resolvedData,
  ) async {
    await _syncEngine.resolveConflict(
      _clientSyncAdapter,
      conflict,
      resolvedData,
    );
    pendingConflicts.remove(conflict);
  }
}
