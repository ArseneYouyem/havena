import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/features/abonnements/repositories/abonnements_repository.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/dashboard/controllers/dashboard_controller.dart';
import 'package:havena/features/finances/repositories/finances_repository.dart';
import 'package:havena/features/inspections/repositories/inspections_repository.dart';
import 'package:havena/features/interventions/repositories/interventions_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';
import 'package:havena/features/prestataires/repositories/prestataires_repository.dart';

void main() {
  late AppDatabase database;
  late ClientsRepository clientsRepository;
  late LogementsRepository logementsRepository;
  late InterventionsRepository interventionsRepository;
  late AbonnementsRepository abonnementsRepository;
  late FinancesRepository financesRepository;
  late PrestatairesRepository prestatairesRepository;
  late InspectionsRepository inspectionsRepository;
  late DashboardController controller;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    final referenceGenerator = ReferenceGeneratorService(database);
    clientsRepository =
        ClientsRepository(database.clientsDao, referenceGenerator);
    logementsRepository = LogementsRepository(
        database.logementsDao, referenceGenerator, clientsRepository);
    prestatairesRepository =
        PrestatairesRepository(database.prestatairesDao, referenceGenerator);
    interventionsRepository = InterventionsRepository(
      database.interventionsDao,
      referenceGenerator,
      clientsRepository,
      logementsRepository,
      prestatairesRepository,
    );
    abonnementsRepository = AbonnementsRepository(database.abonnementsDao,
        referenceGenerator, clientsRepository, logementsRepository);
    financesRepository = FinancesRepository(database.financesDao,
        referenceGenerator, clientsRepository, prestatairesRepository);
    inspectionsRepository = InspectionsRepository(
      database.inspectionsDao,
      database.inspectionItemsDao,
      referenceGenerator,
      logementsRepository,
    );

    controller = DashboardController(
      clientsRepository,
      logementsRepository,
      interventionsRepository,
      abonnementsRepository,
      financesRepository,
      prestatairesRepository,
      inspectionsRepository,
    );
    controller.onInit();
  });

  tearDown(() {
    controller.onClose();
    database.close();
  });

  Future<(int, int)> createClientAndLogement() async {
    await clientsRepository.create(
      fullName: 'Client Dashboard',
      phone: '+237600000050',
      country: 'Cameroun',
      city: 'Douala',
      clientType: 'particulier',
      status: ClientStatus.actif,
      updatedBy: 'test-uid',
    );
    final client = (await clientsRepository.watchAll().first).first;
    await logementsRepository.create(
        clientId: client.id, address: '40 rue Dashboard', updatedBy: 'test-uid');
    final logement = (await logementsRepository.watchAll().first).first;
    return (client.id, logement.id);
  }

  test(
      'interventionsOuvertes ne compte pas les interventions terminées/payées/archivées',
      () async {
    final (clientId, logementId) = await createClientAndLogement();

    final activeId = await interventionsRepository.create(
      logementId: logementId,
      clientId: clientId,
      problemDescription: 'Active',
      urgencyLevel: UrgencyLevel.normale,
      updatedBy: 'test-uid',
    );
    final doneId = await interventionsRepository.create(
      logementId: logementId,
      clientId: clientId,
      problemDescription: 'Terminée',
      urgencyLevel: UrgencyLevel.normale,
      updatedBy: 'test-uid',
    );
    await interventionsRepository.updateStatus(
      id: doneId,
      status: InterventionStatus.termine,
      updatedBy: 'test-uid',
    );
    await interventionsRepository.updateStatus(
      id: activeId,
      status: InterventionStatus.planifie,
      updatedBy: 'test-uid',
    );

    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(controller.interventionsOuvertes.value, 1);
    expect(controller.interventionsTerminees.value, 1);
  });

  test('abonnementsActifs compte tous les abonnements non supprimés',
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
    await abonnementsRepository.create(
      clientId: clientId,
      logementId: logementId,
      formula: 'Premium',
      monthlyPrice: 45000,
      startDate: DateTime(2026, 1, 1),
      paymentStatus: PaymentStatus.enRetard,
      updatedBy: 'test-uid',
    );

    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(controller.abonnementsActifs.value, 2);
  });

  test('prestatairesActifs et inspectionsRealisees comptent uniquement les bons statuts',
      () async {
    final (_, logementId) = await createClientAndLogement();

    await prestatairesRepository.create(
      fullName: 'Prestataire Actif',
      phone: '+237600000060',
      specialty: 'Plomberie',
      status: PrestataireStatus.actif,
      updatedBy: 'test-uid',
    );
    await prestatairesRepository.create(
      fullName: 'Prestataire Suspendu',
      phone: '+237600000061',
      specialty: 'Électricité',
      status: PrestataireStatus.suspendu,
      updatedBy: 'test-uid',
    );

    final validatedId = await inspectionsRepository.createWithChecklist(
      logementId: logementId,
      inspectionDate: DateTime.now(),
      updatedBy: 'test-uid',
    );
    await inspectionsRepository.createWithChecklist(
      logementId: logementId,
      inspectionDate: DateTime.now(),
      updatedBy: 'test-uid',
    );
    await inspectionsRepository.validate(id: validatedId, updatedBy: 'test-uid');

    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(controller.prestatairesActifs.value, 1);
    expect(controller.inspectionsRealisees.value, 1);
  });

  test(
      'margeMensuelle/incidentsOuverts/satisfactionMoyenne dérivés des interventions',
      () async {
    final (clientId, logementId) = await createClientAndLogement();

    final critiqueId = await interventionsRepository.create(
      logementId: logementId,
      clientId: clientId,
      problemDescription: 'Fuite majeure',
      urgencyLevel: UrgencyLevel.critique,
      updatedBy: 'test-uid',
    );
    await interventionsRepository.updatePlanning(
      id: critiqueId,
      interventionDate: DateTime.now(),
      updatedBy: 'test-uid',
    );
    await interventionsRepository.updateAmounts(
      id: critiqueId,
      clientAmount: 100000,
      prestataireAmount: 60000,
      updatedBy: 'test-uid',
    );
    await interventionsRepository.updateSatisfaction(
      id: critiqueId,
      clientSatisfaction: 4,
      updatedBy: 'test-uid',
    );

    final termineeId = await interventionsRepository.create(
      logementId: logementId,
      clientId: clientId,
      problemDescription: 'Réparation mineure',
      urgencyLevel: UrgencyLevel.critique,
      updatedBy: 'test-uid',
    );
    await interventionsRepository.updateStatus(
      id: termineeId,
      status: InterventionStatus.termine,
      updatedBy: 'test-uid',
    );

    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(controller.margeMensuelle.value, 40000);
    // Une seule critique encore ouverte : la seconde est déjà terminée.
    expect(controller.incidentsOuverts.value, 1);
    expect(controller.satisfactionMoyenne.value, 4.0);
  });

  test('chiffreAffairesMensuel ne compte que les entrées validées du mois en cours',
      () async {
    final now = DateTime.now();
    final currentPeriod =
        '${now.year}-${now.month.toString().padLeft(2, '0')}';

    await financesRepository.create(
      transactionDate: now,
      transactionType: TransactionType.entree,
      description: 'Paiement client',
      amount: 50000,
      status: TransactionStatus.valide,
      periodMonth: currentPeriod,
      updatedBy: 'test-uid',
    );
    await financesRepository.create(
      transactionDate: now,
      transactionType: TransactionType.sortie,
      description: 'Paiement prestataire',
      amount: 20000,
      status: TransactionStatus.valide,
      periodMonth: currentPeriod,
      updatedBy: 'test-uid',
    );
    await financesRepository.create(
      transactionDate: now,
      transactionType: TransactionType.entree,
      description: 'Entrée annulée',
      amount: 15000,
      status: TransactionStatus.annule,
      periodMonth: currentPeriod,
      updatedBy: 'test-uid',
    );
    await financesRepository.create(
      transactionDate: DateTime(now.year - 1, now.month),
      transactionType: TransactionType.entree,
      description: 'Entrée mois précédent',
      amount: 99999,
      status: TransactionStatus.valide,
      periodMonth: '${now.year - 1}-${now.month.toString().padLeft(2, '0')}',
      updatedBy: 'test-uid',
    );

    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(controller.chiffreAffairesMensuel.value, 50000);
  });

  test('alerts signale abonnements impayés/en retard/à renouveler et interventions critiques',
      () async {
    final (clientId, logementId) = await createClientAndLogement();

    await abonnementsRepository.create(
      clientId: clientId,
      logementId: logementId,
      formula: 'Standard',
      monthlyPrice: 25000,
      startDate: DateTime(2026, 1, 1),
      paymentStatus: PaymentStatus.impaye,
      updatedBy: 'test-uid',
    );
    await interventionsRepository.create(
      logementId: logementId,
      clientId: clientId,
      problemDescription: 'Panne critique',
      urgencyLevel: UrgencyLevel.critique,
      updatedBy: 'test-uid',
    );

    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(
      controller.alerts.any((a) =>
          a.level == DashboardAlertLevel.rouge &&
          a.message.contains('impayé')),
      isTrue,
    );
    expect(
      controller.alerts.any((a) =>
          a.level == DashboardAlertLevel.rouge &&
          a.message.contains('critique')),
      isTrue,
    );
  });

  test('clientsActifs ne compte que les clients au statut actif', () async {
    await clientsRepository.create(
      fullName: 'Client Actif',
      phone: '+237600000080',
      country: 'Cameroun',
      city: 'Douala',
      clientType: 'particulier',
      status: ClientStatus.actif,
      updatedBy: 'test-uid',
    );
    await clientsRepository.create(
      fullName: 'Client Suspendu',
      phone: '+237600000081',
      country: 'Cameroun',
      city: 'Douala',
      clientType: 'particulier',
      status: ClientStatus.suspendu,
      updatedBy: 'test-uid',
    );

    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(controller.clientsActifs.value, 1);
  });

  test(
      'inspectionsAEffectuer compte les inspections non validées, '
      'distinctement de inspectionsRealisees', () async {
    final (_, logementId) = await createClientAndLogement();

    final pendingId = await inspectionsRepository.createWithChecklist(
      logementId: logementId,
      inspectionDate: DateTime.now(),
      updatedBy: 'test-uid',
    );
    final validatedId = await inspectionsRepository.createWithChecklist(
      logementId: logementId,
      inspectionDate: DateTime.now(),
      updatedBy: 'test-uid',
    );
    await inspectionsRepository.validate(id: validatedId, updatedBy: 'test-uid');

    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(controller.inspectionsAEffectuer.value, 1);
    expect(controller.inspectionsRealisees.value, 1);
    expect(pendingId, isNot(validatedId));
  });

  test(
      'paiementsEnAttente et abonnementsARenouveler reflètent les '
      'abonnements concernés', () async {
    final (clientId, logementId) = await createClientAndLogement();

    await abonnementsRepository.create(
      clientId: clientId,
      logementId: logementId,
      formula: 'En retard',
      monthlyPrice: 15000,
      startDate: DateTime(2026, 1, 1),
      paymentStatus: PaymentStatus.enRetard,
      updatedBy: 'test-uid',
    );
    await abonnementsRepository.create(
      clientId: clientId,
      logementId: logementId,
      formula: 'À jour mais renouvellement proche',
      monthlyPrice: 20000,
      startDate: DateTime(2026, 1, 1),
      renewalDate: DateTime.now().add(const Duration(days: 3)),
      paymentStatus: PaymentStatus.aJour,
      updatedBy: 'test-uid',
    );
    await abonnementsRepository.create(
      clientId: clientId,
      logementId: logementId,
      formula: 'Sans souci',
      monthlyPrice: 10000,
      startDate: DateTime(2026, 1, 1),
      paymentStatus: PaymentStatus.aJour,
      updatedBy: 'test-uid',
    );

    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(controller.paiementsEnAttente.value, 1);
    expect(controller.abonnementsARenouveler.value, 1);
  });

  test(
      'depensesMensuelles et montantPayePrestataires ne comptent que les '
      'sorties validées du mois en cours', () async {
    final now = DateTime.now();
    final currentPeriod =
        '${now.year}-${now.month.toString().padLeft(2, '0')}';

    final (_, _) = await createClientAndLogement();
    await prestatairesRepository.create(
      fullName: 'Prestataire Finances',
      phone: '+237600000082',
      specialty: 'Plomberie',
      status: PrestataireStatus.actif,
      updatedBy: 'test-uid',
    );
    final prestataire = (await prestatairesRepository.watchAll().first).first;

    await financesRepository.create(
      transactionDate: now,
      transactionType: TransactionType.sortie,
      relatedPrestataireId: prestataire.id,
      description: 'Paiement prestataire',
      amount: 30000,
      status: TransactionStatus.valide,
      periodMonth: currentPeriod,
      updatedBy: 'test-uid',
    );
    await financesRepository.create(
      transactionDate: now,
      transactionType: TransactionType.sortie,
      description: 'Achat fournitures (sans prestataire)',
      amount: 5000,
      status: TransactionStatus.valide,
      periodMonth: currentPeriod,
      updatedBy: 'test-uid',
    );

    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(controller.depensesMensuelles.value, 35000);
    expect(controller.montantPayePrestataires.value, 30000);
  });
}
