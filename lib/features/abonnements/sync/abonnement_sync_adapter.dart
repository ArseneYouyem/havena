import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/sync/entity_sync_adapter.dart';
import 'package:havena/features/abonnements/repositories/abonnements_repository.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';

/// Adaptateur de synchronisation Firestore pour les abonnements.
/// Traduit les clés étrangères obligatoires `clientId` et `logementId` en
/// `clientSyncId` et `logementSyncId` (UUID des parents) via des listes en
/// mémoire, actualisées à chaque appel d'`allLocal()`.
class AbonnementSyncAdapter implements EntitySyncAdapter<Abonnement> {
  AbonnementSyncAdapter(
      this._repository, this._clientsRepository, this._logementsRepository);

  final AbonnementsRepository _repository;
  final ClientsRepository _clientsRepository;
  final LogementsRepository _logementsRepository;

  List<Client> _cachedClients = [];
  List<Logement> _cachedLogements = [];

  @override
  String get collectionName => 'abonnements';

  @override
  String syncIdOf(Abonnement row) => row.syncId!;

  @override
  DateTime updatedAtOf(Abonnement row) => row.updatedAt;

  @override
  Future<List<Abonnement>> allLocal() async {
    final abonnements = await _repository.watchAll().first;
    _cachedClients = await _clientsRepository.watchAll().first;
    _cachedLogements = await _logementsRepository.watchAll().first;
    return abonnements;
  }

  @override
  Map<String, dynamic> toFirestoreMap(Abonnement row) {
    String? clientSyncId;
    for (final client in _cachedClients) {
      if (client.id == row.clientId) {
        clientSyncId = client.syncId;
        break;
      }
    }

    String? logementSyncId;
    for (final logement in _cachedLogements) {
      if (logement.id == row.logementId) {
        logementSyncId = logement.syncId;
        break;
      }
    }

    return {
      'reference': row.reference,
      'clientSyncId': clientSyncId,
      'logementSyncId': logementSyncId,
      'formula': row.formula,
      'monthlyPrice': row.monthlyPrice,
      'startDate': row.startDate.toIso8601String(),
      'renewalDate': row.renewalDate?.toIso8601String(),
      'lastPaymentDate': row.lastPaymentDate?.toIso8601String(),
      'nextPaymentDate': row.nextPaymentDate?.toIso8601String(),
      'paymentStatus': row.paymentStatus.name,
      'lastInspectionDate': row.lastInspectionDate?.toIso8601String(),
      'nextInspectionDate': row.nextInspectionDate?.toIso8601String(),
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
