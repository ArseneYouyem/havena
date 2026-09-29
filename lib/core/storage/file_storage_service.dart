import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Copie les fichiers importés (photos) dans un dossier structuré de
/// l'espace applicatif, nommé selon la convention HAVENA (cahier des
/// charges §16) : `<référence>_<TYPE>_<NN>.<ext>`.
class FileStorageService {
  Future<String> copyPhotoToAppStorage({
    required String sourcePath,
    required String entityReference,
    required String typeLabel,
    required int sequence,
  }) async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final photosDir = Directory('${documentsDir.path}/HAVENA/photos');
    if (!await photosDir.exists()) {
      await photosDir.create(recursive: true);
    }

    final extension = sourcePath.contains('.')
        ? sourcePath.substring(sourcePath.lastIndexOf('.'))
        : '.jpg';
    final sequenceLabel = sequence.toString().padLeft(2, '0');
    final fileName =
        '${entityReference}_${typeLabel}_$sequenceLabel$extension';
    final destinationPath = '${photosDir.path}/$fileName';

    await File(sourcePath).copy(destinationPath);
    return destinationPath;
  }
}
