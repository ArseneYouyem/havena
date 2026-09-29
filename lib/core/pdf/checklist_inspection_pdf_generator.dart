import 'dart:typed_data';

import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/core/inspections/inspection_checklist.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ChecklistInspectionPdfGenerator {
  static const _green = PdfColor.fromInt(0xFF1E7A4B);
  static const _orange = PdfColor.fromInt(0xFFE8792E);
  static const _grey = PdfColor.fromInt(0xFF6B7280);

  static Future<Uint8List> generate({
    required Inspection inspection,
    required Logement logement,
    required List<InspectionItem> items,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildHeader(inspection),
        footer: (context) => pw.Padding(
          padding: const pw.EdgeInsets.only(top: 8),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'HAVENA by Royal L&T - Votre maison, notre responsabilité.',
                style: const pw.TextStyle(fontSize: 8, color: _grey),
              ),
              pw.Text(
                'Page ${context.pageNumber} / ${context.pagesCount}',
                style: const pw.TextStyle(fontSize: 8, color: _grey),
              ),
            ],
          ),
        ),
        build: (context) => [
          pw.SizedBox(height: 16),
          _buildInfoSection(inspection, logement),
          pw.SizedBox(height: 20),
          ..._buildChecklistSections(items),
          pw.SizedBox(height: 20),
          _buildRecommendationsSection(inspection),
          pw.SizedBox(height: 12),
          _buildValidationLine(inspection),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader(Inspection inspection) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 12),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: _green, width: 2)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'HAVENA',
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                  color: _green,
                ),
              ),
              pw.Text(
                "Checklist d'inspection",
                style: const pw.TextStyle(fontSize: 12, color: _grey),
              ),
            ],
          ),
          pw.Text(
            inspection.reference,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: _orange,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildInfoSection(
      Inspection inspection, Logement logement) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _infoRow('Inspection', inspection.reference),
          _infoRow('Logement', '${logement.reference} - ${logement.address}'),
          _infoRow('Date inspection', _formatDate(inspection.inspectionDate)),
          _infoRow(
            'État général',
            inspection.generalCondition?.name ?? 'Non renseigné',
          ),
        ],
      ),
    );
  }

  static List<pw.Widget> _buildChecklistSections(List<InspectionItem> items) {
    final sections = <pw.Widget>[];

    for (final category in InspectionCategory.values) {
      final categoryItems =
          items.where((item) => item.category == category).toList();
      if (categoryItems.isEmpty) continue;

      sections.add(
        _buildSectionTitle(InspectionChecklist.categoryLabels[category]!),
      );

      for (final item in categoryItems) {
        sections.add(_buildItemRow(item));
      }

      sections.add(pw.SizedBox(height: 8));
    }

    return sections;
  }

  static pw.Widget _buildItemRow(InspectionItem item) {
    final String statusText;
    final PdfColor statusColor;
    if (item.isOk == true) {
      statusText = 'OK';
      statusColor = _green;
    } else if (item.isOk == false) {
      statusText = 'Problème';
      statusColor = _orange;
    } else {
      statusText = 'Non vérifié';
      statusColor = _grey;
    }

    return pw.Padding(
      padding: const pw.EdgeInsets.only(left: 8, bottom: 6),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.Text(
                  item.label,
                  style: const pw.TextStyle(fontSize: 11),
                ),
              ),
              pw.SizedBox(width: 12),
              pw.Text(
                statusText,
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ],
          ),
          if (item.observation != null && item.observation!.trim().isNotEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 2, left: 12),
              child: pw.Text(
                item.observation!,
                style: pw.TextStyle(
                  fontSize: 10,
                  fontStyle: pw.FontStyle.italic,
                  color: _grey,
                ),
              ),
            ),
        ],
      ),
    );
  }

  static pw.Widget _buildRecommendationsSection(Inspection inspection) {
    final recommendations = inspection.recommendations;
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 16),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Recommandations'),
          pw.Text(
            (recommendations == null || recommendations.trim().isEmpty)
                ? 'Aucune recommandation.'
                : recommendations,
            style: const pw.TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildValidationLine(Inspection inspection) {
    final String text;
    final PdfColor color;
    if (inspection.isValidated && inspection.validatedAt != null) {
      text = 'Inspection validée le ${_formatDate(inspection.validatedAt!)}';
      color = _green;
    } else if (inspection.isValidated) {
      text = 'Inspection validée';
      color = _green;
    } else {
      text = 'Inspection non validée';
      color = _orange;
    }

    return pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 11,
        fontWeight: pw.FontWeight.bold,
        color: color,
      ),
    );
  }

  static pw.Widget _infoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 90,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
                color: _grey,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(value, style: const pw.TextStyle(fontSize: 10)),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSectionTitle(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 13,
          fontWeight: pw.FontWeight.bold,
          color: _green,
        ),
      ),
    );
  }

  static String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }
}
