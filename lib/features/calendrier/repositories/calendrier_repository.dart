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
}
