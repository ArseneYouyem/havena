import 'package:drift/drift.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/tables/photos_table.dart';

part 'photos_dao.g.dart';

@DriftAccessor(tables: [Photos])
class PhotosDao extends DatabaseAccessor<AppDatabase> with _$PhotosDaoMixin {
  PhotosDao(super.db);

  Stream<List<Photo>> watchAll() =>
      (select(photos)..where((t) => t.isDeleted.equals(false))).watch();

  Future<Photo?> getById(int id) =>
      (select(photos)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertOne(PhotosCompanion companion) =>
      into(photos).insert(companion);

  Future<bool> updateOne(PhotosCompanion companion) =>
      update(photos).replace(companion);

  Future<int> softDelete(int id) => (update(photos)
        ..where((t) => t.id.equals(id)))
      .write(const PhotosCompanion(isDeleted: Value(true)));
}
