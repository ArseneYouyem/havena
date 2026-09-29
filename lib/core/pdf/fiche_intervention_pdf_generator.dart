import 'dart:typed_data';

import 'package:havena/core/database/app_database.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class FicheInterventionPdfGenerator {
  static const _green = PdfColor.fromInt(0xFF1E7A4B);
  static const _orange = PdfColor.fromInt(0xFFE8792E);
  static const _grey = PdfColor.fromInt(0xFF6B7280);

  static Future<Uint8List> generate({
    required Intervention intervention,
    required Logement logement,
    String? clientName,
    String? prestataireName,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildHeader(intervention.reference),
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
          _infoRow('Référence', intervention.reference),
          _infoRow('Logement', logement.address),
          _infoRow('Client', clientName ?? 'Non renseigné'),
          pw.SizedBox(height: 20),
          _buildSectionTitle('Problème'),
          pw.Text(
            intervention.problemDescription,
            style: const pw.TextStyle(fontSize: 11),
          ),
          _infoRow('Catégorie', intervention.category ?? 'Non renseignée'),
          _infoRow('Urgence', intervention.urgencyLevel.name),
          pw.SizedBox(height: 20),
          _buildSectionTitle('Prestataire'),
          pw.Text(
            prestataireName ?? 'Non attribué',
            style: const pw.TextStyle(fontSize: 11),
          ),
          pw.SizedBox(height: 20),
          _buildSectionTitle('Planification'),
          _infoRow(
            "Date d'intervention",
            intervention.interventionDate != null
                ? _formatDate(intervention.interventionDate!)
                : 'Non planifiée',
          ),
          pw.SizedBox(height: 20),
          _buildSectionTitle('Financier'),
          _infoRow('Devis', _formatAmount(intervention.quoteAmount)),
          _infoRow('Montant client', _formatAmount(intervention.clientAmount)),
          _infoRow(
            'Montant prestataire',
            _formatAmount(intervention.prestataireAmount),
          ),
          _infoRow('Marge HAVENA', _formatAmount(intervention.havenaMargin)),
          pw.SizedBox(height: 20),
          _buildSectionTitle('Suivi'),
          _infoRow('Statut', intervention.status.name),
          _infoRow(
            'Validé par le client',
            intervention.clientValidated ? '[Oui]' : '[Non]',
          ),
          if (intervention.clientSatisfaction != null)
            _infoRow(
                'Satisfaction client', '${intervention.clientSatisfaction}/5'),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader(String reference) {
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
                'Fiche intervention',
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

  static pw.Widget _infoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 120,
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

  static String _formatAmount(double? value) {
    return value != null ? '${value.toStringAsFixed(2)} FCFA' : 'Non renseigné';
  }
}
