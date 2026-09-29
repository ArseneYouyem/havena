import 'package:drift/drift.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/daos/prestataires_dao.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:uuid/uuid.dart';

class PrestatairesRepository {
  PrestatairesRepository(this._dao, this._referenceGenerator);

  final PrestatairesDao _dao;
  final ReferenceGeneratorService _referenceGenerator;

  Stream<List<Prestataire>> watchAll() => _dao.watchAll();

  Future<void> create({
    required String fullName,
    required String phone,
    required String specialty,
    String? zone,
    int? experienceYears,
    bool identityVerified = false,
    bool referencesVerified = false,
    double? indicativeRate,
    double? qualityRating,
    double? punctualityRating,
    double? communicationRating,
    required PrestataireStatus status,
    String? observations,
    required String updatedBy,
  }) async {
    final reference = await _referenceGenerator.nextPrestataireReference();
    await _dao.insertOne(PrestatairesCompanion(
      reference: Value(reference),
      syncId: Value(const Uuid().v4()),
      fullName: Value(fullName),
      phone: Value(phone),
      specialty: Value(specialty),
      zone: Value(zone),
      experienceYears: Value(experienceYears),
      identityVerified: Value(identityVerified),
      referencesVerified: Value(referencesVerified),
      indicativeRate: Value(indicativeRate),
      qualityRating: Value(qualityRating),
      punctualityRating: Value(punctualityRating),
      communicationRating: Value(communicationRating),
      status: Value(status),
      interventionsCount: const Value(0),
      lastInterventionDate: const Value(null),
      observations: Value(observations),
      updatedAt: Value(DateTime.now()),
      updatedBy: Value(updatedBy),
    ));
  }

  Future<void> update({
    required int id,
    required String fullName,
    required String phone,
    required String specialty,
    String? zone,
    int? experienceYears,
    required bool identityVerified,
    required bool referencesVerified,
    double? indicativeRate,
    double? qualityRating,
    double? punctualityRating,
    double? communicationRating,
    required PrestataireStatus status,
    String? observations,
    required String updatedBy,
  }) async {
    final existing = await _dao.getById(id);
    if (existing == null) {
      throw Exception('Prestataire introuvable');
    }
    await _dao.updateOne(PrestatairesCompanion(
      id: Value(id),
      reference: Value(existing.reference),
      fullName: Value(fullName),
      phone: Value(phone),
      specialty: Value(specialty),
      zone: Value(zone),
      experienceYears: Value(experienceYears),
      identityVerified: Value(identityVerified),
      referencesVerified: Value(referencesVerified),
      indicativeRate: Value(indicativeRate),
      qualityRating: Value(qualityRating),
      punctualityRating: Value(punctualityRating),
      communicationRating: Value(communicationRating),
      status: Value(status),
      interventionsCount: Value(existing.interventionsCount),
      lastInterventionDate: Value(existing.lastInterventionDate),
      observations: Value(observations),
      updatedAt: Value(DateTime.now()),
      updatedBy: Value(updatedBy),
    ));
  }

  Future<void> delete(int id) => _dao.softDelete(id);

  Future<Prestataire?> findBySyncId(String syncId) async {
    final all = await _dao.watchAll().first;
    for (final prestataire in all) {
      if (prestataire.syncId == syncId) return prestataire;
    }
    return null;
  }

  /// Crée ou met à jour la ligne locale correspondant à [syncId] à partir
  /// d'un document Firestore générique (`PrestataireSyncAdapter.toFirestoreMap`
  /// pour le format exact). Utilisé uniquement par `SyncEngine` (pull et
  /// résolution de conflit) — jamais par l'UI.
  Future<void> upsertFromRemote({
    required String syncId,
    required Map<String, dynamic> data,
  }) async {
    final existing = await findBySyncId(syncId);
    final companion = PrestatairesCompanion(
      id: existing != null ? Value(existing.id) : const Value.absent(),
      syncId: Value(syncId),
      reference: Value(data['reference'] as String),
      fullName: Value(data['fullName'] as String),
      phone: Value(data['phone'] as String),
      specialty: Value(data['specialty'] as String),
      zone: Value(data['zone'] as String?),
      experienceYears: Value(data['experienceYears'] as int?),
      identityVerified: Value(data['identityVerified'] as bool? ?? false),
      referencesVerified: Value(data['referencesVerified'] as bool? ?? false),
      indicativeRate: Value(data['indicativeRate'] as double?),
      qualityRating: Value(data['qualityRating'] as double?),
      punctualityRating: Value(data['punctualityRating'] as double?),
      communicationRating: Value(data['communicationRating'] as double?),
      status: Value(PrestataireStatus.values.byName(data['status'] as String)),
      interventionsCount: Value(data['interventionsCount'] as int? ?? 0),
      lastInterventionDate: Value(_parseDate(data['lastInterventionDate'])),
      observations: Value(data['observations'] as String?),
      updatedAt: Value(DateTime.parse(data['updatedAt'] as String)),
      updatedBy: Value(data['updatedBy'] as String?),
      isDeleted: Value(data['isDeleted'] as bool? ?? false),
      syncStatus: const Value(SyncStatus.synced),
    );
    if (existing != null) {
      await _dao.updateOne(companion);
    } else {
      await _dao.insertOne(companion);
    }
  }

  DateTime? _parseDate(Object? value) {
    if (value == null) return null;
    return DateTime.parse(value as String);
  }
}
