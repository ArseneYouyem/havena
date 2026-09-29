import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis_auth/googleapis_auth.dart';

/// Charge l'identifiant OAuth « Desktop app » exporté depuis la console
/// Google Cloud (`google_drive_credentials.json`, jamais commité — voir
/// `google_drive_credentials.example.json` pour le format attendu),
/// embarqué comme asset Flutter pour être disponible dans le binaire
/// packagé, pas seulement en environnement de développement.
class GoogleDriveCredentialsLoader {
  static const String _assetPath = 'google_drive_credentials.json';

  Future<ClientId> load() async {
    final raw = await rootBundle.loadString(_assetPath);
    return parseCredentials(raw);
  }
}

/// Extrait de la logique de [GoogleDriveCredentialsLoader.load] pour rester
/// testable sans dépendre de `rootBundle` (indisponible hors contexte
/// Flutter) ni du fichier réel de secrets (propre à chaque machine,
/// jamais commité).
ClientId parseCredentials(String rawJson) {
  final json = jsonDecode(rawJson) as Map<String, dynamic>;
  final installed = json['installed'] as Map<String, dynamic>?;
  if (installed == null) {
    throw Exception(
        'Le JSON ne contient pas de section "installed" (identifiant OAuth de type "Desktop app" attendu).');
  }
  final clientId = installed['client_id'] as String?;
  final clientSecret = installed['client_secret'] as String?;
  if (clientId == null || clientSecret == null) {
    throw Exception('Le JSON doit contenir "client_id" et "client_secret".');
  }
  return ClientId(clientId, clientSecret);
}
