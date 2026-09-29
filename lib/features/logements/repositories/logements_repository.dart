import 'package:drift/drift.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/daos/logements_dao.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:uuid/uuid.dart';

class LogementsRepository {
  LogementsRepository(
      this._dao, this._referenceGenerator, this._clientsRepository);

  final LogementsDao _dao;
  final ReferenceGeneratorService _referenceGenerator;
  final ClientsRepository _clientsRepository;

  Stream<List<Logement>> watchAll() => _dao.watchAll();

  Future<void> create({
    int? clientId,
    required String address,
    String? neighborhood,
    String? housingType,
    int? bedroomsCount,
    String? occupancy,
    String? localContact,
    String? guardian,
    int? keysCount,
    String? mainEquipment,
    HousingCondition? generalCondition,
    String? notes,
    required String updatedBy,
  }) async {
    final reference = await _referenceGenerator.nextLogementReference();
    await _dao.insertOne(LogementsCompanion(
      reference: Value(reference),
      syncId: Value(const Uuid().v4()),
      clientId: Value(clientId),
      address: Value(address),
      neighborhood: Value(neighborhood),
      housingType: Value(housingType),
      bedroomsCount: Value(bedroomsCount),
      occupancy: Value(occupancy),
      localContact: Value(localContact),
      guardian: Value(guardian),
      keysCount: Value(keysCount),
      mainEquipment: Value(mainEquipment),
      generalCondition: Value(generalCondition),
      notes: Value(notes),
      updatedAt: Value(DateTime.now()),
      updatedBy: Value(updatedBy),
    ));
  }

  Future<void> update({
    required int id,
    int? clientId,
    required String address,
    String? neighborhood,
    String? housingType,
    int? bedroomsCount,
    String? occupancy,
    String? localContact,
    String? guardian,
    int? keysCount,
    String? mainEquipment,
    HousingCondition? generalCondition,
    String? notes,
    required String updatedBy,
  }) async {
    final existing = await _dao.getById(id);
    if (existing == null) {
      throw Exception('Logement introuvable');
    }
    await _dao.updateOne(LogementsCompanion(
      id: Value(id),
      reference: Value(existing.reference),
      clientId: Value(clientId),
      address: Value(address),
      neighborhood: Value(neighborhood),
      housingType: Value(housingType),
      bedroomsCount: Value(bedroomsCount),
      occupancy: Value(occupancy),
      localContact: Value(localContact),
      guardian: Value(guardian),
      keysCount: Value(keysCount),
      mainEquipment: Value(mainEquipment),
      lastInspectionDate: Value(existing.lastInspectionDate),
      nextInspectionDate: Value(existing.nextInspectionDate),
      generalCondition: Value(generalCondition),
      notes: Value(notes),
      updatedAt: Value(DateTime.now()),
      updatedBy: Value(updatedBy),
    ));
  }

  Future<void> delete(int id) => _dao.softDelete(id);

  Future<Logement?> findBySyncId(String syncId) async {
    final all = await _dao.watchAll().first;
    for (final logement in all) {
      if (logement.syncId == syncId) return logement;
    }
    return null;
  }

  /// Crée ou met à jour la ligne locale correspondant à [syncId] à partir
  /// d'un document Firestore générique. Traduit `clientSyncId` (UUID du
  /// client) en `clientId` local. Si la clé étrangère est nulle ou que le
  /// client correspondant n'existe pas encore localement, `clientId` est mis
  /// à `null` (pas de blocage, clé nullable).
  Future<void> upsertFromRemote({
    required String syncId,
    required Map<String, dynamic> data,
  }) async {
    final existing = await findBySyncId(syncId);

    int? localClientId;
    final clientSyncId = data['clientSyncId'] as String?;
    if (clientSyncId != null) {
      final client = await _clientsRepository.findBySyncId(clientSyncId);
      if (client != null) {
        localClientId = client.id;
      }
    }

    final companion = LogementsCompanion(
      id: existing != null ? Value(existing.id) : const Value.absent(),
      syncId: Value(syncId),
      reference: Value(data['reference'] as String),
      clientId: Value(localClientId),
      address: Value(data['address'] as String),
      neighborhood: Value(data['neighborhood'] as String?),
      housingType: Value(data['housingType'] as String?),
      bedroomsCount: Value(data['bedroomsCount'] as int?),
      occupancy: Value(data['occupancy'] as String?),
      localContact: Value(data['localContact'] as String?),
      guardian: Value(data['guardian'] as String?),
      keysCount: Value(data['keysCount'] as int?),
      mainEquipment: Value(data['mainEquipment'] as String?),
      lastInspectionDate: Value(_parseDate(data['lastInspectionDate'])),
      nextInspectionDate: Value(_parseDate(data['nextInspectionDate'])),
      generalCondition: Value(data['generalCondition'] == null
          ? null
          : HousingCondition.values
              .byName(data['generalCondition'] as String)),
      notes: Value(data['notes'] as String?),
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
