import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/features/prestataires/repositories/prestataires_repository.dart';

void main() {
  late AppDatabase database;
  late PrestatairesRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = PrestatairesRepository(
      database.prestatairesDao,
      ReferenceGeneratorService(database),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('crée un prestataire avec référence auto-générée et notes', () async {
    await repository.create(
      fullName: 'Plombier Test',
      phone: '+237600000000',
      specialty: 'Plomberie',
      zone: 'Bonamoussadi',
      qualityRating: 4.5,
      status: PrestataireStatus.actif,
      updatedBy: 'test-uid',
    );

    final list = await repository.watchAll().first;
    expect(list, hasLength(1));
    expect(list.first.reference, 'HAV-PRE-000001');
    expect(list.first.qualityRating, 4.5);
    expect(list.first.interventionsCount, 0);
    expect(list.first.lastInterventionDate, isNull);
  });

  test('modification préserve interventionsCount, suppression douce fonctionne',
      () async {
    await repository.create(
      fullName: 'Électricien Test',
      phone: '+237600000001',
      specialty: 'Électricité',
      status: PrestataireStatus.actif,
      updatedBy: 'test-uid',
    );
    final prestataire = (await repository.watchAll().first).first;

    await repository.update(
      id: prestataire.id,
      fullName: prestataire.fullName,
      phone: prestataire.phone,
      specialty: prestataire.specialty,
      identityVerified: true,
      referencesVerified: true,
      status: PrestataireStatus.sousSurveillance,
      updatedBy: 'test-uid',
    );
    final updated = (await repository.watchAll().first).first;
    expect(updated.identityVerified, isTrue);
    expect(updated.status, PrestataireStatus.sousSurveillance);
    expect(updated.interventionsCount, 0);

    await repository.delete(prestataire.id);
    final afterDelete = await repository.watchAll().first;
    expect(afterDelete, isEmpty);
  });
}
