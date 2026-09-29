import 'package:flutter_test/flutter_test.dart';
import 'package:havena/core/sync/google_drive_credentials_loader.dart';
import 'package:havena/core/sync/google_drive_sync_service.dart';

// GoogleDriveTokenCache (GetStorage) n'est volontairement pas testé ici :
// get_storage appelle inconditionnellement path_provider même quand un
// `path` explicite est fourni, ce qui lève un MissingPluginException dans
// `flutter test` (même limitation que Firebase — voir widget_test.dart).
// À vérifier manuellement via un vrai lancement de l'app.

void main() {
  group('parseCredentials', () {
    test('extrait client_id et client_secret d\'un JSON "installed" valide',
        () {
      const raw = '''
      {
        "installed": {
          "client_id": "123.apps.googleusercontent.com",
          "client_secret": "SECRET",
          "redirect_uris": ["http://localhost"]
        }
      }
      ''';

      final clientId = parseCredentials(raw);

      expect(clientId.identifier, '123.apps.googleusercontent.com');
      expect(clientId.secret, 'SECRET');
    });

    test('lève une exception si la section "installed" est absente', () {
      const raw = '{"web": {"client_id": "123"}}';
      expect(() => parseCredentials(raw), throwsException);
    });

    test('lève une exception si client_id ou client_secret manque', () {
      const raw = '{"installed": {"client_id": "123"}}';
      expect(() => parseCredentials(raw), throwsException);
    });
  });

  group('driveContentTypeFor', () {
    test('reconnaît .png, .pdf et retombe sur image/jpeg par défaut', () {
      expect(driveContentTypeFor('photo.png'), 'image/png');
      expect(driveContentTypeFor('RAPPORT.PDF'), 'application/pdf');
      expect(driveContentTypeFor('photo.jpg'), 'image/jpeg');
      expect(driveContentTypeFor('sans_extension'), 'image/jpeg');
    });
  });

  group('escapeDriveQueryValue', () {
    test('échappe les apostrophes pour une requête Drive q=...', () {
      expect(escapeDriveQueryValue("HAV-DLA-000001"), "HAV-DLA-000001");
      expect(escapeDriveQueryValue("dossier d'un logement"),
          "dossier d\\'un logement");
    });
  });
}
