import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/sync/entity_sync_adapter.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/finances/repositories/finances_repository.dart';
import 'package:havena/features/prestataires/repositories/prestataires_repository.dart';

/// Adaptateur de synchronisation Firestore pour les finances.
/// Traduit les clés étrangères nullables `relatedClientId` et
/// `relatedPrestataireId` en `relatedClientSyncId` et
/// `relatedPrestataireSyncId` (UUID des parents) via des listes en mémoire,
/// actualisées à chaque appel d'`allLocal()`.
class FinanceSyncAdapter implements EntitySyncAdapter<Finance> {
  FinanceSyncAdapter(this._repository, this._clientsRepository,
      this._prestatairesRepository);

  final FinancesRepository _repository;
  final ClientsRepository _clientsRepository;
  final PrestatairesRepository _prestatairesRepository;

  List<Client> _cachedClients = [];
  List<Prestataire> _cachedPrestataires = [];

  @override
  String get collectionName => 'finances';

  @override
  String syncIdOf(Finance row) => row.syncId!;

  @override
  DateTime updatedAtOf(Finance row) => row.updatedAt;

  @override
  Future<List<Finance>> allLocal() async {
    final finances = await _repository.watchAll().first;
    _cachedClients = await _clientsRepository.watchAll().first;
    _cachedPrestataires = await _prestatairesRepository.watchAll().first;
    return finances;
  }

  @override
  Map<String, dynamic> toFirestoreMap(Finance row) {
    String? relatedClientSyncId;
    if (row.relatedClientId != null) {
      for (final client in _cachedClients) {
        if (client.id == row.relatedClientId) {
          relatedClientSyncId = client.syncId;
          break;
        }
      }
    }

    String? relatedPrestataireSyncId;
    if (row.relatedPrestataireId != null) {
      for (final prestataire in _cachedPrestataires) {
        if (prestataire.id == row.relatedPrestataireId) {
          relatedPrestataireSyncId = prestataire.syncId;
          break;
        }
      }
    }

    return {
      'reference': row.reference,
      'relatedClientSyncId': relatedClientSyncId,
      'relatedPrestataireSyncId': relatedPrestataireSyncId,
      'transactionDate': row.transactionDate.toIso8601String(),
      'transactionType': row.transactionType.name,
      'description': row.description,
      'amount': row.amount,
      'paymentMethod': row.paymentMethod,
      'status': row.status.name,
      'periodMonth': row.periodMonth,
      'observations': row.observations,
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
