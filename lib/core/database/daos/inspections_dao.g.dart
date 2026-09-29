// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspections_dao.dart';

// ignore_for_file: type=lint
mixin _$InspectionsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ClientsTable get clients => attachedDatabase.clients;
  $LogementsTable get logements => attachedDatabase.logements;
  $InspectionsTable get inspections => attachedDatabase.inspections;
  InspectionsDaoManager get managers => InspectionsDaoManager(this);
}

class InspectionsDaoManager {
  final _$InspectionsDaoMixin _db;
  InspectionsDaoManager(this._db);
  $$ClientsTableTableManager get clients =>
      $$ClientsTableTableManager(_db.attachedDatabase, _db.clients);
  $$LogementsTableTableManager get logements =>
      $$LogementsTableTableManager(_db.attachedDatabase, _db.logements);
  $$InspectionsTableTableManager get inspections =>
      $$InspectionsTableTableManager(_db.attachedDatabase, _db.inspections);
}
