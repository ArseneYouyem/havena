import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/sync/entity_sync_adapter.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';

/// Premier adaptateur de synchronisation Firestore (entité de référence,
/// aucune clé étrangère à traduire — voir `EntitySyncAdapter`). Les autres
/// modules suivront ce même pattern une fois celui-ci validé.
class ClientSyncAdapter implements EntitySyncAdapter<Client> {
  ClientSyncAdapter(this._repository);

  final ClientsRepository _repository;

  @override
  String get collectionName => 'clients';

  @override
  String syncIdOf(Client row) => row.syncId!;

  @override
  DateTime updatedAtOf(Client row) => row.updatedAt;

  @override
  Future<List<Client>> allLocal() => _repository.watchAll().first;

  @override
  Map<String, dynamic> toFirestoreMap(Client row) => {
        'reference': row.reference,
        'fullName': row.fullName,
        'phone': row.phone,
        'whatsapp': row.whatsapp,
        'email': row.email,
        'country': row.country,
        'city': row.city,
        'clientType': row.clientType,
        'logementReference': row.logementReference,
        'subscriptionFormula': row.subscriptionFormula,
        'startDate': row.startDate?.toIso8601String(),
        'renewalDate': row.renewalDate?.toIso8601String(),
        'status': row.status.name,
        'lastContactDate': row.lastContactDate?.toIso8601String(),
        'notes': row.notes,
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
