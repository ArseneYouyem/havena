// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modeles_documents_dao.dart';

// ignore_for_file: type=lint
mixin _$ModelesDocumentsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ModelesDocumentsTable get modelesDocuments =>
      attachedDatabase.modelesDocuments;
  ModelesDocumentsDaoManager get managers => ModelesDocumentsDaoManager(this);
}

class ModelesDocumentsDaoManager {
  final _$ModelesDocumentsDaoMixin _db;
  ModelesDocumentsDaoManager(this._db);
  $$ModelesDocumentsTableTableManager get modelesDocuments =>
      $$ModelesDocumentsTableTableManager(
        _db.attachedDatabase,
        _db.modelesDocuments,
      );
}
