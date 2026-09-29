import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/sync/entity_sync_adapter.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';

/// Adaptateur de synchronisation Firestore pour les logements.
/// Traduit la clé étrangère nullable `clientId` en `clientSyncId` (UUID du
/// client) via une liste en mémoire, actualisée à chaque appel d'`allLocal()`.
class LogementSyncAdapter implements EntitySyncAdapter<Logement> {
  LogementSyncAdapter(this._repository, this._clientsRepository);

  final LogementsRepository _repository;
  final ClientsRepository _clientsRepository;
  List<Client> _cachedClients = [];

  @override
  String get collectionName => 'logements';

  @override
  String syncIdOf(Logement row) => row.syncId!;

  @override
  DateTime updatedAtOf(Logement row) => row.updatedAt;

  @override
  Future<List<Logement>> allLocal() async {
    final logements = await _repository.watchAll().first;
    _cachedClients = await _clientsRepository.watchAll().first;
    return logements;
  }

  @override
  Map<String, dynamic> toFirestoreMap(Logement row) {
    String? clientSyncId;
    if (row.clientId != null) {
      for (final client in _cachedClients) {
        if (client.id == row.clientId) {
          clientSyncId = client.syncId;
          break;
        }
      }
    }

    return {
      'reference': row.reference,
      'clientSyncId': clientSyncId,
      'address': row.address,
      'neighborhood': row.neighborhood,
      'housingType': row.housingType,
      'bedroomsCount': row.bedroomsCount,
      'occupancy': row.occupancy,
      'localContact': row.localContact,
      'guardian': row.guardian,
      'keysCount': row.keysCount,
      'mainEquipment': row.mainEquipment,
      'lastInspectionDate': row.lastInspectionDate?.toIso8601String(),
      'nextInspectionDate': row.nextInspectionDate?.toIso8601String(),
      'generalCondition': row.generalCondition?.name,
      'notes': row.notes,
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
