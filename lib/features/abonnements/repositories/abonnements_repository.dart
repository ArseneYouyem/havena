import 'package:drift/drift.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/daos/abonnements_dao.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';
import 'package:uuid/uuid.dart';

class AbonnementsRepository {
  AbonnementsRepository(this._dao, this._referenceGenerator,
      this._clientsRepository, this._logementsRepository);

  final AbonnementsDao _dao;
  final ReferenceGeneratorService _referenceGenerator;
  final ClientsRepository _clientsRepository;
  final LogementsRepository _logementsRepository;

  Stream<List<Abonnement>> watchAll() => _dao.watchAll();

  Future<void> create({
    required int clientId,
    required int logementId,
    required String formula,
    required double monthlyPrice,
    required DateTime startDate,
    DateTime? renewalDate,
    DateTime? lastPaymentDate,
    DateTime? nextPaymentDate,
    required PaymentStatus paymentStatus,
    String? observations,
    required String updatedBy,
  }) async {
    final reference = await _referenceGenerator.nextAbonnementReference();
    await _dao.insertOne(AbonnementsCompanion(
      reference: Value(reference),
      syncId: Value(const Uuid().v4()),
      clientId: Value(clientId),
      logementId: Value(logementId),
      formula: Value(formula),
      monthlyPrice: Value(monthlyPrice),
      startDate: Value(startDate),
      renewalDate: Value(renewalDate),
      lastPaymentDate: Value(lastPaymentDate),
      nextPaymentDate: Value(nextPaymentDate),
      paymentStatus: Value(paymentStatus),
      observations: Value(observations),
      updatedAt: Value(DateTime.now()),
      updatedBy: Value(updatedBy),
    ));
  }

  Future<void> update({
    required int id,
    required int clientId,
    required int logementId,
    required String formula,
    required double monthlyPrice,
    required DateTime startDate,
    DateTime? renewalDate,
    DateTime? lastPaymentDate,
    DateTime? nextPaymentDate,
    required PaymentStatus paymentStatus,
    String? observations,
    required String updatedBy,
  }) async {
    final existing = await _dao.getById(id);
    if (existing == null) {
      throw Exception('Abonnement introuvable');
    }
    await _dao.updateOne(AbonnementsCompanion(
      id: Value(id),
      reference: Value(existing.reference),
      clientId: Value(clientId),
      logementId: Value(logementId),
      formula: Value(formula),
      monthlyPrice: Value(monthlyPrice),
      startDate: Value(startDate),
      renewalDate: Value(renewalDate),
      lastPaymentDate: Value(lastPaymentDate),
      nextPaymentDate: Value(nextPaymentDate),
      lastInspectionDate: Value(existing.lastInspectionDate),
      nextInspectionDate: Value(existing.nextInspectionDate),
      paymentStatus: Value(paymentStatus),
      observations: Value(observations),
      updatedAt: Value(DateTime.now()),
      updatedBy: Value(updatedBy),
    ));
  }

  Future<void> delete(int id) => _dao.softDelete(id);

  Future<Abonnement?> findBySyncId(String syncId) async {
    final all = await _dao.watchAll().first;
    for (final abonnement in all) {
      if (abonnement.syncId == syncId) return abonnement;
    }
    return null;
  }

  /// Crée ou met à jour la ligne locale correspondant à [syncId] à partir
  /// d'un document Firestore générique. Traduit `clientSyncId` et
  /// `logementSyncId` en `clientId` et `logementId` locaux. Les deux clés
  /// sont obligatoires : si l'un des parents n'existe pas encore localement,
  /// on abandonne silencieusement (retenté à la prochaine synchronisation).
  Future<void> upsertFromRemote({
    required String syncId,
    required Map<String, dynamic> data,
  }) async {
    final clientSyncId = data['clientSyncId'] as String?;
    final logementSyncId = data['logementSyncId'] as String?;

    if (clientSyncId == null || logementSyncId == null) {
      return;
    }

    final client = await _clientsRepository.findBySyncId(clientSyncId);
    if (client == null) {
      return;
    }

    final logement = await _logementsRepository.findBySyncId(logementSyncId);
    if (logement == null) {
      return;
    }

    final existing = await findBySyncId(syncId);

    final companion = AbonnementsCompanion(
      id: existing != null ? Value(existing.id) : const Value.absent(),
      syncId: Value(syncId),
      reference: Value(data['reference'] as String),
      clientId: Value(client.id),
      logementId: Value(logement.id),
      formula: Value(data['formula'] as String),
      monthlyPrice: Value((data['monthlyPrice'] as num).toDouble()),
      startDate: Value(DateTime.parse(data['startDate'] as String)),
      renewalDate: Value(_parseDate(data['renewalDate'])),
      lastPaymentDate: Value(_parseDate(data['lastPaymentDate'])),
      nextPaymentDate: Value(_parseDate(data['nextPaymentDate'])),
      paymentStatus:
          Value(PaymentStatus.values.byName(data['paymentStatus'] as String)),
      lastInspectionDate: Value(_parseDate(data['lastInspectionDate'])),
      nextInspectionDate: Value(_parseDate(data['nextInspectionDate'])),
      observations: Value(data['observations'] as String?),
      updatedAt: Value(DateTime.parse(data['updatedAt'] as String)),
      updatedBy: Value(data['updatedBy'] as String?),
      isDeleted: Value(data['isDeleted'] as bool? ?? false),
      syncStatus: const Value(SyncStatus.synced),
    );

    if (existing != null) {
      await _dao.updateOne(companion);
    } else {
      await _dao.insertOne(companion);
    }
  }

  DateTime? _parseDate(Object? value) {
    if (value == null) return null;
    return DateTime.parse(value as String);
  }
}
