// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rapports_dao.dart';

// ignore_for_file: type=lint
mixin _$RapportsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ClientsTable get clients => attachedDatabase.clients;
  $LogementsTable get logements => attachedDatabase.logements;
  $RapportsTable get rapports => attachedDatabase.rapports;
  RapportsDaoManager get managers => RapportsDaoManager(this);
}

class RapportsDaoManager {
  final _$RapportsDaoMixin _db;
  RapportsDaoManager(this._db);
  $$ClientsTableTableManager get clients =>
      $$ClientsTableTableManager(_db.attachedDatabase, _db.clients);
  $$LogementsTableTableManager get logements =>
      $$LogementsTableTableManager(_db.attachedDatabase, _db.logements);
  $$RapportsTableTableManager get rapports =>
      $$RapportsTableTableManager(_db.attachedDatabase, _db.rapports);
}
