import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/core/sync/sync_engine.dart';
import 'package:havena/core/sync/sync_gateway.dart';
import 'package:havena/features/abonnements/repositories/abonnements_repository.dart';
import 'package:havena/features/abonnements/sync/abonnement_sync_adapter.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/finances/repositories/finances_repository.dart';
import 'package:havena/features/finances/sync/finance_sync_adapter.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';
import 'package:havena/features/prestataires/repositories/prestataires_repository.dart';

void main() {
  late AppDatabase database;
  late ClientsRepository clientsRepository;
  late LogementsRepository logementsRepository;
  late PrestatairesRepository prestatairesRepository;
  late ReferenceGeneratorService referenceGenerator;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    referenceGenerator = ReferenceGeneratorService(database);
    clientsRepository =
        ClientsRepository(database.clientsDao, referenceGenerator);
    logementsRepository = LogementsRepository(
        database.logementsDao, referenceGenerator, clientsRepository);
    prestatairesRepository =
        PrestatairesRepository(database.prestatairesDao, referenceGenerator);
  });

  tearDown(() async {
    await database.close();
  });

  group('AbonnementSyncAdapter (2 clés étrangères obligatoires)', () {
    late AbonnementsRepository abonnementsRepository;
    late AbonnementSyncAdapter adapter;
    late InMemorySyncGateway gateway;
    late SyncEngine engine;

    setUp(() {
      abonnementsRepository = AbonnementsRepository(database.abonnementsDao,
          referenceGenerator, clientsRepository, logementsRepository);
      adapter = AbonnementSyncAdapter(
          abonnementsRepository, clientsRepository, logementsRepository);
      gateway = InMemorySyncGateway();
      engine = SyncEngine(gateway);
    });

    Future<(int, int)> createClientAndLogement() async {
      await clientsRepository.create(
        fullName: 'Client Abonné',
        phone: '+237600000030',
        country: 'Cameroun',
        city: 'Douala',
        clientType: 'particulier',
        status: ClientStatus.actif,
        updatedBy: 'test-uid',
      );
      final client = (await clientsRepository.watchAll().first).first;
      await logementsRepository.create(
          clientId: client.id, address: '10 rue Abonné', updatedBy: 'test-uid');
      final logement = (await logementsRepository.watchAll().first).first;
      return (client.id, logement.id);
    }

    test('toFirestoreMap traduit les deux clés étrangères en syncId parent',
        () async {
      final (clientId, logementId) = await createClientAndLogement();
      await abonnementsRepository.create(
        clientId: clientId,
        logementId: logementId,
        formula: 'Standard',
        monthlyPrice: 25000,
        startDate: DateTime(2026, 1, 1),
        paymentStatus: PaymentStatus.aJour,
        updatedBy: 'test-uid',
      );

      await adapter.allLocal();
      final abonnement = (await abonnementsRepository.watchAll().first).first;
      final client = await clientsRepository.findBySyncId(
          (await clientsRepository.watchAll().first).first.syncId!);
      final logement = (await logementsRepository.watchAll().first).first;
      final map = adapter.toFirestoreMap(abonnement);

      expect(map['clientSyncId'], client!.syncId);
      expect(map['logementSyncId'], logement.syncId);
      expect(map.containsKey('clientId'), isFalse);
      expect(map.containsKey('logementId'), isFalse);
    });

    test(
        'upsertFromRemote retrouve les deux parents et traduit en id local',
        () async {
      final (clientId, logementId) = await createClientAndLogement();
      final client = await clientsRepository.findBySyncId(
          (await clientsRepository.watchAll().first)
              .firstWhere((c) => c.id == clientId)
              .syncId!);
      final logement = (await logementsRepository.watchAll().first)
          .firstWhere((l) => l.id == logementId);

      gateway.seed('abonnements', 'remote-abonnement-1', {
        'reference': 'HAV-ABO-000099',
        'clientSyncId': client!.syncId,
        'logementSyncId': logement.syncId,
        'formula': 'Premium',
        'monthlyPrice': 45000.0,
        'startDate': DateTime(2026, 1, 1).toIso8601String(),
        'renewalDate': null,
        'lastPaymentDate': null,
        'nextPaymentDate': null,
        'paymentStatus': 'aJour',
        'lastInspectionDate': null,
        'nextInspectionDate': null,
        'observations': null,
        'updatedAt': DateTime(2026, 9, 1).toIso8601String(),
        'updatedBy': 'autre-appareil',
        'isDeleted': false,
      });

      await engine.syncEntity(adapter, lastDeviceSyncAt: null);

      final abonnements = await abonnementsRepository.watchAll().first;
      expect(abonnements, hasLength(1));
      expect(abonnements.first.clientId, client.id);
      expect(abonnements.first.logementId, logement.id);
    });

    test(
        'upsertFromRemote n\'insère rien si un seul des deux parents obligatoires est introuvable',
        () async {
      final (clientId, _) = await createClientAndLogement();
      final client = (await clientsRepository.watchAll().first)
          .firstWhere((c) => c.id == clientId);

      gateway.seed('abonnements', 'remote-abonnement-orphelin', {
        'reference': 'HAV-ABO-000100',
        'clientSyncId': client.syncId,
        'logementSyncId': 'uuid-logement-jamais-synchronise',
        'formula': 'Standard',
        'monthlyPrice': 25000.0,
        'startDate': DateTime(2026, 1, 1).toIso8601String(),
        'renewalDate': null,
        'lastPaymentDate': null,
        'nextPaymentDate': null,
        'paymentStatus': 'aJour',
        'lastInspectionDate': null,
        'nextInspectionDate': null,
        'observations': null,
        'updatedAt': DateTime(2026, 9, 1).toIso8601String(),
        'updatedBy': 'autre-appareil',
        'isDeleted': false,
      });

      await engine.syncEntity(adapter, lastDeviceSyncAt: null);

      final abonnements = await abonnementsRepository.watchAll().first;
      expect(abonnements, isEmpty);
    });
  });

  group('FinanceSyncAdapter (2 clés étrangères nullables et indépendantes)',
      () {
    late FinancesRepository financesRepository;
    late FinanceSyncAdapter adapter;
    late InMemorySyncGateway gateway;
    late SyncEngine engine;

    setUp(() {
      financesRepository = FinancesRepository(database.financesDao,
          referenceGenerator, clientsRepository, prestatairesRepository);
      adapter = FinanceSyncAdapter(
          financesRepository, clientsRepository, prestatairesRepository);
      gateway = InMemorySyncGateway();
      engine = SyncEngine(gateway);
    });

    test(
        'upsertFromRemote met seulement le champ orphelin à null quand un seul des deux parents nullable est introuvable, l\'autre reste renseigné',
        () async {
      await prestatairesRepository.create(
        fullName: 'Prestataire Payé',
        phone: '+237600000031',
        specialty: 'Peinture',
        status: PrestataireStatus.actif,
        updatedBy: 'test-uid',
      );
      final prestataire =
          (await prestatairesRepository.watchAll().first).first;

      gateway.seed('finances', 'remote-finance-1', {
        'reference': 'HAV-FIN-000099',
        'relatedClientSyncId': 'uuid-client-jamais-synchronise',
        'relatedPrestataireSyncId': prestataire.syncId,
        'transactionDate': DateTime(2026, 9, 1).toIso8601String(),
        'transactionType': 'sortie',
        'description': 'Paiement prestataire',
        'amount': 15000.0,
        'paymentMethod': null,
        'status': 'valide',
        'periodMonth': '2026-09',
        'observations': null,
        'updatedAt': DateTime(2026, 9, 1).toIso8601String(),
        'updatedBy': 'autre-appareil',
        'isDeleted': false,
      });

      await engine.syncEntity(adapter, lastDeviceSyncAt: null);

      final finances = await financesRepository.watchAll().first;
      expect(finances, hasLength(1));
      expect(finances.first.relatedClientId, isNull);
      expect(finances.first.relatedPrestataireId, prestataire.id);
    });

    test(
        'upsertFromRemote insère l\'enregistrement même si les deux clés étrangères sont nulles (transaction sans lien)',
        () async {
      gateway.seed('finances', 'remote-finance-2', {
        'reference': 'HAV-FIN-000100',
        'relatedClientSyncId': null,
        'relatedPrestataireSyncId': null,
        'transactionDate': DateTime(2026, 9, 1).toIso8601String(),
        'transactionType': 'entree',
        'description': 'Paiement générique',
        'amount': 5000.0,
        'paymentMethod': null,
        'status': 'valide',
        'periodMonth': '2026-09',
        'observations': null,
        'updatedAt': DateTime(2026, 9, 1).toIso8601String(),
        'updatedBy': 'autre-appareil',
        'isDeleted': false,
      });

      await engine.syncEntity(adapter, lastDeviceSyncAt: null);

      final finances = await financesRepository.watchAll().first;
      expect(finances, hasLength(1));
      expect(finances.first.relatedClientId, isNull);
      expect(finances.first.relatedPrestataireId, isNull);
    });
  });
}
