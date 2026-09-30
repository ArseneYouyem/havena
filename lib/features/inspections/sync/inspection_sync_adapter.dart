import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/sync/entity_sync_adapter.dart';
import 'package:havena/features/inspections/repositories/inspections_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';

/// Adaptateur de synchronisation Firestore pour les inspections.
/// Traduit la clé étrangère obligatoire `logementId` en `logementSyncId`
/// (UUID du logement) via une liste en mémoire, actualisée à chaque appel
/// d'`allLocal()`. `agentUserId` n'est PAS traduit (pas de table Users
/// locale pour l'instant) : transmis tel quel comme entier brut.
class InspectionSyncAdapter implements EntitySyncAdapter<Inspection> {
  InspectionSyncAdapter(this._repository, this._logementsRepository);

  final InspectionsRepository _repository;
  final LogementsRepository _logementsRepository;
  List<Logement> _cachedLogements = [];

  @override
  String get collectionName => 'inspections';

  @override
  String syncIdOf(Inspection row) => row.syncId!;

  @override
  DateTime updatedAtOf(Inspection row) => row.updatedAt;

  @override
  Future<List<Inspection>> allLocal() async {
    final inspections = await _repository.watchAll().first;
    _cachedLogements = await _logementsRepository.watchAll().first;
    return inspections;
  }

  @override
  Map<String, dynamic> toFirestoreMap(Inspection row) {
    String? logementSyncId;
    for (final logement in _cachedLogements) {
      if (logement.id == row.logementId) {
        logementSyncId = logement.syncId;
        break;
      }
    }

    return {
      'reference': row.reference,
      'logementSyncId': logementSyncId,
      'agentUserId': row.agentUserId,
      'inspectionDate': row.inspectionDate.toIso8601String(),
      'generalCondition': row.generalCondition?.name,
      'recommendations': row.recommendations,
      'isValidated': row.isValidated,
      'validatedAt': row.validatedAt?.toIso8601String(),
      'updatedAt': row.updatedAt.toIso8601String(),
      'updatedBy': row.updatedBy,
      'isDeleted': row.isDeleted,
    };
  }

  @override
  Future<void> upsertLocal(
    Map<String, dynamic> data, {
    required String syncId,
  }) {
    return _repository.upsertFromRemote(syncId: syncId, data: data);
  }
}
