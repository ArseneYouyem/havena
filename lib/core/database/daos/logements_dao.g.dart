// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logements_dao.dart';

// ignore_for_file: type=lint
mixin _$LogementsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ClientsTable get clients => attachedDatabase.clients;
  $LogementsTable get logements => attachedDatabase.logements;
  LogementsDaoManager get managers => LogementsDaoManager(this);
}

class LogementsDaoManager {
  final _$LogementsDaoMixin _db;
  LogementsDaoManager(this._db);
  $$ClientsTableTableManager get clients =>
      $$ClientsTableTableManager(_db.attachedDatabase, _db.clients);
  $$LogementsTableTableManager get logements =>
      $$LogementsTableTableManager(_db.attachedDatabase, _db.logements);
}
