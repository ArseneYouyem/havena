import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/pdf/rapport_pdf_generator.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';
import 'package:havena/features/rapports/repositories/rapports_repository.dart';

void main() {
  late AppDatabase database;
  late LogementsRepository logementsRepository;
  late RapportsRepository rapportsRepository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    final referenceGenerator = ReferenceGeneratorService(database);
    final clientsRepository =
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
}
