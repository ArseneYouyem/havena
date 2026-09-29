import 'package:havena/core/database/app_database.dart';

/// Génère les références uniques HAVENA au format `HAV-XXX-000001`
/// (cahier des charges §4). Basé sur le nombre de lignes déjà présentes
/// dans la table (y compris les lignes soft-deleted, pour ne jamais
/// réutiliser un numéro).
class ReferenceGeneratorService {
  ReferenceGeneratorService(this._db);

  final AppDatabase _db;

  Future<String> nextClientReference() =>
      _next('CLI', _db.clientsDao.countAll);

  Future<String> nextLogementReference() =>
      _next('DLA', _db.logementsDao.countAll);

  Future<String> nextAbonnementReference() =>
      _next('ABO', _db.abonnementsDao.countAll);

  Future<String> nextPrestataireReference() =>
      _next('PRE', _db.prestatairesDao.countAll);

  Future<String> nextInspectionReference() =>
      _next('INS', _db.inspectionsDao.countAll);

  Future<String> nextInterventionReference() =>
      _next('INT', _db.interventionsDao.countAll);

  Future<String> nextFinanceReference() =>
      _next('FIN', _db.financesDao.countAll);

  Future<String> nextRapportReference() =>
      _next('RAP', _db.rapportsDao.countAll);

  Future<String> _next(String prefix, Future<int> Function() countAll) async {
    final count = await countAll();
    final sequence = (count + 1).toString().padLeft(6, '0');
    return 'HAV-$prefix-$sequence';
  }
}
