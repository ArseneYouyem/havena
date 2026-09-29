import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('insère et relit un client (valide le bundling natif SQLite)', () async {
    final id = await database.clientsDao.insertOne(
      ClientsCompanion.insert(
        reference: 'HAV-CLI-000001',
        fullName: 'Client Test',
        phone: '+237600000000',
        country: 'Cameroun',
        city: 'Douala',
        clientType: 'particulier',
        status: ClientStatus.actif,
      ),
    );

    final client = await database.clientsDao.getById(id);

    expect(client, isNotNull);
    expect(client!.reference, 'HAV-CLI-000001');
    expect(client.status, ClientStatus.actif);
    expect(client.isDeleted, isFalse);
  });

  test('soft delete marque isDeleted sans supprimer la ligne', () async {
    final id = await database.clientsDao.insertOne(
      ClientsCompanion.insert(
        reference: 'HAV-CLI-000002',
        fullName: 'Client À Supprimer',
        phone: '+237600000001',
        country: 'Cameroun',
        city: 'Yaoundé',
        clientType: 'particulier',
        status: ClientStatus.actif,
      ),
    );

    await database.clientsDao.softDelete(id);
    final client = await database.clientsDao.getById(id);

    expect(client, isNotNull);
    expect(client!.isDeleted, isTrue);
  });
}
