import 'dart:typed_data';

import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Génère le PDF d'un reçu de paiement HAVENA.
class RecuPdfGenerator {
  static const _green = PdfColor.fromInt(0xFF1E7A4B);
  static const _orange = PdfColor.fromInt(0xFFE8792E);
  static const _grey = PdfColor.fromInt(0xFF6B7280);

  static Future<Uint8List> generate({
    required Finance finance,
    String? clientName,
    String? prestataireName,
  }) async {
    final pdf = pw.Document();

    final receivedFrom = finance.transactionType == TransactionType.entree
        ? (clientName ?? 'HAVENA')
        : (prestataireName ?? 'HAVENA');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildHeader(finance),
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
          _buildSectionTitle('Reçu N° ${finance.reference}'),
          pw.SizedBox(height: 8),
          _infoRow('Date', _formatDate(finance.transactionDate)),
          pw.SizedBox(height: 12),
          _infoRow('Reçu de/pour', receivedFrom),
          pw.SizedBox(height: 20),
          _buildSectionTitle('Détail'),
          _infoRow('Description', finance.description),
          _infoRow('Période', finance.periodMonth),
          _infoRow(
              'Mode de paiement', finance.paymentMethod ?? 'Non renseigné'),
          pw.SizedBox(height: 20),
          pw.Text(
            '${finance.amount.toStringAsFixed(2)} FCFA',
            style: pw.TextStyle(
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
              color: _orange,
            ),
          ),
          pw.SizedBox(height: 12),
          _infoRow('Statut', finance.status.name),
          if (finance.observations != null &&
              finance.observations!.trim().isNotEmpty) ...[
            pw.SizedBox(height: 20),
            _buildTextSection('Observations', finance.observations),
          ],
          pw.SizedBox(height: 20),
          pw.Text(
            'Reçu établi le ${_formatDate(DateTime.now())}',
            style: const pw.TextStyle(fontSize: 10, color: _grey),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader(Finance finance) {
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
                'Reçu de paiement',
                style: const pw.TextStyle(fontSize: 12, color: _grey),
              ),
            ],
          ),
          pw.Text(
            finance.reference,
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
}
