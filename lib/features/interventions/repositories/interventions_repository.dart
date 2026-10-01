import 'package:drift/drift.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/daos/interventions_dao.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/inspections/repositories/inspections_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';
import 'package:havena/features/prestataires/repositories/prestataires_repository.dart';
import 'package:uuid/uuid.dart';

class InterventionsRepository {
  InterventionsRepository(
    this._dao,
    this._referenceGenerator,
    this._clientsRepository,
    this._logementsRepository,
    this._prestatairesRepository,
    this._inspectionsRepository,
  );

  final InterventionsDao _dao;
  final ReferenceGeneratorService _referenceGenerator;
  final ClientsRepository _clientsRepository;
  final LogementsRepository _logementsRepository;
  final PrestatairesRepository _prestatairesRepository;
  final InspectionsRepository _inspectionsRepository;

  Stream<List<Intervention>> watchAll() => _dao.watchAll();

  Future<Intervention?> getById(int id) => _dao.getById(id);

  Future<int> create({
    required int logementId,
    required int clientId,
    int? inspectionId,
    required String problemDescription,
    String? category,
    required UrgencyLevel urgencyLevel,
    int? prestataireId,
    required String updatedBy,
  }) async {
    final reference = await _referenceGenerator.nextInterventionReference();

    return _dao.insertOne(InterventionsCompanion(
      reference: Value(reference),
      syncId: Value(const Uuid().v4()),
      logementId: Value(logementId),
      clientId: Value(clientId),
      inspectionId: Value(inspectionId),
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
        inspectionId: Value(existing.inspectionId),
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
        inspectionId: Value(existing.inspectionId),
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
        inspectionId: Value(existing.inspectionId),
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
        inspectionId: Value(existing.inspectionId),
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
        inspectionId: Value(existing.inspectionId),
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
        inspectionId: Value(existing.inspectionId),
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
        inspectionId: Value(existing.inspectionId),
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

  Future<Intervention?> findBySyncId(String syncId) async {
    final all = await _dao.watchAll().first;
    for (final intervention in all) {
      if (intervention.syncId == syncId) return intervention;
    }
    return null;
  }

  /// Crée ou met à jour la ligne locale correspondant à [syncId] à partir
  /// d'un document Firestore générique. Traduit `logementSyncId` et
  /// `clientSyncId` (obligatoires : si l'un des deux parents est
  /// introuvable localement, abandonne silencieusement, retenté à la
  /// prochaine synchronisation) et `prestataireSyncId` (nullable et
  /// indépendant : parent introuvable -> `null` sans bloquer le reste).
  Future<void> upsertFromRemote({
    required String syncId,
    required Map<String, dynamic> data,
  }) async {
    final logementSyncId = data['logementSyncId'] as String?;
    final clientSyncId = data['clientSyncId'] as String?;
    if (logementSyncId == null || clientSyncId == null) {
      return;
    }

    final logement = await _logementsRepository.findBySyncId(logementSyncId);
    if (logement == null) {
      return;
    }
    final client = await _clientsRepository.findBySyncId(clientSyncId);
    if (client == null) {
      return;
    }

    int? localPrestataireId;
    final prestataireSyncId = data['prestataireSyncId'] as String?;
    if (prestataireSyncId != null) {
      final prestataire =
          await _prestatairesRepository.findBySyncId(prestataireSyncId);
      if (prestataire != null) {
        localPrestataireId = prestataire.id;
      }
    }

    int? localInspectionId;
    final inspectionSyncId = data['inspectionSyncId'] as String?;
    if (inspectionSyncId != null) {
      final inspection =
          await _inspectionsRepository.findBySyncId(inspectionSyncId);
      if (inspection != null) {
        localInspectionId = inspection.id;
      }
    }

    final existing = await findBySyncId(syncId);
    final companion = InterventionsCompanion(
      id: existing != null ? Value(existing.id) : const Value.absent(),
      syncId: Value(syncId),
      reference: Value(data['reference'] as String),
      logementId: Value(logement.id),
      clientId: Value(client.id),
      inspectionId: Value(localInspectionId),
      problemDescription: Value(data['problemDescription'] as String),
      category: Value(data['category'] as String?),
      urgencyLevel:
          Value(UrgencyLevel.values.byName(data['urgencyLevel'] as String)),
      prestataireId: Value(localPrestataireId),
      quoteAmount: Value((data['quoteAmount'] as num?)?.toDouble()),
      clientValidated: Value(data['clientValidated'] as bool? ?? false),
      interventionDate: Value(_parseDate(data['interventionDate'])),
      clientAmount: Value((data['clientAmount'] as num?)?.toDouble()),
      prestataireAmount: Value((data['prestataireAmount'] as num?)?.toDouble()),
      havenaMargin: Value((data['havenaMargin'] as num?)?.toDouble()),
      status: Value(InterventionStatus.values.byName(data['status'] as String)),
      clientSatisfaction: Value(data['clientSatisfaction'] as int?),
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
