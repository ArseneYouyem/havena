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
import 'package:havena/features/logements/repositories/logements_repository.dart';
import 'package:havena/features/photos/repositories/photos_repository.dart';

/// Contrôleur de synchronisation Google Drive, monté au niveau du shell
/// (topbar) — ne crée aucun repository, réutilise ceux déjà enregistrés
/// (même principe que `DocumentsController`/`ReferenceSearchController`).
///
/// Portée actuelle : upload des photos locales non encore synchronisées
/// (`Photo.driveFileId == null`) vers un dossier Drive qui reproduit
/// exactement l'arborescence locale (`HAVENA/photos/<logement>/<catégorie>/`).
/// La synchronisation des données métier (Clients, Logements...) via
/// Firestore est un chantier séparé.
class SyncController extends GetxController {
  SyncController({
    required GoogleDriveAuthService authService,
    required GoogleDriveSyncService syncService,
    required PhotosRepository photosRepository,
    required LogementsRepository logementsRepository,
    required GetStorageService storage,
  })  : _authService = authService,
        _syncService = syncService,
        _photosRepository = photosRepository,
        _logementsRepository = logementsRepository,
        _storage = storage;

  final GoogleDriveAuthService _authService;
  final GoogleDriveSyncService _syncService;
  final PhotosRepository _photosRepository;
  final LogementsRepository _logementsRepository;
  final GetStorageService _storage;

  static const String _lastSyncKey = 'google_drive_last_sync_at';

  final isConnected = false.obs;
  final isSyncing = false.obs;
  final lastSyncAt = Rxn<DateTime>();
  final pendingCount = 0.obs;
  final error = Rxn<String>();

  AutoRefreshingAuthClient? _client;
  StreamSubscription<List<Photo>>? _photosSub;

  @override
  void onInit() {
    super.onInit();
    final storedSync = _storage.read<String>(_lastSyncKey);
    if (storedSync != null) {
      lastSyncAt.value = DateTime.tryParse(storedSync);
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

  Future<void> syncNow() async {
    if (!isConnected.value || isSyncing.value) return;
    isSyncing.value = true;
    error.value = null;
    try {
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

      lastSyncAt.value = DateTime.now();
      await _storage.write(_lastSyncKey, lastSyncAt.value!.toIso8601String());
    } catch (e) {
      error.value = 'Erreur de synchronisation : $e';
    } finally {
      isSyncing.value = false;
    }
  }
}
