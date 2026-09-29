import 'package:drift/drift.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/daos/prestataires_dao.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/references/reference_generator_service.dart';

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
}
