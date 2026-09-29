// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'abonnements_dao.dart';

// ignore_for_file: type=lint
mixin _$AbonnementsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ClientsTable get clients => attachedDatabase.clients;
  $LogementsTable get logements => attachedDatabase.logements;
  $AbonnementsTable get abonnements => attachedDatabase.abonnements;
  AbonnementsDaoManager get managers => AbonnementsDaoManager(this);
}

class AbonnementsDaoManager {
  final _$AbonnementsDaoMixin _db;
  AbonnementsDaoManager(this._db);
  $$ClientsTableTableManager get clients =>
      $$ClientsTableTableManager(_db.attachedDatabase, _db.clients);
  $$LogementsTableTableManager get logements =>
      $$LogementsTableTableManager(_db.attachedDatabase, _db.logements);
  $$AbonnementsTableTableManager get abonnements =>
      $$AbonnementsTableTableManager(_db.attachedDatabase, _db.abonnements);
}
