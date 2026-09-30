import 'package:drift/drift.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/daos/finances_dao.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/prestataires/repositories/prestataires_repository.dart';
import 'package:uuid/uuid.dart';

class FinancesRepository {
  FinancesRepository(this._dao, this._referenceGenerator,
      this._clientsRepository, this._prestatairesRepository);

  final FinancesDao _dao;
  final ReferenceGeneratorService _referenceGenerator;
  final ClientsRepository _clientsRepository;
  final PrestatairesRepository _prestatairesRepository;

  Stream<List<Finance>> watchAll() => _dao.watchAll();

  Future<void> create({
    required DateTime transactionDate,
    required TransactionType transactionType,
    int? relatedClientId,
    int? relatedPrestataireId,
    required String description,
    required double amount,
    String? paymentMethod,
    required TransactionStatus status,
    required String periodMonth,
    String? observations,
    required String updatedBy,
  }) async {
    final reference = await _referenceGenerator.nextFinanceReference();
    await _dao.insertOne(FinancesCompanion(
      reference: Value(reference),
      syncId: Value(const Uuid().v4()),
      transactionDate: Value(transactionDate),
      transactionType: Value(transactionType),
      relatedClientId: Value(relatedClientId),
      relatedPrestataireId: Value(relatedPrestataireId),
      description: Value(description),
      amount: Value(amount),
      paymentMethod: Value(paymentMethod),
      status: Value(status),
      periodMonth: Value(periodMonth),
      observations: Value(observations),
      updatedAt: Value(DateTime.now()),
      updatedBy: Value(updatedBy),
    ));
  }

  Future<void> update({
    required int id,
    required DateTime transactionDate,
    required TransactionType transactionType,
    int? relatedClientId,
    int? relatedPrestataireId,
    required String description,
    required double amount,
    String? paymentMethod,
    required TransactionStatus status,
    required String periodMonth,
    String? observations,
    required String updatedBy,
  }) async {
    final existing = await _dao.getById(id);
    if (existing == null) {
      throw Exception('Transaction introuvable');
    }
    await _dao.updateOne(FinancesCompanion(
      id: Value(id),
      reference: Value(existing.reference),
      transactionDate: Value(transactionDate),
      transactionType: Value(transactionType),
      relatedClientId: Value(relatedClientId),
      relatedPrestataireId: Value(relatedPrestataireId),
      description: Value(description),
      amount: Value(amount),
      paymentMethod: Value(paymentMethod),
      status: Value(status),
      periodMonth: Value(periodMonth),
      observations: Value(observations),
      updatedAt: Value(DateTime.now()),
      updatedBy: Value(updatedBy),
    ));
  }

  Future<void> delete(int id) => _dao.softDelete(id);

  Future<Finance?> findBySyncId(String syncId) async {
    final all = await _dao.watchAll().first;
    for (final finance in all) {
      if (finance.syncId == syncId) return finance;
    }
    return null;
  }

  /// Crée ou met à jour la ligne locale correspondant à [syncId] à partir
  /// d'un document Firestore générique. Traduit `relatedClientSyncId` et
  /// `relatedPrestataireSyncId` en `relatedClientId` et
  /// `relatedPrestataireId` locaux. Les deux clés sont nullables et
  /// indépendantes : si un parent n'existe pas encore localement, seul ce
  /// champ est mis à `null`, sans bloquer l'enregistrement.
  Future<void> upsertFromRemote({
    required String syncId,
    required Map<String, dynamic> data,
  }) async {
    final relatedClientSyncId = data['relatedClientSyncId'] as String?;
    final relatedPrestataireSyncId =
        data['relatedPrestataireSyncId'] as String?;

    int? localRelatedClientId;
    if (relatedClientSyncId != null) {
      final client =
          await _clientsRepository.findBySyncId(relatedClientSyncId);
      if (client != null) {
        localRelatedClientId = client.id;
      }
    }

    int? localRelatedPrestataireId;
    if (relatedPrestataireSyncId != null) {
      final prestataire = await _prestatairesRepository
          .findBySyncId(relatedPrestataireSyncId);
      if (prestataire != null) {
        localRelatedPrestataireId = prestataire.id;
      }
    }

    final existing = await findBySyncId(syncId);

    final companion = FinancesCompanion(
      id: existing != null ? Value(existing.id) : const Value.absent(),
      syncId: Value(syncId),
      reference: Value(data['reference'] as String),
      transactionDate:
          Value(DateTime.parse(data['transactionDate'] as String)),
      transactionType: Value(
          TransactionType.values.byName(data['transactionType'] as String)),
      relatedClientId: Value(localRelatedClientId),
      relatedPrestataireId: Value(localRelatedPrestataireId),
      description: Value(data['description'] as String),
      amount: Value((data['amount'] as num).toDouble()),
      paymentMethod: Value(data['paymentMethod'] as String?),
      status:
          Value(TransactionStatus.values.byName(data['status'] as String)),
      periodMonth: Value(data['periodMonth'] as String),
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
}
