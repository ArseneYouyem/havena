import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';

import 'package:havena/main.dart';

void main() {
  testWidgets('HavenApp affiche le tableau de bord au démarrage', (
    WidgetTester tester,
  ) async {
    await GetStorage.init();

    await tester.pumpWidget(const HavenApp());
    await tester.pumpAndSettle();

    expect(find.text('HAVENA'), findsOneWidget);
    expect(find.text('Tableau de bord'), findsOneWidget);
  });
}
