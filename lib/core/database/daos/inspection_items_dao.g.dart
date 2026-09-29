// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_items_dao.dart';

// ignore_for_file: type=lint
mixin _$InspectionItemsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ClientsTable get clients => attachedDatabase.clients;
  $LogementsTable get logements => attachedDatabase.logements;
  $InspectionsTable get inspections => attachedDatabase.inspections;
  $InspectionItemsTable get inspectionItems => attachedDatabase.inspectionItems;
  InspectionItemsDaoManager get managers => InspectionItemsDaoManager(this);
}

class InspectionItemsDaoManager {
  final _$InspectionItemsDaoMixin _db;
  InspectionItemsDaoManager(this._db);
  $$ClientsTableTableManager get clients =>
      $$ClientsTableTableManager(_db.attachedDatabase, _db.clients);
  $$LogementsTableTableManager get logements =>
      $$LogementsTableTableManager(_db.attachedDatabase, _db.logements);
  $$InspectionsTableTableManager get inspections =>
      $$InspectionsTableTableManager(_db.attachedDatabase, _db.inspections);
  $$InspectionItemsTableTableManager get inspectionItems =>
      $$InspectionItemsTableTableManager(
        _db.attachedDatabase,
        _db.inspectionItems,
      );
}
