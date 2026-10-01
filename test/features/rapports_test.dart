import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/pdf/rapport_pdf_generator.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/core/storage/file_storage_service.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/finances/repositories/finances_repository.dart';
import 'package:havena/features/inspections/repositories/inspection_items_repository.dart';
import 'package:havena/features/inspections/repositories/inspections_repository.dart';
import 'package:havena/features/interventions/repositories/interventions_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';
import 'package:havena/features/photos/repositories/photos_repository.dart';
import 'package:havena/features/prestataires/repositories/prestataires_repository.dart';
import 'package:havena/features/rapports/controllers/rapports_controller.dart';
import 'package:havena/features/rapports/repositories/rapports_repository.dart';

void main() {
  late AppDatabase database;
  late ClientsRepository clientsRepository;
  late LogementsRepository logementsRepository;
  late RapportsRepository rapportsRepository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    final referenceGenerator = ReferenceGeneratorService(database);
    clientsRepository =
        ClientsRepository(database.clientsDao, referenceGenerator);
    logementsRepository = LogementsRepository(
        database.logementsDao, referenceGenerator, clientsRepository);
    rapportsRepository = RapportsRepository(
        database.rapportsDao, referenceGenerator, logementsRepository);
  });

  tearDown(() async {
    await database.close();
  });

  test('crée un rapport mensuel avec référence auto-générée', () async {
    await logementsRepository.create(
      address: '7 rue du rapport',
      updatedBy: 'test-uid',
    );
    final logement = (await logementsRepository.watchAll().first).first;

    await rapportsRepository.create(
      logementId: logement.id,
      periodMonth: '2026-09',
      generalCondition: HousingCondition.bon,
      inspectionDone: true,
      anomalies: 'Aucune',
      updatedBy: 'test-uid',
    );

    final rapports = await rapportsRepository.watchAll().first;
    expect(rapports, hasLength(1));
    expect(rapports.first.reference, 'HAV-RAP-000001');
    expect(rapports.first.generalCondition, HousingCondition.bon);
    expect(rapports.first.pdfLocalPath, isNull);
  });

  test('génère un PDF valide (en-tête %PDF) pour un rapport', () async {
    await logementsRepository.create(
      address: '9 avenue du PDF',
      updatedBy: 'test-uid',
    );
    final logement = (await logementsRepository.watchAll().first).first;
    await rapportsRepository.create(
      logementId: logement.id,
      periodMonth: '2026-09',
      inspectionDone: false,
      recommendations: 'Vérifier la climatisation',
      updatedBy: 'test-uid',
    );
    final rapport = (await rapportsRepository.watchAll().first).first;

    final bytes = await RapportPdfGenerator.generate(
      rapport: rapport,
      logement: logement,
      clientName: 'Client Test',
    );

    expect(bytes, isNotEmpty);
    // Un fichier PDF valide commence toujours par la signature %PDF-.
    final header = String.fromCharCodes(bytes.take(5));
    expect(header, '%PDF-');
  });

  test('updatePdfInfo enregistre le chemin et la date de génération',
      () async {
    await logementsRepository.create(
      address: '11 boulevard du rapport',
      updatedBy: 'test-uid',
    );
    final logement = (await logementsRepository.watchAll().first).first;
    await rapportsRepository.create(
      logementId: logement.id,
      periodMonth: '2026-09',
      inspectionDone: false,
      updatedBy: 'test-uid',
    );
    final rapport = (await rapportsRepository.watchAll().first).first;

    final now = DateTime.now();
    await rapportsRepository.updatePdfInfo(
      id: rapport.id,
      pdfLocalPath: '/tmp/HAV-RAP-000001.pdf',
      generatedAt: now,
    );

    final updated = await rapportsRepository.watchAll().first;
    expect(updated.first.pdfLocalPath, '/tmp/HAV-RAP-000001.pdf');
    expect(updated.first.generatedAt, isNotNull);
  });

  test(
      'generateReportsForSelectedMonth calcule anomalies/interventions/'
      'état général et les dépenses du CLIENT (pas du prestataire) à '
      'partir des enregistrements du mois', () async {
    final referenceGenerator = ReferenceGeneratorService(database);
    final prestatairesRepository =
        PrestatairesRepository(database.prestatairesDao, referenceGenerator);
    final inspectionsRepository = InspectionsRepository(
      database.inspectionsDao,
      database.inspectionItemsDao,
      referenceGenerator,
      logementsRepository,
    );
    final interventionsRepository = InterventionsRepository(
      database.interventionsDao,
      referenceGenerator,
      clientsRepository,
      logementsRepository,
      prestatairesRepository,
      inspectionsRepository,
    );
    final inspectionItemsRepository =
        InspectionItemsRepository(database.inspectionItemsDao);
    final financesRepository = FinancesRepository(
      database.financesDao,
      referenceGenerator,
      clientsRepository,
      prestatairesRepository,
    );

    await clientsRepository.create(
      fullName: 'Client Rapport',
      phone: '+237600000070',
      country: 'Cameroun',
      city: 'Douala',
      clientType: 'particulier',
      status: ClientStatus.actif,
      updatedBy: 'test-uid',
    );
    final client = (await clientsRepository.watchAll().first).first;
    await logementsRepository.create(
        clientId: client.id, address: '15 rue Rapport', updatedBy: 'test-uid');
    final logement = (await logementsRepository.watchAll().first).first;

    // Toujours le mois PRÉCÉDENT le jour du test (jamais le mois courant) :
    // un rapport ne peut être généré que pour un mois déjà terminé.
    final previousMonth =
        DateTime(DateTime.now().year, DateTime.now().month - 1);
    final period =
        '${previousMonth.year}-${previousMonth.month.toString().padLeft(2, '0')}';
    final eventDate = DateTime(previousMonth.year, previousMonth.month, 10);

    final interventionId = await interventionsRepository.create(
      logementId: logement.id,
      clientId: client.id,
      problemDescription: 'Fuite cuisine',
      urgencyLevel: UrgencyLevel.normale,
      updatedBy: 'test-uid',
    );
    await interventionsRepository.updatePlanning(
      id: interventionId,
      interventionDate: eventDate,
      updatedBy: 'test-uid',
    );
    await interventionsRepository.updateAmounts(
      id: interventionId,
      clientAmount: 80000,
      prestataireAmount: 50000,
      updatedBy: 'test-uid',
    );

    final inspectionId = await inspectionsRepository.createWithChecklist(
      logementId: logement.id,
      inspectionDate: eventDate,
      updatedBy: 'test-uid',
    );
    await inspectionsRepository.updateGeneralCondition(
      id: inspectionId,
      value: HousingCondition.moyen,
      updatedBy: 'test-uid',
    );
    await inspectionsRepository.updateRecommendations(
      id: inspectionId,
      value: 'Revoir la plomberie',
      updatedBy: 'test-uid',
    );
    final items =
        await inspectionItemsRepository.watchByInspection(inspectionId).first;
    final firstItem = items.first;
    await inspectionItemsRepository.updateStatus(
      itemId: firstItem.id,
      isOk: false,
      updatedBy: 'test-uid',
    );
    await inspectionItemsRepository.updateObservation(
      itemId: firstItem.id,
      observation: 'Fissure visible',
      updatedBy: 'test-uid',
    );
    await inspectionsRepository.validate(id: inspectionId, updatedBy: 'test-uid');

    // Paiement du CLIENT (ponctuel ou abonnement) enregistré dans Finances —
    // c'est ce montant, pas le `prestataireAmount` versé au prestataire,
    // qui doit apparaître comme « dépenses du client » dans le rapport.
    await financesRepository.create(
      transactionDate: eventDate,
      transactionType: TransactionType.entree,
      relatedClientId: client.id,
      description: 'Paiement intervention',
      amount: 80000,
      status: TransactionStatus.valide,
      periodMonth: period,
      updatedBy: 'test-uid',
    );

    final tempDir = await Directory.systemTemp.createTemp('havena_rapports_test_');
    addTearDown(() => tempDir.delete(recursive: true));
    final photosRepository = PhotosRepository(
      database.photosDao,
      FileStorageService(baseDirectory: tempDir),
    );

    final controller = RapportsController(
      rapportsRepository,
      logementsRepository,
      clientsRepository,
      SessionController(),
      interventionsRepository,
      inspectionsRepository,
      inspectionItemsRepository,
      photosRepository,
      financesRepository,
    );
    controller.onInit();
    await Future<void>.delayed(const Duration(milliseconds: 50));
    controller.selectedMonth.value = period;

    expect(controller.canGenerateForSelectedMonth, isTrue);
    await controller.generateReportsForSelectedMonth();

    final rapports = await rapportsRepository.watchAll().first;
    final rapport = rapports.firstWhere((r) => r.logementId == logement.id);
    expect(rapport.periodMonth, period);
    expect(rapport.inspectionDone, isTrue);
    expect(rapport.generalCondition, HousingCondition.moyen);
    expect(rapport.recommendations, 'Revoir la plomberie');
    expect(rapport.totalExpenses, 80000);
    expect(rapport.interventionsDone, contains('Fuite cuisine'));
    expect(rapport.anomalies, contains('Fissure visible'));
  });

  test('generate produit un PDF valide avec des photos jointes', () async {
    await logementsRepository.create(
      address: '21 rue des Photos',
      updatedBy: 'test-uid',
    );
    final logement = (await logementsRepository.watchAll().first).first;
    await rapportsRepository.create(
      logementId: logement.id,
      periodMonth: '2026-09',
      inspectionDone: false,
      updatedBy: 'test-uid',
    );
    final rapport = (await rapportsRepository.watchAll().first).first;

    final tempDir =
        await Directory.systemTemp.createTemp('havena_rapports_photo_test_');
    addTearDown(() => tempDir.delete(recursive: true));
    // Pas un vrai JPEG valide, mais le générateur doit rester robuste face
    // à un fichier image illisible plutôt que de faire échouer tout le PDF.
    final photoFile = File('${tempDir.path}/photo.jpg');
    await photoFile.writeAsBytes([1, 2, 3, 4]);

    final bytes = await RapportPdfGenerator.generate(
      rapport: rapport,
      logement: logement,
      clientName: 'Client Test',
      photoFilePaths: [photoFile.path],
    );

    expect(bytes, isNotEmpty);
    final header = String.fromCharCodes(bytes.take(5));
    expect(header, '%PDF-');
  });
}
