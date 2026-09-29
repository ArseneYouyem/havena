import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/sync/entity_sync_adapter.dart';
import 'package:havena/features/calendrier/repositories/calendrier_repository.dart';

class CalendrierSyncAdapter implements EntitySyncAdapter<CalendrierEvenement> {
  CalendrierSyncAdapter(this._repository);

  final CalendrierRepository _repository;

  @override
  String get collectionName => 'calendrier_evenements';

  @override
  String syncIdOf(CalendrierEvenement row) => row.syncId!;

  @override
  DateTime updatedAtOf(CalendrierEvenement row) => row.updatedAt;

  @override
  Future<List<CalendrierEvenement>> allLocal() => _repository.watchAll().first;

  @override
  Map<String, dynamic> toFirestoreMap(CalendrierEvenement row) => {
        'eventType': row.eventType.name,
        'title': row.title,
        'eventDate': row.eventDate.toIso8601String(),
        'relatedReference': row.relatedReference,
        'responsibleUserId': row.responsibleUserId,
        'status': row.status.name,
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
