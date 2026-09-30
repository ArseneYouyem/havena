import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:havena/core/sync/business_sheet_headers.dart';
import 'package:havena/core/sync/entity_sync_adapter.dart';
import 'package:havena/core/sync/sheet_row_builder.dart';

/// Génère la « vue tableur » Google Sheets décidée avec l'utilisateur
/// (cahier des charges §2/§9) : un classeur unique « HAVENA », un onglet
/// par module, régénéré à chaque synchronisation, **en lecture seule**
/// (jamais réinjecté dans l'app — voir `CLAUDE.md`, section synchronisation).
///
/// Réutilise les `EntitySyncAdapter` déjà branchés sur Firestore pour
/// obtenir les données locales (`allLocal()`/`toFirestoreMap()`), sans
/// dupliquer d'accès aux repositories.
///
/// **Limite de test connue** : nécessite un vrai client Firestore/Sheets
/// authentifié, même limite que `FirestoreSyncGateway`/`GoogleDriveAuthService`
/// (non testable dans `flutter test`). `buildSheetRows` (logique pure
/// d'extraction des lignes) est testé séparément.
class GoogleSheetsExportService {
  static const String _spreadsheetTitle = 'HAVENA';

  Future<String> ensureSpreadsheet(
    sheets.SheetsApi sheetsApi,
    drive.DriveApi driveApi,
  ) async {
    final query = "name = '$_spreadsheetTitle' and "
        "mimeType = 'application/vnd.google-apps.spreadsheet' and "
        'trashed = false';
    final result = await driveApi.files.list(
      q: query,
      spaces: 'drive',
      $fields: 'files(id,name)',
    );
    final existing = result.files;
    if (existing != null && existing.isNotEmpty) {
      return existing.first.id!;
    }

    final created = await sheetsApi.spreadsheets.create(
      sheets.Spreadsheet(
        properties: sheets.SpreadsheetProperties(title: _spreadsheetTitle),
      ),
    );
    return created.spreadsheetId!;
  }

  Future<void> _ensureTab(
    sheets.SheetsApi api,
    String spreadsheetId,
    String tabTitle,
  ) async {
    final spreadsheet = await api.spreadsheets.get(spreadsheetId);
    final exists = spreadsheet.sheets
            ?.any((sheet) => sheet.properties?.title == tabTitle) ??
        false;
    if (exists) return;

    await api.spreadsheets.batchUpdate(
      sheets.BatchUpdateSpreadsheetRequest(requests: [
        sheets.Request(
          addSheet: sheets.AddSheetRequest(
            properties: sheets.SheetProperties(title: tabTitle),
          ),
        ),
      ]),
      spreadsheetId,
    );
  }

  Future<void> _writeTable(
    sheets.SheetsApi api,
    String spreadsheetId,
    String tabTitle,
    List<String> headers,
    List<List<Object?>> rows,
  ) async {
    await _ensureTab(api, spreadsheetId, tabTitle);

    await api.spreadsheets.values.clear(
      sheets.ClearValuesRequest(),
      spreadsheetId,
      "'$tabTitle'!A1:Z20000",
    );

    await api.spreadsheets.values.update(
      sheets.ValueRange(values: [headers, ...rows]),
      spreadsheetId,
      "'$tabTitle'!A1",
      valueInputOption: 'RAW',
    );
  }

  /// Régénère l'onglet d'un module à partir de son adaptateur de
  /// synchronisation. `adapter.collectionName` doit exister dans
  /// [businessSheetHeaders]/[businessSheetTabTitles].
  Future<void> exportEntity(
    sheets.SheetsApi api,
    String spreadsheetId,
    EntitySyncAdapter adapter,
  ) async {
    final headers = businessSheetHeaders[adapter.collectionName];
    final tabTitle = businessSheetTabTitles[adapter.collectionName];
    if (headers == null || tabTitle == null) return;

    final rows = await adapter.allLocal();
    final documents = rows.map((row) => adapter.toFirestoreMap(row)).toList();
    final sheetRows = buildSheetRows(documents, headers);

    await _writeTable(api, spreadsheetId, tabTitle, headers, sheetRows);
  }
}
