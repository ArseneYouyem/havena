import 'package:drift/drift.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/daos/rapports_dao.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';
import 'package:uuid/uuid.dart';

class RapportsRepository {
  RapportsRepository(
      this._dao, this._referenceGenerator, this._logementsRepository);

  final RapportsDao _dao;
  final ReferenceGeneratorService _referenceGenerator;
  final LogementsRepository _logementsRepository;

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

  Future<Rapport?> findBySyncId(String syncId) async {
    final all = await _dao.watchAll().first;
    for (final rapport in all) {
      if (rapport.syncId == syncId) return rapport;
    }
    return null;
  }

  /// Crée ou met à jour la ligne locale correspondant à [syncId] à partir
  /// d'un document Firestore générique. Traduit `logementSyncId` en
  /// `logementId` local. Si le logement parent correspondant n'existe pas
  /// encore localement, on abandonne silencieusement (retour immédiat sans
  /// insertion ni mise à jour, retenté à la prochaine synchronisation).
  Future<void> upsertFromRemote({
    required String syncId,
    required Map<String, dynamic> data,
  }) async {
    final logementSyncId = data['logementSyncId'] as String?;
    if (logementSyncId == null) {
      return;
    }
    final logement = await _logementsRepository.findBySyncId(logementSyncId);
    if (logement == null) {
      return;
    }

    final existing = await findBySyncId(syncId);
    final companion = RapportsCompanion(
      id: existing != null ? Value(existing.id) : const Value.absent(),
      syncId: Value(syncId),
      reference: Value(data['reference'] as String),
      logementId: Value(logement.id),
      periodMonth: Value(data['periodMonth'] as String),
      generalCondition: Value(data['generalCondition'] == null
          ? null
          : HousingCondition.values
              .byName(data['generalCondition'] as String)),
      inspectionDone: Value(data['inspectionDone'] as bool? ?? false),
      anomalies: Value(data['anomalies'] as String?),
      interventionsDone: Value(data['interventionsDone'] as String?),
      totalExpenses: Value((data['totalExpenses'] as num?)?.toDouble()),
      recommendations: Value(data['recommendations'] as String?),
      nextActions: Value(data['nextActions'] as String?),
      pdfLocalPath: Value(data['pdfLocalPath'] as String?),
      generatedAt: Value(_parseDate(data['generatedAt'])),
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
