import 'package:drift/drift.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/daos/photos_dao.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/storage/file_storage_service.dart';

class PhotosRepository {
  PhotosRepository(this._dao, this._fileStorageService);

  final PhotosDao _dao;
  final FileStorageService _fileStorageService;

  Stream<List<Photo>> watchAll() => _dao.watchAll();

  Future<List<Photo>> forInspection(int inspectionId) async {
    final all = await _dao.watchAll().first;
    return all.where((p) => p.inspectionId == inspectionId).toList();
  }

  Future<List<Photo>> forIntervention(int interventionId) async {
    final all = await _dao.watchAll().first;
    return all.where((p) => p.interventionId == interventionId).toList();
  }

  Future<void> addPhotoFromFile({
    required String sourcePath,
    required String entityReference,
    int? logementId,
    int? interventionId,
    int? inspectionId,
    required PhotoType photoType,
    required int sequence,
    required String updatedBy,
  }) async {
    final storedPath = await _fileStorageService.copyPhotoToAppStorage(
      sourcePath: sourcePath,
      entityReference: entityReference,
      typeLabel: photoType.name.toUpperCase(),
      sequence: sequence,
    );
    final fileName = storedPath.substring(storedPath.lastIndexOf('/') + 1);

    await _dao.insertOne(PhotosCompanion(
      logementId: Value(logementId),
      interventionId: Value(interventionId),
      inspectionId: Value(inspectionId),
      photoType: Value(photoType),
      fileName: Value(fileName),
      localFilePath: Value(storedPath),
      takenAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
      updatedBy: Value(updatedBy),
    ));
  }

  Future<void> delete(int id) => _dao.softDelete(id);
}
