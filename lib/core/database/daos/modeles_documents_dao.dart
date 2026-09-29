import 'package:drift/drift.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/tables/modeles_documents_table.dart';

part 'modeles_documents_dao.g.dart';

@DriftAccessor(tables: [ModelesDocuments])
class ModelesDocumentsDao extends DatabaseAccessor<AppDatabase>
    with _$ModelesDocumentsDaoMixin {
  ModelesDocumentsDao(super.db);

  Stream<List<ModelesDocument>> watchAll() => (select(modelesDocuments)
        ..where((t) => t.isDeleted.equals(false)))
      .watch();

  Future<ModelesDocument?> getById(int id) => (select(modelesDocuments)
        ..where((t) => t.id.equals(id)))
      .getSingleOrNull();

  Future<int> insertOne(ModelesDocumentsCompanion companion) =>
      into(modelesDocuments).insert(companion);

  Future<bool> updateOne(ModelesDocumentsCompanion companion) =>
      update(modelesDocuments).replace(companion);

  Future<int> softDelete(int id) => (update(modelesDocuments)
        ..where((t) => t.id.equals(id)))
      .write(const ModelesDocumentsCompanion(isDeleted: Value(true)));
}
