import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/inspections/inspection_checklist.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/features/inspections/repositories/inspection_items_repository.dart';
import 'package:havena/features/inspections/repositories/inspections_repository.dart';
import 'package:havena/features/logements/repositories/logements_repository.dart';

void main() {
  late AppDatabase database;
  late InspectionsRepository inspectionsRepository;
  late InspectionItemsRepository inspectionItemsRepository;
  late LogementsRepository logementsRepository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    final referenceGenerator = ReferenceGeneratorService(database);
    inspectionsRepository = InspectionsRepository(
      database.inspectionsDao,
      database.inspectionItemsDao,
      referenceGenerator,
    );
    inspectionItemsRepository =
        InspectionItemsRepository(database.inspectionItemsDao);
    logementsRepository =
        LogementsRepository(database.logementsDao, referenceGenerator);
  });

  tearDown(() async {
    await database.close();
  });

  int totalChecklistItems() =>
      InspectionChecklist.items.values.fold(0, (sum, l) => sum + l.length);

  test(
      'crée une inspection avec la checklist complète générée automatiquement',
      () async {
    await logementsRepository.create(
      address: '1 rue de la checklist',
      updatedBy: 'test-uid',
    );
    final logement = (await logementsRepository.watchAll().first).first;

    final inspectionId = await inspectionsRepository.createWithChecklist(
      logementId: logement.id,
      inspectionDate: DateTime(2026, 1, 15),
      updatedBy: 'test-uid',
    );

    final inspections = await inspectionsRepository.watchAll().first;
    expect(inspections, hasLength(1));
    expect(inspections.first.reference, 'HAV-INS-000001');
    expect(inspections.first.isValidated, isFalse);

    final items =
        await inspectionItemsRepository.watchByInspection(inspectionId).first;
    expect(items, hasLength(totalChecklistItems()));
    expect(items.every((i) => i.isOk == null), isTrue);

    // Vérifie qu'une catégorie précise contient bien ses libellés officiels.
    final securite = items
        .where((i) => i.category == InspectionCategory.securite)
        .map((i) => i.label)
        .toList();
    expect(securite, containsAll(['Alarme', 'Détecteur de fumée', 'Portail']));
  });

  test('met à jour un item de checklist et valide l\'inspection', () async {
    await logementsRepository.create(
      address: '2 rue de la validation',
      updatedBy: 'test-uid',
    );
    final logement = (await logementsRepository.watchAll().first).first;
    final inspectionId = await inspectionsRepository.createWithChecklist(
      logementId: logement.id,
      inspectionDate: DateTime.now(),
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
      observation: 'Fuite détectée',
      updatedBy: 'test-uid',
    );

    final updatedItems =
        await inspectionItemsRepository.watchByInspection(inspectionId).first;
    final updatedItem = updatedItems.firstWhere((i) => i.id == firstItem.id);
    expect(updatedItem.isOk, isFalse);
    expect(updatedItem.observation, 'Fuite détectée');

    await inspectionsRepository.validate(id: inspectionId, updatedBy: 'test-uid');
    final validated = await inspectionsRepository.getById(inspectionId);
    expect(validated!.isValidated, isTrue);
    expect(validated.validatedAt, isNotNull);
  });
}
