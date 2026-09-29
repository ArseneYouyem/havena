import 'package:drift/drift.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/daos/interventions_dao.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/references/reference_generator_service.dart';

class InterventionsRepository {
  InterventionsRepository(this._dao, this._referenceGenerator);

  final InterventionsDao _dao;
  final ReferenceGeneratorService _referenceGenerator;

  Stream<List<Intervention>> watchAll() => _dao.watchAll();

  Future<Intervention?> getById(int id) => _dao.getById(id);

  Future<int> create({
    required int logementId,
    required int clientId,
    required String problemDescription,
    String? category,
    required UrgencyLevel urgencyLevel,
    int? prestataireId,
    required String updatedBy,
  }) async {
    final reference = await _referenceGenerator.nextInterventionReference();

    return _dao.insertOne(InterventionsCompanion(
      reference: Value(reference),
      logementId: Value(logementId),
      clientId: Value(clientId),
      problemDescription: Value(problemDescription),
      category: Value(category),
      urgencyLevel: Value(urgencyLevel),
      prestataireId: Value(prestataireId),
      quoteAmount: const Value(null),
      clientValidated: const Value(false),
      interventionDate: const Value(null),
      clientAmount: const Value(null),
      prestataireAmount: const Value(null),
      havenaMargin: const Value(null),
      status: const Value(InterventionStatus.nouveau),
      clientSatisfaction: const Value(null),
      updatedAt: Value(DateTime.now()),
      updatedBy: Value(updatedBy),
      syncStatus: const Value(SyncStatus.local),
      isDeleted: const Value(false),
    ));
  }

  Future<void> _patch(
    int id,
    InterventionsCompanion Function(Intervention existing) build,
  ) async {
    final existing = await _dao.getById(id);
    if (existing == null) {
      throw Exception('Intervention introuvable');
    }
    await _dao.updateOne(build(existing));
  }

  Future<void> updateProblem({
    required int id,
    required String problemDescription,
    String? category,
    required UrgencyLevel urgencyLevel,
    required String updatedBy,
  }) async {
    await _patch(id, (existing) {
      return InterventionsCompanion(
        id: Value(existing.id),
        reference: Value(existing.reference),
        logementId: Value(existing.logementId),
        clientId: Value(existing.clientId),
        problemDescription: Value(problemDescription),
        category: Value(category),
        urgencyLevel: Value(urgencyLevel),
        prestataireId: Value(existing.prestataireId),
        quoteAmount: Value(existing.quoteAmount),
        clientValidated: Value(existing.clientValidated),
        interventionDate: Value(existing.interventionDate),
        clientAmount: Value(existing.clientAmount),
        prestataireAmount: Value(existing.prestataireAmount),
        havenaMargin: Value(existing.havenaMargin),
        status: Value(existing.status),
        clientSatisfaction: Value(existing.clientSatisfaction),
        updatedAt: Value(DateTime.now()),
        updatedBy: Value(updatedBy),
        syncStatus: Value(existing.syncStatus),
        isDeleted: Value(existing.isDeleted),
      );
    });
  }

  Future<void> updatePrestataire({
    required int id,
    int? prestataireId,
    required String updatedBy,
  }) async {
    await _patch(id, (existing) {
      return InterventionsCompanion(
        id: Value(existing.id),
        reference: Value(existing.reference),
        logementId: Value(existing.logementId),
        clientId: Value(existing.clientId),
        problemDescription: Value(existing.problemDescription),
        category: Value(existing.category),
        urgencyLevel: Value(existing.urgencyLevel),
        prestataireId: Value(prestataireId),
        quoteAmount: Value(existing.quoteAmount),
        clientValidated: Value(existing.clientValidated),
        interventionDate: Value(existing.interventionDate),
        clientAmount: Value(existing.clientAmount),
        prestataireAmount: Value(existing.prestataireAmount),
        havenaMargin: Value(existing.havenaMargin),
        status: Value(existing.status),
        clientSatisfaction: Value(existing.clientSatisfaction),
        updatedAt: Value(DateTime.now()),
        updatedBy: Value(updatedBy),
        syncStatus: Value(existing.syncStatus),
        isDeleted: Value(existing.isDeleted),
      );
    });
  }

  Future<void> updateQuote({
    required int id,
    double? quoteAmount,
    required bool clientValidated,
    required String updatedBy,
  }) async {
    await _patch(id, (existing) {
      return InterventionsCompanion(
        id: Value(existing.id),
        reference: Value(existing.reference),
        logementId: Value(existing.logementId),
        clientId: Value(existing.clientId),
        problemDescription: Value(existing.problemDescription),
        category: Value(existing.category),
        urgencyLevel: Value(existing.urgencyLevel),
        prestataireId: Value(existing.prestataireId),
        quoteAmount: Value(quoteAmount),
        clientValidated: Value(clientValidated),
        interventionDate: Value(existing.interventionDate),
        clientAmount: Value(existing.clientAmount),
        prestataireAmount: Value(existing.prestataireAmount),
        havenaMargin: Value(existing.havenaMargin),
        status: Value(existing.status),
        clientSatisfaction: Value(existing.clientSatisfaction),
        updatedAt: Value(DateTime.now()),
        updatedBy: Value(updatedBy),
        syncStatus: Value(existing.syncStatus),
        isDeleted: Value(existing.isDeleted),
      );
    });
  }

  Future<void> updatePlanning({
    required int id,
    DateTime? interventionDate,
    required String updatedBy,
  }) async {
    await _patch(id, (existing) {
      return InterventionsCompanion(
        id: Value(existing.id),
        reference: Value(existing.reference),
        logementId: Value(existing.logementId),
        clientId: Value(existing.clientId),
        problemDescription: Value(existing.problemDescription),
        category: Value(existing.category),
        urgencyLevel: Value(existing.urgencyLevel),
        prestataireId: Value(existing.prestataireId),
        quoteAmount: Value(existing.quoteAmount),
        clientValidated: Value(existing.clientValidated),
        interventionDate: Value(interventionDate),
        clientAmount: Value(existing.clientAmount),
        prestataireAmount: Value(existing.prestataireAmount),
        havenaMargin: Value(existing.havenaMargin),
        status: Value(existing.status),
        clientSatisfaction: Value(existing.clientSatisfaction),
        updatedAt: Value(DateTime.now()),
        updatedBy: Value(updatedBy),
        syncStatus: Value(existing.syncStatus),
        isDeleted: Value(existing.isDeleted),
      );
    });
  }

  Future<void> updateAmounts({
    required int id,
    double? clientAmount,
    double? prestataireAmount,
    required String updatedBy,
  }) async {
    await _patch(id, (existing) {
      double? havenaMargin;
      if (clientAmount != null && prestataireAmount != null) {
        havenaMargin = clientAmount - prestataireAmount;
      }

      return InterventionsCompanion(
        id: Value(existing.id),
        reference: Value(existing.reference),
        logementId: Value(existing.logementId),
        clientId: Value(existing.clientId),
        problemDescription: Value(existing.problemDescription),
        category: Value(existing.category),
        urgencyLevel: Value(existing.urgencyLevel),
        prestataireId: Value(existing.prestataireId),
        quoteAmount: Value(existing.quoteAmount),
        clientValidated: Value(existing.clientValidated),
        interventionDate: Value(existing.interventionDate),
        clientAmount: Value(clientAmount),
        prestataireAmount: Value(prestataireAmount),
        havenaMargin: Value(havenaMargin),
        status: Value(existing.status),
        clientSatisfaction: Value(existing.clientSatisfaction),
        updatedAt: Value(DateTime.now()),
        updatedBy: Value(updatedBy),
        syncStatus: Value(existing.syncStatus),
        isDeleted: Value(existing.isDeleted),
      );
    });
  }

  Future<void> updateStatus({
    required int id,
    required InterventionStatus status,
    required String updatedBy,
  }) async {
    await _patch(id, (existing) {
      return InterventionsCompanion(
        id: Value(existing.id),
        reference: Value(existing.reference),
        logementId: Value(existing.logementId),
        clientId: Value(existing.clientId),
        problemDescription: Value(existing.problemDescription),
        category: Value(existing.category),
        urgencyLevel: Value(existing.urgencyLevel),
        prestataireId: Value(existing.prestataireId),
        quoteAmount: Value(existing.quoteAmount),
        clientValidated: Value(existing.clientValidated),
        interventionDate: Value(existing.interventionDate),
        clientAmount: Value(existing.clientAmount),
        prestataireAmount: Value(existing.prestataireAmount),
        havenaMargin: Value(existing.havenaMargin),
        status: Value(status),
        clientSatisfaction: Value(existing.clientSatisfaction),
        updatedAt: Value(DateTime.now()),
        updatedBy: Value(updatedBy),
        syncStatus: Value(existing.syncStatus),
        isDeleted: Value(existing.isDeleted),
      );
    });
  }

  Future<void> updateSatisfaction({
    required int id,
    int? clientSatisfaction,
    required String updatedBy,
  }) async {
    await _patch(id, (existing) {
      return InterventionsCompanion(
        id: Value(existing.id),
        reference: Value(existing.reference),
        logementId: Value(existing.logementId),
        clientId: Value(existing.clientId),
        problemDescription: Value(existing.problemDescription),
        category: Value(existing.category),
        urgencyLevel: Value(existing.urgencyLevel),
        prestataireId: Value(existing.prestataireId),
        quoteAmount: Value(existing.quoteAmount),
        clientValidated: Value(existing.clientValidated),
        interventionDate: Value(existing.interventionDate),
        clientAmount: Value(existing.clientAmount),
        prestataireAmount: Value(existing.prestataireAmount),
        havenaMargin: Value(existing.havenaMargin),
        status: Value(existing.status),
        clientSatisfaction: Value(clientSatisfaction),
        updatedAt: Value(DateTime.now()),
        updatedBy: Value(updatedBy),
        syncStatus: Value(existing.syncStatus),
        isDeleted: Value(existing.isDeleted),
      );
    });
  }

  Future<void> delete(int id) => _dao.softDelete(id);
}
