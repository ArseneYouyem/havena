// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interventions_dao.dart';

// ignore_for_file: type=lint
mixin _$InterventionsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ClientsTable get clients => attachedDatabase.clients;
  $LogementsTable get logements => attachedDatabase.logements;
  $PrestatairesTable get prestataires => attachedDatabase.prestataires;
  $InterventionsTable get interventions => attachedDatabase.interventions;
  InterventionsDaoManager get managers => InterventionsDaoManager(this);
}

class InterventionsDaoManager {
  final _$InterventionsDaoMixin _db;
  InterventionsDaoManager(this._db);
  $$ClientsTableTableManager get clients =>
      $$ClientsTableTableManager(_db.attachedDatabase, _db.clients);
  $$LogementsTableTableManager get logements =>
      $$LogementsTableTableManager(_db.attachedDatabase, _db.logements);
  $$PrestatairesTableTableManager get prestataires =>
      $$PrestatairesTableTableManager(_db.attachedDatabase, _db.prestataires);
  $$InterventionsTableTableManager get interventions =>
      $$InterventionsTableTableManager(_db.attachedDatabase, _db.interventions);
}
