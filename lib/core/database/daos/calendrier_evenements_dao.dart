import 'package:drift/drift.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/tables/calendrier_evenements_table.dart';

part 'calendrier_evenements_dao.g.dart';

@DriftAccessor(tables: [CalendrierEvenements])
class CalendrierEvenementsDao extends DatabaseAccessor<AppDatabase>
    with _$CalendrierEvenementsDaoMixin {
  CalendrierEvenementsDao(super.db);

  Stream<List<CalendrierEvenement>> watchAll() =>
      (select(calendrierEvenements)..where((t) => t.isDeleted.equals(false)))
          .watch();

  Future<CalendrierEvenement?> getById(int id) => (select(calendrierEvenements)
        ..where((t) => t.id.equals(id)))
      .getSingleOrNull();

  Future<int> insertOne(CalendrierEvenementsCompanion companion) =>
      into(calendrierEvenements).insert(companion);

  Future<bool> updateOne(CalendrierEvenementsCompanion companion) =>
      update(calendrierEvenements).replace(companion);

  /// Mise à jour partielle (seuls les champs présents dans [companion] sont
  /// modifiés) — contrairement à [updateOne] (`.replace()`), qui exige que
  /// toutes les colonnes obligatoires (`title`, `eventDate`) soient
  /// fournies, même pour ne changer qu'un seul champ technique comme
  /// `googleEventId` (voir `CalendrierRepository.markGoogleSynced`).
  Future<int> updatePartial(
    int id,
    CalendrierEvenementsCompanion companion,
  ) =>
      (update(calendrierEvenements)..where((t) => t.id.equals(id)))
          .write(companion);

  Future<int> softDelete(int id) => (update(calendrierEvenements)
        ..where((t) => t.id.equals(id)))
      .write(const CalendrierEvenementsCompanion(isDeleted: Value(true)));
}
