import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/features/abonnements/repositories/abonnements_repository.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';

void main() {
  late AppDatabase database;
  late ReferenceGeneratorService referenceGenerator;
  late ClientsRepository clientsRepository;
  late LogementsRepository logementsRepository;
  late AbonnementsRepository abonnementsRepository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    referenceGenerator = ReferenceGeneratorService(database);
    clientsRepository =
        ClientsRepository(database.clientsDao, referenceGenerator);
    logementsRepository =
        LogementsRepository(database.logementsDao, referenceGenerator);
    abonnementsRepository =
        AbonnementsRepository(database.abonnementsDao, referenceGenerator);
  });

  tearDown(() async {
    await database.close();
  });

  test('crée un abonnement lié à un client et un logement', () async {
    await clientsRepository.create(
      fullName: 'Client Abonné',
      phone: '+237600000000',
      country: 'Cameroun',
      city: 'Douala',
      clientType: 'particulier',
      status: ClientStatus.actif,
      updatedBy: 'test-uid',
    );
    final client = (await clientsRepository.watchAll().first).first;

    await logementsRepository.create(
      clientId: client.id,
      address: '5 avenue de la Paix',
      updatedBy: 'test-uid',
    );
    final logement = (await logementsRepository.watchAll().first).first;

    await abonnementsRepository.create(
      clientId: client.id,
      logementId: logement.id,
      formula: 'Standard',
      monthlyPrice: 25000,
      startDate: DateTime(2026, 1, 1),
      paymentStatus: PaymentStatus.aJour,
      updatedBy: 'test-uid',
    );

    final abonnements = await abonnementsRepository.watchAll().first;
    expect(abonnements, hasLength(1));
    expect(abonnements.first.reference, 'HAV-ABO-000001');
    expect(abonnements.first.clientId, client.id);
    expect(abonnements.first.logementId, logement.id);
    expect(abonnements.first.monthlyPrice, 25000);
    expect(abonnements.first.paymentStatus, PaymentStatus.aJour);
  });

  test('modification et suppression douce fonctionnent', () async {
    await clientsRepository.create(
      fullName: 'Client Test',
      phone: '+237600000001',
      country: 'Cameroun',
      city: 'Douala',
      clientType: 'particulier',
      status: ClientStatus.actif,
      updatedBy: 'test-uid',
    );
    final client = (await clientsRepository.watchAll().first).first;
    await logementsRepository.create(
      clientId: client.id,
      address: '10 rue Test',
      updatedBy: 'test-uid',
    );
    final logement = (await logementsRepository.watchAll().first).first;

    await abonnementsRepository.create(
      clientId: client.id,
      logementId: logement.id,
      formula: 'Basique',
      monthlyPrice: 15000,
      startDate: DateTime(2026, 1, 1),
      paymentStatus: PaymentStatus.aJour,
      updatedBy: 'test-uid',
    );
    final abonnement = (await abonnementsRepository.watchAll().first).first;

    await abonnementsRepository.update(
      id: abonnement.id,
      clientId: client.id,
      logementId: logement.id,
      formula: 'Premium',
      monthlyPrice: 40000,
      startDate: abonnement.startDate,
      paymentStatus: PaymentStatus.enRetard,
      updatedBy: 'test-uid',
    );
    final updated = (await abonnementsRepository.watchAll().first).first;
    expect(updated.formula, 'Premium');
    expect(updated.monthlyPrice, 40000);
    expect(updated.paymentStatus, PaymentStatus.enRetard);
    expect(updated.reference, abonnement.reference);

    await abonnementsRepository.delete(abonnement.id);
    final afterDelete = await abonnementsRepository.watchAll().first;
    expect(afterDelete, isEmpty);
  });
}
