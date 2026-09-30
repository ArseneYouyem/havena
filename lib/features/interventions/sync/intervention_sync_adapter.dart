import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/sync/entity_sync_adapter.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/interventions/repositories/interventions_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';
import 'package:havena/features/prestataires/repositories/prestataires_repository.dart';

/// Adaptateur de synchronisation Firestore pour les interventions.
/// Traduit les clés étrangères obligatoires `logementId`/`clientId` et la
/// clé nullable `prestataireId` en `logementSyncId`/`clientSyncId`/
/// `prestataireSyncId` (UUID des parents) via des listes en mémoire,
/// actualisées à chaque appel d'`allLocal()`.
class InterventionSyncAdapter implements EntitySyncAdapter<Intervention> {
  InterventionSyncAdapter(
    this._repository,
    this._clientsRepository,
    this._logementsRepository,
    this._prestatairesRepository,
  );

  final InterventionsRepository _repository;
  final ClientsRepository _clientsRepository;
  final LogementsRepository _logementsRepository;
  final PrestatairesRepository _prestatairesRepository;

  List<Client> _cachedClients = [];
  List<Logement> _cachedLogements = [];
  List<Prestataire> _cachedPrestataires = [];

  @override
  String get collectionName => 'interventions';

  @override
  String syncIdOf(Intervention row) => row.syncId!;

  @override
  DateTime updatedAtOf(Intervention row) => row.updatedAt;

  @override
  Future<List<Intervention>> allLocal() async {
    final interventions = await _repository.watchAll().first;
    _cachedClients = await _clientsRepository.watchAll().first;
    _cachedLogements = await _logementsRepository.watchAll().first;
    _cachedPrestataires = await _prestatairesRepository.watchAll().first;
    return interventions;
  }

  @override
  Map<String, dynamic> toFirestoreMap(Intervention row) {
    String? logementSyncId;
    for (final logement in _cachedLogements) {
      if (logement.id == row.logementId) {
        logementSyncId = logement.syncId;
        break;
      }
    }

    String? clientSyncId;
    for (final client in _cachedClients) {
      if (client.id == row.clientId) {
        clientSyncId = client.syncId;
        break;
      }
    }

    String? prestataireSyncId;
    if (row.prestataireId != null) {
      for (final prestataire in _cachedPrestataires) {
        if (prestataire.id == row.prestataireId) {
          prestataireSyncId = prestataire.syncId;
          break;
        }
      }
    }

    return {
      'reference': row.reference,
      'logementSyncId': logementSyncId,
      'clientSyncId': clientSyncId,
      'problemDescription': row.problemDescription,
      'category': row.category,
      'urgencyLevel': row.urgencyLevel.name,
      'prestataireSyncId': prestataireSyncId,
      'quoteAmount': row.quoteAmount,
      'clientValidated': row.clientValidated,
      'interventionDate': row.interventionDate?.toIso8601String(),
      'clientAmount': row.clientAmount,
      'prestataireAmount': row.prestataireAmount,
      'havenaMargin': row.havenaMargin,
      'status': row.status.name,
      'clientSatisfaction': row.clientSatisfaction,
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
