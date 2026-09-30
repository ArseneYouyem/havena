import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:havena/core/sync/shared_drive_token_gateway.dart';
import 'package:havena/features/calendrier/repositories/calendrier_repository.dart';

/// Pousse les évènements du module Calendrier HAVENA vers un calendrier
/// secondaire **« HAVENA »** du compte Google connecté (demande explicite
/// de l'utilisateur : que les évènements soient au moins visibles dans
/// Google Calendar, en plus du calendrier métier déjà synchronisé entre
/// appareils via Firestore — voir `CalendrierSyncAdapter`). Calendrier
/// secondaire dédié plutôt que le calendrier principal du compte, même
/// logique que le dossier Drive/le classeur Sheets « HAVENA » : ne pollue
/// pas le reste du compte, facile à afficher/masquer côté Google Calendar.
///
/// L'id du calendrier créé est mémorisé dans Firestore
/// (`SharedDriveTokenGateway.saveCalendarId`) plutôt que retrouvé par
/// recherche par nom à chaque synchronisation : la portée OAuth utilisée
/// (`calendar.app.created`, la plus restreinte possible — uniquement les
/// calendriers créés par l'app) ne garantit pas l'accès à
/// `calendarList.list()`, qui énumère TOUS les calendriers de l'utilisateur.
///
/// **Limite assumée** : ne gère pas encore la suppression côté Google
/// Calendar (un évènement supprimé localement, en suppression douce,
/// n'est plus retourné par `watchAll()` — cahier des charges §20, amélioration
/// future si le besoin se confirme). Un évènement déjà envoyé est mis à jour
/// à chaque synchronisation (pas seulement créé une fois), pour refléter les
/// modifications ultérieures.
///
/// **Limite de test connue** : nécessite un vrai client Calendar/Firestore
/// authentifié, même limite que `GoogleSheetsExportService`/
/// `FirestoreSyncGateway` (non testable dans `flutter test`).
class GoogleCalendarSyncService {
  GoogleCalendarSyncService(this._tokenGateway);

  final SharedDriveTokenGateway _tokenGateway;

  static const String _calendarName = 'HAVENA';

  Future<String> ensureCalendar(calendar.CalendarApi api) async {
    final existingId = await _tokenGateway.fetchCalendarId();
    if (existingId != null) return existingId;

    final created = await api.calendars.insert(
      calendar.Calendar(summary: _calendarName),
    );
    final calendarId = created.id!;
    await _tokenGateway.saveCalendarId(calendarId);
    return calendarId;
  }

  Future<void> syncEvents(
    calendar.CalendarApi api,
    String calendarId,
    CalendrierRepository repository,
  ) async {
    final events = await repository.watchAll().first;
    for (final event in events) {
      final body = calendar.Event(
        summary: event.title,
        description: event.relatedReference,
        start: calendar.EventDateTime(dateTime: event.eventDate.toUtc()),
        end: calendar.EventDateTime(
          dateTime: event.eventDate.toUtc().add(const Duration(hours: 1)),
        ),
      );

      final existingGoogleEventId = event.googleEventId;
      if (existingGoogleEventId == null) {
        final created = await api.events.insert(body, calendarId);
        await repository.markGoogleSynced(
          id: event.id,
          googleEventId: created.id!,
        );
      } else {
        await api.events.update(body, calendarId, existingGoogleEventId);
      }
    }
  }
}
