// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finances_dao.dart';

// ignore_for_file: type=lint
mixin _$FinancesDaoMixin on DatabaseAccessor<AppDatabase> {
  $ClientsTable get clients => attachedDatabase.clients;
  $PrestatairesTable get prestataires => attachedDatabase.prestataires;
  $FinancesTable get finances => attachedDatabase.finances;
  FinancesDaoManager get managers => FinancesDaoManager(this);
}

class FinancesDaoManager {
  final _$FinancesDaoMixin _db;
  FinancesDaoManager(this._db);
  $$ClientsTableTableManager get clients =>
      $$ClientsTableTableManager(_db.attachedDatabase, _db.clients);
  $$PrestatairesTableTableManager get prestataires =>
      $$PrestatairesTableTableManager(_db.attachedDatabase, _db.prestataires);
  $$FinancesTableTableManager get finances =>
      $$FinancesTableTableManager(_db.attachedDatabase, _db.finances);
}
