import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/sync/entity_sync_adapter.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';
import 'package:havena/features/rapports/repositories/rapports_repository.dart';

/// Adaptateur de synchronisation Firestore pour les rapports.
/// Traduit la clé étrangère obligatoire `logementId` en `logementSyncId`
/// (UUID du logement) via une liste en mémoire, actualisée à chaque appel
/// d'`allLocal()`.
class RapportSyncAdapter implements EntitySyncAdapter<Rapport> {
  RapportSyncAdapter(this._repository, this._logementsRepository);

  final RapportsRepository _repository;
  final LogementsRepository _logementsRepository;
  List<Logement> _cachedLogements = [];

  @override
  String get collectionName => 'rapports';

  @override
  String syncIdOf(Rapport row) => row.syncId!;

  @override
  DateTime updatedAtOf(Rapport row) => row.updatedAt;

  @override
  Future<List<Rapport>> allLocal() async {
    final rapports = await _repository.watchAll().first;
    _cachedLogements = await _logementsRepository.watchAll().first;
    return rapports;
  }

  @override
  Map<String, dynamic> toFirestoreMap(Rapport row) {
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
      'periodMonth': row.periodMonth,
      'generalCondition': row.generalCondition?.name,
      'inspectionDone': row.inspectionDone,
      'anomalies': row.anomalies,
      'interventionsDone': row.interventionsDone,
      'totalExpenses': row.totalExpenses,
      'recommendations': row.recommendations,
      'nextActions': row.nextActions,
      'pdfLocalPath': row.pdfLocalPath,
      'generatedAt': row.generatedAt?.toIso8601String(),
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
