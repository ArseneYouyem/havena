import 'package:havena/core/database/enums.dart';

/// Dossier PHOTOS par logement, cahier des charges §16. Utilisé à la fois
/// par le stockage local (`PhotosRepository`) et par la synchronisation
/// Google Drive (`GoogleDriveSyncService`), pour que l'arborescence locale
/// et celle du Drive restent identiques.
String photoCategoryFolder(PhotoType type) {
  switch (type) {
    case PhotoType.etatInitial:
      return '01 - Etat initial';
    case PhotoType.inspection:
      return '02 - Inspections';
    case PhotoType.avantIntervention:
      return '04 - Avant';
    case PhotoType.apresIntervention:
      return '05 - Apres';
    case PhotoType.autre:
      return '06 - Autres';
  }
}
