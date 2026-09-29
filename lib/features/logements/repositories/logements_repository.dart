import 'package:drift/drift.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/daos/logements_dao.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/references/reference_generator_service.dart';

class LogementsRepository {
  LogementsRepository(this._dao, this._referenceGenerator);

  final LogementsDao _dao;
  final ReferenceGeneratorService _referenceGenerator;

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
}
