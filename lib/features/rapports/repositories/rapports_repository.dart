import 'package:drift/drift.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/daos/rapports_dao.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:uuid/uuid.dart';

class RapportsRepository {
  RapportsRepository(this._dao, this._referenceGenerator);

  final RapportsDao _dao;
  final ReferenceGeneratorService _referenceGenerator;

  Stream<List<Rapport>> watchAll() => _dao.watchAll();

  Future<void> create({
    required int logementId,
    required String periodMonth,
    HousingCondition? generalCondition,
    required bool inspectionDone,
    String? anomalies,
    String? interventionsDone,
    double? totalExpenses,
    String? recommendations,
    String? nextActions,
    required String updatedBy,
  }) async {
    final reference = await _referenceGenerator.nextRapportReference();
    await _dao.insertOne(RapportsCompanion(
      reference: Value(reference),
      syncId: Value(const Uuid().v4()),
      logementId: Value(logementId),
      periodMonth: Value(periodMonth),
      generalCondition: Value(generalCondition),
      inspectionDone: Value(inspectionDone),
      anomalies: Value(anomalies),
      interventionsDone: Value(interventionsDone),
      totalExpenses: Value(totalExpenses),
      recommendations: Value(recommendations),
      nextActions: Value(nextActions),
      updatedAt: Value(DateTime.now()),
      updatedBy: Value(updatedBy),
    ));
  }

  Future<void> update({
    required int id,
    required int logementId,
    required String periodMonth,
    HousingCondition? generalCondition,
    required bool inspectionDone,
    String? anomalies,
    String? interventionsDone,
    double? totalExpenses,
    String? recommendations,
    String? nextActions,
    required String updatedBy,
  }) async {
    final existing = await _dao.getById(id);
    if (existing == null) {
      throw Exception('Rapport introuvable');
    }
    await _dao.updateOne(RapportsCompanion(
      id: Value(id),
      reference: Value(existing.reference),
      logementId: Value(logementId),
      periodMonth: Value(periodMonth),
      generalCondition: Value(generalCondition),
      inspectionDone: Value(inspectionDone),
      anomalies: Value(anomalies),
      interventionsDone: Value(interventionsDone),
      totalExpenses: Value(totalExpenses),
      recommendations: Value(recommendations),
      nextActions: Value(nextActions),
      pdfLocalPath: Value(existing.pdfLocalPath),
      generatedAt: Value(existing.generatedAt),
      updatedAt: Value(DateTime.now()),
      updatedBy: Value(updatedBy),
    ));
  }

  Future<void> updatePdfInfo({
    required int id,
    required String pdfLocalPath,
    required DateTime generatedAt,
  }) async {
    final existing = await _dao.getById(id);
    if (existing == null) {
      throw Exception('Rapport introuvable');
    }
    await _dao.updateOne(RapportsCompanion(
      id: Value(id),
      reference: Value(existing.reference),
      logementId: Value(existing.logementId),
      periodMonth: Value(existing.periodMonth),
      generalCondition: Value(existing.generalCondition),
      inspectionDone: Value(existing.inspectionDone),
      anomalies: Value(existing.anomalies),
      interventionsDone: Value(existing.interventionsDone),
      totalExpenses: Value(existing.totalExpenses),
      recommendations: Value(existing.recommendations),
      nextActions: Value(existing.nextActions),
      pdfLocalPath: Value(pdfLocalPath),
      generatedAt: Value(generatedAt),
      updatedAt: Value(DateTime.now()),
      updatedBy: Value(existing.updatedBy),
    ));
  }

  Future<void> delete(int id) => _dao.softDelete(id);
}
