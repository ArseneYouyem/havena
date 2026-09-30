import 'package:drift/drift.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/daos/calendrier_evenements_dao.dart';
import 'package:havena/core/database/enums.dart';
import 'package:uuid/uuid.dart';

class CalendrierRepository {
  CalendrierRepository(this._dao);

  final CalendrierEvenementsDao _dao;

  Stream<List<CalendrierEvenement>> watchAll() => _dao.watchAll();

  Future<void> create({
    required CalendarEventType eventType,
    required String title,
    required DateTime eventDate,
    String? relatedReference,
    required CalendarEventStatus status,
    required String updatedBy,
  }) async {
    await _dao.insertOne(CalendrierEvenementsCompanion(
      syncId: Value(const Uuid().v4()),
      eventType: Value(eventType),
      title: Value(title),
      eventDate: Value(eventDate),
      relatedReference: Value(relatedReference),
      responsibleUserId: const Value(null),
      status: Value(status),
      updatedAt: Value(DateTime.now()),
      updatedBy: Value(updatedBy),
      syncStatus: Value(SyncStatus.local),
      isDeleted: const Value(false),
    ));
  }

  Future<void> update({
    required int id,
    required CalendarEventType eventType,
    required String title,
    required DateTime eventDate,
    String? relatedReference,
    required CalendarEventStatus status,
    required String updatedBy,
  }) async {
    final existing = await _dao.getById(id);
    if (existing == null) {
      throw Exception('Événement introuvable');
    }
    await _dao.updateOne(CalendrierEvenementsCompanion(
      id: Value(id),
      eventType: Value(eventType),
      title: Value(title),
      eventDate: Value(eventDate),
      relatedReference: Value(relatedReference),
      responsibleUserId: const Value(null),
      status: Value(status),
      updatedAt: Value(DateTime.now()),
      updatedBy: Value(updatedBy),
      syncStatus: Value(existing.syncStatus),
      isDeleted: const Value(false),
    ));
  }

  Future<void> delete(int id) => _dao.softDelete(id);

  /// Associe l'évènement local à l'évènement créé (ou mis à jour) dans le
  /// calendrier secondaire Google « HAVENA » (voir `GoogleCalendarSyncService`).
  /// Touche `updatedAt` pour que ce champ se propage aux autres appareils
  /// via la synchronisation Firestore habituelle (`CalendrierSyncAdapter`),
  /// et évite ainsi qu'un autre appareil recrée un doublon côté Google
  /// Calendar pour le même évènement.
  Future<void> markGoogleSynced({
    required int id,
    required String googleEventId,
  }) async {
    await _dao.updatePartial(
      id,
      CalendrierEvenementsCompanion(
        googleEventId: Value(googleEventId),
        updatedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.local),
      ),
    );
  }

  Future<CalendrierEvenement?> findBySyncId(String syncId) async {
    final all = await _dao.watchAll().first;
    for (final evenement in all) {
      if (evenement.syncId == syncId) return evenement;
    }
    return null;
  }

  /// Crée ou met à jour la ligne locale correspondant à [syncId] à partir
  /// d'un document Firestore générique (`CalendrierSyncAdapter.toFirestoreMap`
  /// pour le format exact). Utilisé uniquement par `SyncEngine` (pull et
  /// résolution de conflit) — jamais par l'UI.
  Future<void> upsertFromRemote({
    required String syncId,
    required Map<String, dynamic> data,
  }) async {
    final existing = await findBySyncId(syncId);
    final companion = CalendrierEvenementsCompanion(
      id: existing != null ? Value(existing.id) : const Value.absent(),
      syncId: Value(syncId),
      eventType:
          Value(CalendarEventType.values.byName(data['eventType'] as String)),
      title: Value(data['title'] as String),
      eventDate: Value(DateTime.parse(data['eventDate'] as String)),
      relatedReference: Value(data['relatedReference'] as String?),
      responsibleUserId: Value(data['responsibleUserId'] as int?),
      status: Value(
          CalendarEventStatus.values.byName(data['status'] as String)),
      updatedAt: Value(DateTime.parse(data['updatedAt'] as String)),
      updatedBy: Value(data['updatedBy'] as String?),
      isDeleted: Value(data['isDeleted'] as bool? ?? false),
      googleEventId: Value(data['googleEventId'] as String?),
      syncStatus: const Value(SyncStatus.synced),
    );
    if (existing != null) {
      await _dao.updateOne(companion);
    } else {
      await _dao.insertOne(companion);
    }
  }
}
