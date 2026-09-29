import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Copie les fichiers importés (photos) dans un dossier structuré par
/// logement, nommé selon la convention HAVENA (cahier des charges §16) :
/// `HAVENA/photos/{référence logement}/{dossier catégorie}/{référence
/// logement}_{référence entité}_{TYPE}_{NN}.{ext}` (ex :
/// `HAV-DLA-000001_INT-000023_AVANT_01.jpg`).
class FileStorageService {
  /// `baseDirectory` permet d'injecter un répertoire de test (au lieu du
  /// vrai dossier applicatif via `path_provider`, non disponible dans
  /// `flutter test`) — voir `AppDatabase([QueryExecutor? executor])` pour
  /// le même principe appliqué à la base de données.
  FileStorageService({Directory? baseDirectory})
      : _baseDirectoryOverride = baseDirectory;

  final Directory? _baseDirectoryOverride;

  Future<String> copyPhotoToAppStorage({
    required String sourcePath,
    required String logementReference,
    required String categoryFolder,
    required String entityReference,
    required String typeLabel,
    required int sequence,
  }) async {
    final documentsDir =
        _baseDirectoryOverride ?? await getApplicationDocumentsDirectory();
    final photosDir = Directory(
        '${documentsDir.path}/HAVENA/photos/$logementReference/$categoryFolder');
    if (!await photosDir.exists()) {
      await photosDir.create(recursive: true);
    }

    final extension = sourcePath.contains('.')
        ? sourcePath.substring(sourcePath.lastIndexOf('.'))
        : '.jpg';
    final sequenceLabel = sequence.toString().padLeft(2, '0');
    final fileName = entityReference == logementReference
        ? '${logementReference}_${typeLabel}_$sequenceLabel$extension'
        : '${logementReference}_${entityReference}_${typeLabel}_$sequenceLabel$extension';
    final destinationPath = '${photosDir.path}/$fileName';

    await File(sourcePath).copy(destinationPath);
    return destinationPath;
  }
}
