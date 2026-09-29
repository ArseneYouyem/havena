// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendrier_evenements_dao.dart';

// ignore_for_file: type=lint
mixin _$CalendrierEvenementsDaoMixin on DatabaseAccessor<AppDatabase> {
  $CalendrierEvenementsTable get calendrierEvenements =>
      attachedDatabase.calendrierEvenements;
  CalendrierEvenementsDaoManager get managers =>
      CalendrierEvenementsDaoManager(this);
}

class CalendrierEvenementsDaoManager {
  final _$CalendrierEvenementsDaoMixin _db;
  CalendrierEvenementsDaoManager(this._db);
  $$CalendrierEvenementsTableTableManager get calendrierEvenements =>
      $$CalendrierEvenementsTableTableManager(
        _db.attachedDatabase,
        _db.calendrierEvenements,
      );
}
