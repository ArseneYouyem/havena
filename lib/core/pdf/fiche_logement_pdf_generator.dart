import 'dart:typed_data';

import 'package:havena/core/database/app_database.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Génère le PDF de la fiche logement HAVENA.
class FicheLogementPdfGenerator {
  static const _green = PdfColor.fromInt(0xFF1E7A4B);
  static const _orange = PdfColor.fromInt(0xFFE8792E);
  static const _grey = PdfColor.fromInt(0xFF6B7280);

  static Future<Uint8List> generate({
    required Logement logement,
    String? clientName,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) =>
            _buildHeader(logement.reference, 'Fiche logement'),
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
          _buildSectionTitle('Identité'),
          _buildInfoBlock([
            _infoRow('Référence', logement.reference),
            _infoRow('Adresse', logement.address),
            _infoRow('Quartier', logement.neighborhood ?? 'Non renseigné'),
            _infoRow(
                'Type de logement', logement.housingType ?? 'Non renseigné'),
            _infoRow(
                'Chambres', _formatIntOrPlaceholder(logement.bedroomsCount)),
            _infoRow('Occupation', logement.occupancy ?? 'Non renseigné'),
            _infoRow('Client', clientName ?? 'Non renseigné'),
          ]),
          pw.SizedBox(height: 20),
          _buildSectionTitle('Accès'),
          _buildInfoBlock([
            _infoRow(
                'Contact local', logement.localContact ?? 'Non renseigné'),
            _infoRow('Gardien', logement.guardian ?? 'Non renseigné'),
            _infoRow('Clés', _formatIntOrPlaceholder(logement.keysCount)),
          ]),
          pw.SizedBox(height: 20),
          _buildSectionTitle('Équipements'),
          _buildInfoBlock([
            _infoRow('Équipements principaux',
                logement.mainEquipment ?? 'Non renseigné'),
          ]),
          pw.SizedBox(height: 20),
          _buildSectionTitle('Suivi'),
          _buildInfoBlock([
            _infoRow('Dernière inspection',
                _formatDateOrPlaceholder(logement.lastInspectionDate)),
            _infoRow('Prochaine inspection',
                _formatDateOrPlaceholder(logement.nextInspectionDate)),
            _infoRow('État général',
                logement.generalCondition?.name ?? 'Non renseigné'),
          ]),
          pw.SizedBox(height: 12),
          _buildTextSection('Notes', logement.notes),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader(String reference, String subtitle) {
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
                subtitle,
                style: const pw.TextStyle(fontSize: 12, color: _grey),
              ),
            ],
          ),
          pw.Text(
            reference,
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

  static pw.Widget _buildInfoBlock(List<pw.Widget> rows) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: rows,
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

  static pw.Widget _buildTextSection(String title, String? content) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 16),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(title),
          pw.Text(
            (content == null || content.trim().isEmpty)
                ? 'Aucune observation.'
                : content,
            style: const pw.TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  static String _formatDateOrPlaceholder(DateTime? d) {
    return d == null ? 'Non renseigné' : _formatDate(d);
  }

  static String _formatIntOrPlaceholder(int? value) {
    return value == null ? 'Non renseigné' : '$value';
  }
}
