// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photos_dao.dart';

// ignore_for_file: type=lint
mixin _$PhotosDaoMixin on DatabaseAccessor<AppDatabase> {
  $ClientsTable get clients => attachedDatabase.clients;
  $LogementsTable get logements => attachedDatabase.logements;
  $PrestatairesTable get prestataires => attachedDatabase.prestataires;
  $InterventionsTable get interventions => attachedDatabase.interventions;
  $InspectionsTable get inspections => attachedDatabase.inspections;
  $PhotosTable get photos => attachedDatabase.photos;
  PhotosDaoManager get managers => PhotosDaoManager(this);
}

class PhotosDaoManager {
  final _$PhotosDaoMixin _db;
  PhotosDaoManager(this._db);
  $$ClientsTableTableManager get clients =>
      $$ClientsTableTableManager(_db.attachedDatabase, _db.clients);
  $$LogementsTableTableManager get logements =>
      $$LogementsTableTableManager(_db.attachedDatabase, _db.logements);
  $$PrestatairesTableTableManager get prestataires =>
      $$PrestatairesTableTableManager(_db.attachedDatabase, _db.prestataires);
  $$InterventionsTableTableManager get interventions =>
      $$InterventionsTableTableManager(_db.attachedDatabase, _db.interventions);
  $$InspectionsTableTableManager get inspections =>
      $$InspectionsTableTableManager(_db.attachedDatabase, _db.inspections);
  $$PhotosTableTableManager get photos =>
      $$PhotosTableTableManager(_db.attachedDatabase, _db.photos);
}
