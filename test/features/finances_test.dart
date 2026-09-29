import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/references/reference_generator_service.dart';
import 'package:havena/features/finances/repositories/finances_repository.dart';

void main() {
  late AppDatabase database;
  late FinancesRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = FinancesRepository(
      database.financesDao,
      ReferenceGeneratorService(database),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('crée des transactions entrée/sortie avec référence auto-générée',
      () async {
    await repository.create(
      transactionDate: DateTime(2026, 9, 1),
      transactionType: TransactionType.entree,
      description: 'Paiement client',
      amount: 50000,
      status: TransactionStatus.valide,
      periodMonth: '2026-09',
      updatedBy: 'test-uid',
    );
    await repository.create(
      transactionDate: DateTime(2026, 9, 2),
      transactionType: TransactionType.sortie,
      description: 'Paiement prestataire',
      amount: 20000,
      status: TransactionStatus.valide,
      periodMonth: '2026-09',
      updatedBy: 'test-uid',
    );

    final all = await repository.watchAll().first;
    expect(all, hasLength(2));
    expect(all.map((f) => f.reference),
        containsAll(['HAV-FIN-000001', 'HAV-FIN-000002']));

    final totalEntrees = all
        .where((f) => f.transactionType == TransactionType.entree)
        .fold(0.0, (sum, f) => sum + f.amount);
    final totalSorties = all
        .where((f) => f.transactionType == TransactionType.sortie)
        .fold(0.0, (sum, f) => sum + f.amount);
    expect(totalEntrees, 50000);
    expect(totalSorties, 20000);
    expect(totalEntrees - totalSorties, 30000);
  });

  test('modification et suppression douce fonctionnent', () async {
    await repository.create(
      transactionDate: DateTime.now(),
      transactionType: TransactionType.entree,
      description: 'Transaction test',
      amount: 1000,
      status: TransactionStatus.enAttente,
      periodMonth: '2026-09',
      updatedBy: 'test-uid',
    );
    final finance = (await repository.watchAll().first).first;

    await repository.update(
      id: finance.id,
      transactionDate: finance.transactionDate,
      transactionType: finance.transactionType,
      description: 'Transaction modifiée',
      amount: 1500,
      status: TransactionStatus.valide,
      periodMonth: finance.periodMonth,
      updatedBy: 'test-uid',
    );
    final updated = (await repository.watchAll().first).first;
    expect(updated.description, 'Transaction modifiée');
    expect(updated.amount, 1500);
    expect(updated.status, TransactionStatus.valide);
    expect(updated.reference, finance.reference);

    await repository.delete(finance.id);
    final afterDelete = await repository.watchAll().first;
    expect(afterDelete, isEmpty);
  });
}
