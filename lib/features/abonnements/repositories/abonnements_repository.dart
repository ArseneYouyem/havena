import 'package:drift/drift.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/daos/abonnements_dao.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/references/reference_generator_service.dart';

class AbonnementsRepository {
  AbonnementsRepository(this._dao, this._referenceGenerator);

  final AbonnementsDao _dao;
  final ReferenceGeneratorService _referenceGenerator;

  Stream<List<Abonnement>> watchAll() => _dao.watchAll();

  Future<void> create({
    required int clientId,
    required int logementId,
    required String formula,
    required double monthlyPrice,
    required DateTime startDate,
    DateTime? renewalDate,
    DateTime? lastPaymentDate,
    DateTime? nextPaymentDate,
    required PaymentStatus paymentStatus,
    String? observations,
    required String updatedBy,
  }) async {
    final reference = await _referenceGenerator.nextAbonnementReference();
    await _dao.insertOne(AbonnementsCompanion(
      reference: Value(reference),
      clientId: Value(clientId),
      logementId: Value(logementId),
      formula: Value(formula),
      monthlyPrice: Value(monthlyPrice),
      startDate: Value(startDate),
      renewalDate: Value(renewalDate),
      lastPaymentDate: Value(lastPaymentDate),
      nextPaymentDate: Value(nextPaymentDate),
      paymentStatus: Value(paymentStatus),
      observations: Value(observations),
      updatedAt: Value(DateTime.now()),
      updatedBy: Value(updatedBy),
    ));
  }

  Future<void> update({
    required int id,
    required int clientId,
    required int logementId,
    required String formula,
    required double monthlyPrice,
    required DateTime startDate,
    DateTime? renewalDate,
    DateTime? lastPaymentDate,
    DateTime? nextPaymentDate,
    required PaymentStatus paymentStatus,
    String? observations,
    required String updatedBy,
  }) async {
    final existing = await _dao.getById(id);
    if (existing == null) {
      throw Exception('Abonnement introuvable');
    }
    await _dao.updateOne(AbonnementsCompanion(
      id: Value(id),
      reference: Value(existing.reference),
      clientId: Value(clientId),
      logementId: Value(logementId),
      formula: Value(formula),
      monthlyPrice: Value(monthlyPrice),
      startDate: Value(startDate),
      renewalDate: Value(renewalDate),
      lastPaymentDate: Value(lastPaymentDate),
      nextPaymentDate: Value(nextPaymentDate),
      lastInspectionDate: Value(existing.lastInspectionDate),
      nextInspectionDate: Value(existing.nextInspectionDate),
      paymentStatus: Value(paymentStatus),
      observations: Value(observations),
      updatedAt: Value(DateTime.now()),
      updatedBy: Value(updatedBy),
    ));
  }

  Future<void> delete(int id) => _dao.softDelete(id);
}
