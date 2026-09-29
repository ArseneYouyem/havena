import 'package:drift/drift.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/daos/finances_dao.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:uuid/uuid.dart';

class FinancesRepository {
  FinancesRepository(this._dao, this._referenceGenerator);

  final FinancesDao _dao;
  final ReferenceGeneratorService _referenceGenerator;

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
}
