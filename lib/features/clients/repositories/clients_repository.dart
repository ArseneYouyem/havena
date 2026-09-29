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

  Future<Client?> findBySyncId(String syncId) async {
    final all = await _dao.watchAll().first;
    for (final client in all) {
      if (client.syncId == syncId) return client;
    }
    return null;
  }

  /// Crée ou met à jour la ligne locale correspondant à [syncId] à partir
  /// d'un document Firestore générique (`ClientSyncAdapter.toFirestoreMap`
  /// pour le format exact). Utilisé uniquement par `SyncEngine` (pull et
  /// résolution de conflit) — jamais par l'UI.
  Future<void> upsertFromRemote({
    required String syncId,
    required Map<String, dynamic> data,
  }) async {
    final existing = await findBySyncId(syncId);
    final companion = ClientsCompanion(
      id: existing != null ? Value(existing.id) : const Value.absent(),
      syncId: Value(syncId),
      reference: Value(data['reference'] as String),
      fullName: Value(data['fullName'] as String),
      phone: Value(data['phone'] as String),
      whatsapp: Value(data['whatsapp'] as String?),
      email: Value(data['email'] as String?),
      country: Value(data['country'] as String),
      city: Value(data['city'] as String),
      clientType: Value(data['clientType'] as String),
      logementReference: Value(data['logementReference'] as String?),
      subscriptionFormula: Value(data['subscriptionFormula'] as String?),
      startDate: Value(_parseDate(data['startDate'])),
      renewalDate: Value(_parseDate(data['renewalDate'])),
      status: Value(ClientStatus.values.byName(data['status'] as String)),
      lastContactDate: Value(_parseDate(data['lastContactDate'])),
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
