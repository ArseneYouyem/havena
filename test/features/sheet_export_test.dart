import 'package:flutter_test/flutter_test.dart';
import 'package:havena/core/sync/business_sheet_headers.dart';
import 'package:havena/core/sync/sheet_row_builder.dart';

void main() {
  group('buildSheetRows', () {
    test('extrait les colonnes demandées dans l\'ordre des headers', () {
      final documents = [
        {'reference': 'HAV-CLI-000001', 'fullName': 'Alice', 'phone': '600'},
        {'reference': 'HAV-CLI-000002', 'fullName': 'Bob', 'phone': '601'},
      ];

      final rows =
          buildSheetRows(documents, ['reference', 'fullName', 'phone']);

      expect(rows, [
        ['HAV-CLI-000001', 'Alice', '600'],
        ['HAV-CLI-000002', 'Bob', '601'],
      ]);
    });

    test('remplace les valeurs nulles par une chaîne vide (pas absentes)',
        () {
      final documents = [
        {'reference': 'HAV-CLI-000003', 'email': null},
      ];

      final rows = buildSheetRows(documents, ['reference', 'email']);

      expect(rows, [
        ['HAV-CLI-000003', ''],
      ]);
    });

    test('ignore les champs du document non listés dans headers', () {
      final documents = [
        {'reference': 'HAV-CLI-000004', 'fullName': 'Chloé', 'secret': 'x'},
      ];

      final rows = buildSheetRows(documents, ['reference', 'fullName']);

      expect(rows, [
        ['HAV-CLI-000004', 'Chloé'],
      ]);
    });

    test('conserve les booléens et les nombres tels quels', () {
      final documents = [
        {'inspectionDone': true, 'amount': 15000.5},
      ];

      final rows = buildSheetRows(documents, ['inspectionDone', 'amount']);

      expect(rows, [
        [true, 15000.5],
      ]);
    });
  });

  group('businessSheetHeaders / businessSheetTabTitles', () {
    const expectedCollections = [
      'clients',
      'logements',
      'prestataires',
      'abonnements',
      'interventions',
      'finances',
      'rapports',
      'inspections',
      'calendrier_evenements',
    ];

    test('couvrent les 9 modules métier synchronisés, sans en oublier',
        () {
      expect(businessSheetHeaders.keys.toSet(), expectedCollections.toSet());
      expect(
          businessSheetTabTitles.keys.toSet(), expectedCollections.toSet());
    });

    test('chaque module a au moins une colonne "reference" ou "title"', () {
      for (final entry in businessSheetHeaders.entries) {
        expect(
          entry.value.contains('reference') || entry.value.contains('title'),
          isTrue,
          reason:
              '${entry.key} devrait afficher sa référence ou son titre en premier repère',
        );
      }
    });
  });
}
