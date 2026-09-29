import 'package:drift/drift.dart';
import 'package:havena/core/database/enums.dart';

class ModelesDocuments extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get documentType =>
      textEnum<DocumentTemplateType>().named('document_type')();

  TextColumn get contentTemplate =>
      text().named('content_template')();

  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true)).named('is_active')();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime).named('updated_at')();

  TextColumn get updatedBy => text().nullable().named('updated_by')();

  TextColumn get syncStatus => textEnum<SyncStatus>()
      .clientDefault(() => SyncStatus.local.name)
      .named('sync_status')();

  BoolColumn get isDeleted =>
      boolean().withDefault(const Constant(false)).named('is_deleted')();
}
