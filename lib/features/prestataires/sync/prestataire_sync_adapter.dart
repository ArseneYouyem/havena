import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/sync/entity_sync_adapter.dart';
import 'package:havena/features/prestataires/repositories/prestataires_repository.dart';

class PrestataireSyncAdapter implements EntitySyncAdapter<Prestataire> {
  PrestataireSyncAdapter(this._repository);

  final PrestatairesRepository _repository;

  @override
  String get collectionName => 'prestataires';

  @override
  String syncIdOf(Prestataire row) => row.syncId!;

  @override
  DateTime updatedAtOf(Prestataire row) => row.updatedAt;

  @override
  Future<List<Prestataire>> allLocal() => _repository.watchAll().first;

  @override
  Map<String, dynamic> toFirestoreMap(Prestataire row) => {
        'reference': row.reference,
        'fullName': row.fullName,
        'phone': row.phone,
        'specialty': row.specialty,
        'zone': row.zone,
        'experienceYears': row.experienceYears,
        'identityVerified': row.identityVerified,
        'referencesVerified': row.referencesVerified,
        'indicativeRate': row.indicativeRate,
        'qualityRating': row.qualityRating,
        'punctualityRating': row.punctualityRating,
        'communicationRating': row.communicationRating,
        'status': row.status.name,
        'interventionsCount': row.interventionsCount,
        'lastInterventionDate': row.lastInterventionDate?.toIso8601String(),
        'observations': row.observations,
        'updatedAt': row.updatedAt.toIso8601String(),
        'updatedBy': row.updatedBy,
        'isDeleted': row.isDeleted,
      };

  @override
  Future<void> upsertLocal(
    Map<String, dynamic> data, {
    required String syncId,
  }) {
    return _repository.upsertFromRemote(syncId: syncId, data: data);
  }
}
