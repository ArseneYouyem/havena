import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/pdf/checklist_inspection_pdf_generator.dart';
import 'package:havena/core/pdf/contrat_abonnement_pdf_generator.dart';
import 'package:havena/core/pdf/devis_pdf_generator.dart';
import 'package:havena/core/pdf/facture_pdf_generator.dart';
import 'package:havena/core/pdf/fiche_client_pdf_generator.dart';
import 'package:havena/core/pdf/fiche_intervention_pdf_generator.dart';
import 'package:havena/core/pdf/fiche_logement_pdf_generator.dart';
import 'package:havena/core/pdf/fiche_prestataire_pdf_generator.dart';
import 'package:havena/core/pdf/procedure_coordinateur_pdf_generator.dart';
import 'package:havena/core/pdf/recu_pdf_generator.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/features/abonnements/repositories/abonnements_repository.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/finances/repositories/finances_repository.dart';
import 'package:havena/features/inspections/repositories/inspection_items_repository.dart';
import 'package:havena/features/inspections/repositories/inspections_repository.dart';
import 'package:havena/features/interventions/repositories/interventions_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';
import 'package:havena/features/prestataires/repositories/prestataires_repository.dart';

void main() {
  late AppDatabase database;
  late ClientsRepository clientsRepository;
  late LogementsRepository logementsRepository;
  late InterventionsRepository interventionsRepository;
  late PrestatairesRepository prestatairesRepository;
  late AbonnementsRepository abonnementsRepository;
  late FinancesRepository financesRepository;
  late InspectionsRepository inspectionsRepository;
  late InspectionItemsRepository inspectionItemsRepository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    final referenceGenerator = ReferenceGeneratorService(database);
    clientsRepository =
        ClientsRepository(database.clientsDao, referenceGenerator);
    logementsRepository = LogementsRepository(
        database.logementsDao, referenceGenerator, clientsRepository);
    prestatairesRepository =
        PrestatairesRepository(database.prestatairesDao, referenceGenerator);
    inspectionsRepository = InspectionsRepository(
      database.inspectionsDao,
      database.inspectionItemsDao,
      referenceGenerator,
      logementsRepository,
    );
    interventionsRepository = InterventionsRepository(
      database.interventionsDao,
      referenceGenerator,
      clientsRepository,
      logementsRepository,
      prestatairesRepository,
      inspectionsRepository,
    );
    abonnementsRepository = AbonnementsRepository(database.abonnementsDao,
        referenceGenerator, clientsRepository, logementsRepository);
    financesRepository = FinancesRepository(database.financesDao,
        referenceGenerator, clientsRepository, prestatairesRepository);
    inspectionItemsRepository =
        InspectionItemsRepository(database.inspectionItemsDao);
  });

  tearDown(() async {
    await database.close();
  });

  void expectValidPdf(List<int> bytes) {
    expect(bytes, isNotEmpty);
    final header = String.fromCharCodes(bytes.take(5));
    expect(header, '%PDF-');
  }

  test('FicheClientPdfGenerator produit un PDF valide', () async {
    await clientsRepository.create(
      fullName: 'Client Documents',
      phone: '+237600000010',
      country: 'Cameroun',
      city: 'Douala',
      clientType: 'particulier',
      status: ClientStatus.actif,
      updatedBy: 'test-uid',
    );
    final client = (await clientsRepository.watchAll().first).first;

    final bytes = await FicheClientPdfGenerator.generate(client: client);
    expectValidPdf(bytes);
  });

  test('FicheLogementPdfGenerator produit un PDF valide', () async {
    await clientsRepository.create(
      fullName: 'Client Logement Doc',
      phone: '+237600000011',
      country: 'Cameroun',
      city: 'Douala',
      clientType: 'particulier',
      status: ClientStatus.actif,
      updatedBy: 'test-uid',
    );
    final client = (await clientsRepository.watchAll().first).first;
    await logementsRepository.create(
      clientId: client.id,
      address: '10 rue des documents',
      updatedBy: 'test-uid',
    );
    final logement = (await logementsRepository.watchAll().first).first;

    final bytes = await FicheLogementPdfGenerator.generate(
      logement: logement,
      clientName: client.fullName,
    );
    expectValidPdf(bytes);
  });

  test('FichePrestatairePdfGenerator produit un PDF valide', () async {
    await prestatairesRepository.create(
      fullName: 'Prestataire Documents',
      phone: '+237600000012',
      specialty: 'Plomberie',
      status: PrestataireStatus.actif,
      updatedBy: 'test-uid',
    );
    final prestataire = (await prestatairesRepository.watchAll().first).first;

    final bytes =
        await FichePrestatairePdfGenerator.generate(prestataire: prestataire);
    expectValidPdf(bytes);
  });

  test(
      'FicheInterventionPdfGenerator, DevisPdfGenerator et FacturePdfGenerator produisent des PDF valides',
      () async {
    await clientsRepository.create(
      fullName: 'Client Intervention Doc',
      phone: '+237600000013',
      country: 'Cameroun',
      city: 'Douala',
      clientType: 'particulier',
      status: ClientStatus.actif,
      updatedBy: 'test-uid',
    );
    final client = (await clientsRepository.watchAll().first).first;
    await logementsRepository.create(
      clientId: client.id,
      address: '20 rue de la facture',
      updatedBy: 'test-uid',
    );
    final logement = (await logementsRepository.watchAll().first).first;
    final interventionId = await interventionsRepository.create(
      logementId: logement.id,
      clientId: client.id,
      problemDescription: 'Fuite robinet cuisine',
      urgencyLevel: UrgencyLevel.normale,
      updatedBy: 'test-uid',
    );
    final intervention =
        (await interventionsRepository.getById(interventionId))!;

    final fiche = await FicheInterventionPdfGenerator.generate(
      intervention: intervention,
      logement: logement,
      clientName: client.fullName,
    );
    expectValidPdf(fiche);

    final devis = await DevisPdfGenerator.generate(
      intervention: intervention,
      logement: logement,
      clientName: client.fullName,
    );
    expectValidPdf(devis);

    final facture = await FacturePdfGenerator.generate(
      intervention: intervention,
      logement: logement,
      clientName: client.fullName,
    );
    expectValidPdf(facture);
  });

  test('RecuPdfGenerator produit un PDF valide', () async {
    await financesRepository.create(
      transactionDate: DateTime(2026, 9, 1),
      transactionType: TransactionType.entree,
      description: 'Paiement client documents',
      amount: 30000,
      status: TransactionStatus.valide,
      periodMonth: '2026-09',
      updatedBy: 'test-uid',
    );
    final finance = (await financesRepository.watchAll().first).first;

    final bytes = await RecuPdfGenerator.generate(finance: finance);
    expectValidPdf(bytes);
  });

  test('ContratAbonnementPdfGenerator produit un PDF valide', () async {
    await clientsRepository.create(
      fullName: 'Client Contrat',
      phone: '+237600000014',
      country: 'Cameroun',
      city: 'Douala',
      clientType: 'particulier',
      status: ClientStatus.actif,
      updatedBy: 'test-uid',
    );
    final client = (await clientsRepository.watchAll().first).first;
    await logementsRepository.create(
      clientId: client.id,
      address: '30 rue du contrat',
      updatedBy: 'test-uid',
    );
    final logement = (await logementsRepository.watchAll().first).first;
    await abonnementsRepository.create(
      clientId: client.id,
      logementId: logement.id,
      formula: 'Premium',
      monthlyPrice: 45000,
      startDate: DateTime(2026, 1, 1),
      paymentStatus: PaymentStatus.aJour,
      updatedBy: 'test-uid',
    );
    final abonnement = (await abonnementsRepository.watchAll().first).first;

    final bytes = await ContratAbonnementPdfGenerator.generate(
      abonnement: abonnement,
      client: client,
      logement: logement,
    );
    expectValidPdf(bytes);
  });

  test('ChecklistInspectionPdfGenerator produit un PDF valide', () async {
    await logementsRepository.create(
      address: '40 rue de la checklist',
      updatedBy: 'test-uid',
    );
    final logement = (await logementsRepository.watchAll().first).first;
    final inspectionId = await inspectionsRepository.createWithChecklist(
      logementId: logement.id,
      inspectionDate: DateTime(2026, 9, 1),
      updatedBy: 'test-uid',
    );
    final inspection = (await inspectionsRepository.watchAll().first)
        .firstWhere((i) => i.id == inspectionId);
    final items = await inspectionItemsRepository
        .watchByInspection(inspectionId)
        .first;

    final bytes = await ChecklistInspectionPdfGenerator.generate(
      inspection: inspection,
      logement: logement,
      items: items,
    );
    expectValidPdf(bytes);
  });

  test('ProcedureCoordinateurPdfGenerator produit un PDF valide', () async {
    final bytes = await ProcedureCoordinateurPdfGenerator.generate();
    expectValidPdf(bytes);
  });
}
