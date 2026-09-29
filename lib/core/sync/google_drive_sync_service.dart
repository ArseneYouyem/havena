import 'dart:io';

import 'package:googleapis/drive/v3.dart' as drive;

/// Type MIME déduit de l'extension, pour l'upload Drive. Fonction pure
/// extraite pour rester testable sans appel réseau.
String driveContentTypeFor(String fileName) {
  final lower = fileName.toLowerCase();
  if (lower.endsWith('.png')) return 'image/png';
  if (lower.endsWith('.pdf')) return 'application/pdf';
  return 'image/jpeg';
}

/// Échappe une valeur pour une requête Drive `q=...`. Fonction pure extraite
/// pour rester testable sans appel réseau.
String escapeDriveQueryValue(String value) => value.replaceAll("'", "\\'");

/// Utilitaire Drive générique (ne connaît rien du schéma métier HAVENA) :
/// retrouve ou crée une arborescence de dossiers, puis y dépose un fichier.
/// La correspondance « quel dossier pour quel type d'entité » reste du
/// ressort de l'appelant (`SyncController`), comme `FileStorageService`
/// reste agnostique du `PhotoType` pour le stockage local.
class GoogleDriveSyncService {
  /// Retrouve (ou crée) un dossier nommé [name] sous [parentId] (racine du
  /// Drive si `null`), et retourne son id.
  Future<String> ensureFolder(
    drive.DriveApi api, {
    required String name,
    String? parentId,
  }) async {
    final query = StringBuffer(
      "name = '${escapeDriveQueryValue(name)}' and mimeType = 'application/vnd.google-apps.folder' and trashed = false",
    );
    if (parentId != null) {
      query.write(" and '$parentId' in parents");
    }

    final result = await api.files.list(
      q: query.toString(),
      spaces: 'drive',
      $fields: 'files(id,name)',
    );
    final existing = result.files;
    if (existing != null && existing.isNotEmpty) {
      return existing.first.id!;
    }

    final created = await api.files.create(drive.File(
      name: name,
      mimeType: 'application/vnd.google-apps.folder',
      parents: parentId != null ? [parentId] : null,
    ));
    return created.id!;
  }

  /// Crée (si besoin) toute la chaîne de dossiers [segments], dans l'ordre,
  /// et retourne l'id du dernier dossier de la chaîne.
  Future<String> ensureFolderPath(
    drive.DriveApi api,
    List<String> segments,
  ) async {
    String? parentId;
    for (final segment in segments) {
      parentId = await ensureFolder(api, name: segment, parentId: parentId);
    }
    return parentId!;
  }

  /// Envoie [localFile] dans le dossier [folderPath] (créé si nécessaire),
  /// sous le nom [fileName]. Retourne l'id Drive du fichier créé.
  Future<String> uploadFile(
    drive.DriveApi api, {
    required File localFile,
    required List<String> folderPath,
    required String fileName,
  }) async {
    final folderId = await ensureFolderPath(api, folderPath);
    final length = await localFile.length();
    final media = drive.Media(
      localFile.openRead(),
      length,
      contentType: driveContentTypeFor(fileName),
    );
    final created = await api.files.create(
      drive.File(name: fileName, parents: [folderId]),
      uploadMedia: media,
    );
    return created.id!;
  }
}
