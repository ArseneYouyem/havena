import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/core/storage/file_storage_service.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';
import 'package:havena/features/photos/repositories/photos_repository.dart';

void main() {
  late Directory tempDir;
  late AppDatabase database;
  late LogementsRepository logementsRepository;
  late PhotosRepository photosRepository;
  late File sourceImage;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('havena_photos_test_');
    database = AppDatabase(NativeDatabase.memory());
    final referenceGenerator = ReferenceGeneratorService(database);
    logementsRepository =
        LogementsRepository(database.logementsDao, referenceGenerator);
    photosRepository = PhotosRepository(
      database.photosDao,
      FileStorageService(baseDirectory: tempDir),
    );
    sourceImage = File('${tempDir.path}/source.jpg');
    await sourceImage.writeAsBytes([1, 2, 3, 4]);
  });

  tearDown(() async {
    await database.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test(
      'classe une photo d\'intervention dans HAVENA/photos/<logement>/04 - Avant '
      'avec le nom de fichier de la convention HAVENA', () async {
    await logementsRepository.create(
      address: '1 rue du classement',
      updatedBy: 'test-uid',
    );
    final logement = (await logementsRepository.watchAll().first).first;

    await photosRepository.addPhotoFromFile(
      sourcePath: sourceImage.path,
      logementReference: logement.reference,
      entityReference: 'HAV-INT-000023',
      logementId: logement.id,
      photoType: PhotoType.avantIntervention,
      sequence: 1,
      updatedBy: 'test-uid',
    );

    final expectedFile = File(
        '${tempDir.path}/HAVENA/photos/${logement.reference}/04 - Avant/${logement.reference}_HAV-INT-000023_AVANTINTERVENTION_01.jpg');
    expect(await expectedFile.exists(), isTrue);

    final photos = await photosRepository.watchAll().first;
    expect(photos, hasLength(1));
    expect(photos.first.localFilePath, expectedFile.path);
  });

  test('classe une photo d\'inspection dans le dossier "02 - Inspections"',
      () async {
    await logementsRepository.create(
      address: '2 rue du classement',
      updatedBy: 'test-uid',
    );
    final logement = (await logementsRepository.watchAll().first).first;

    await photosRepository.addPhotoFromFile(
      sourcePath: sourceImage.path,
      logementReference: logement.reference,
      entityReference: 'HAV-INS-000005',
      logementId: logement.id,
      photoType: PhotoType.inspection,
      sequence: 3,
      updatedBy: 'test-uid',
    );

    final expectedFile = File(
        '${tempDir.path}/HAVENA/photos/${logement.reference}/02 - Inspections/${logement.reference}_HAV-INS-000005_INSPECTION_03.jpg');
    expect(await expectedFile.exists(), isTrue);
  });

  test(
      'ne duplique pas la référence dans le nom de fichier quand entityReference == logementReference',
      () async {
    await logementsRepository.create(
      address: '3 rue de l\'état initial',
      updatedBy: 'test-uid',
    );
    final logement = (await logementsRepository.watchAll().first).first;

    await photosRepository.addPhotoFromFile(
      sourcePath: sourceImage.path,
      logementReference: logement.reference,
      entityReference: logement.reference,
      logementId: logement.id,
      photoType: PhotoType.etatInitial,
      sequence: 1,
      updatedBy: 'test-uid',
    );

    final expectedFile = File(
        '${tempDir.path}/HAVENA/photos/${logement.reference}/01 - Etat initial/${logement.reference}_ETATINITIAL_01.jpg');
    expect(await expectedFile.exists(), isTrue);
  });
}
