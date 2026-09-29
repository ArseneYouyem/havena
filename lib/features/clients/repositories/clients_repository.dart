import 'package:drift/drift.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/daos/clients_dao.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:uuid/uuid.dart';

class ClientsRepository {
  ClientsRepository(this._dao, this._referenceGenerator);

  final ClientsDao _dao;
  final ReferenceGeneratorService _referenceGenerator;

  Stream<List<Client>> watchAll() => _dao.watchAll();

  Future<void> create({
    required String fullName,
    required String phone,
    String? whatsapp,
    String? email,
    required String country,
    required String city,
    required String clientType,
    String? logementReference,
    String? subscriptionFormula,
    DateTime? startDate,
    DateTime? renewalDate,
    required ClientStatus status,
    DateTime? lastContactDate,
    String? notes,
    required String updatedBy,
  }) async {
    final reference = await _referenceGenerator.nextClientReference();
    await _dao.insertOne(ClientsCompanion(
      reference: Value(reference),
      syncId: Value(const Uuid().v4()),
      fullName: Value(fullName),
      phone: Value(phone),
      whatsapp: Value(whatsapp),
      email: Value(email),
      country: Value(country),
      city: Value(city),
      clientType: Value(clientType),
      logementReference: Value(logementReference),
      subscriptionFormula: Value(subscriptionFormula),
      startDate: Value(startDate),
      renewalDate: Value(renewalDate),
      status: Value(status),
      lastContactDate: Value(lastContactDate),
      notes: Value(notes),
      updatedAt: Value(DateTime.now()),
      updatedBy: Value(updatedBy),
    ));
  }

  Future<void> update({
    required int id,
    required String fullName,
    required String phone,
    String? whatsapp,
    String? email,
    required String country,
    required String city,
    required String clientType,
    String? logementReference,
    String? subscriptionFormula,
    DateTime? startDate,
    DateTime? renewalDate,
    required ClientStatus status,
    DateTime? lastContactDate,
    String? notes,
    required String updatedBy,
  }) async {
    final existing = await _dao.getById(id);
    if (existing == null) {
      throw Exception('Client introuvable');
    }
    await _dao.updateOne(ClientsCompanion(
      id: Value(id),
      reference: Value(existing.reference),
      fullName: Value(fullName),
      phone: Value(phone),
      whatsapp: Value(whatsapp),
      email: Value(email),
      country: Value(country),
      city: Value(city),
      clientType: Value(clientType),
      logementReference: Value(logementReference),
      subscriptionFormula: Value(subscriptionFormula),
      startDate: Value(startDate),
      renewalDate: Value(renewalDate),
      status: Value(status),
      lastContactDate: Value(lastContactDate),
      notes: Value(notes),
      updatedAt: Value(DateTime.now()),
      updatedBy: Value(updatedBy),
    ));
  }

  Future<void> delete(int id) => _dao.softDelete(id);
}
