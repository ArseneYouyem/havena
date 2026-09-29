import 'dart:typed_data';

import 'package:havena/core/database/app_database.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Génère le PDF d'un contrat d'abonnement HAVENA.
class ContratAbonnementPdfGenerator {
  static const _green = PdfColor.fromInt(0xFF1E7A4B);
  static const _orange = PdfColor.fromInt(0xFFE8792E);
  static const _grey = PdfColor.fromInt(0xFF6B7280);

  static Future<Uint8List> generate({
    required Abonnement abonnement,
    required Client client,
    required Logement logement,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildHeader(abonnement),
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
          _buildContractNumberSection(abonnement),
          pw.SizedBox(height: 20),
          _buildPartiesSection(client, logement),
          pw.SizedBox(height: 20),
          _buildObjetSection(abonnement, logement),
          pw.SizedBox(height: 20),
          _buildConditionsFinancieresSection(abonnement),
          pw.SizedBox(height: 20),
          _buildEngagementsSection(),
          pw.SizedBox(height: 30),
          _buildSignatureSection(),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader(Abonnement abonnement) {
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
                "Contrat d'abonnement",
                style: const pw.TextStyle(fontSize: 12, color: _grey),
              ),
            ],
          ),
          pw.Text(
            abonnement.reference,
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

  static pw.Widget _buildContractNumberSection(Abonnement abonnement) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _infoRow('Contrat N°', abonnement.reference),
          _infoRow('Date de début', _formatDate(abonnement.startDate)),
        ],
      ),
    );
  }

  static pw.Widget _buildPartiesSection(Client client, Logement logement) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Parties'),
        pw.Text(
          'Entre HAVENA by Royal L&T, ci-après « le Prestataire »,',
          style: const pw.TextStyle(fontSize: 11),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          'Et ${client.fullName}, domicilié(e) à ${logement.address}, ci-après « le Client ».',
          style: const pw.TextStyle(fontSize: 11),
        ),
      ],
    );
  }

  static pw.Widget _buildObjetSection(
      Abonnement abonnement, Logement logement) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Objet'),
        _infoRow("Formule d'abonnement", abonnement.formula),
        _infoRow('Logement concerné',
            '${logement.reference} - ${logement.address}'),
      ],
    );
  }

  static pw.Widget _buildConditionsFinancieresSection(Abonnement abonnement) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Conditions financières'),
        _infoRow(
          'Prix mensuel',
          '${abonnement.monthlyPrice.toStringAsFixed(2)} FCFA / mois',
        ),
        if (abonnement.renewalDate != null)
          _infoRow(
              'Date de renouvellement', _formatDate(abonnement.renewalDate!)),
      ],
    );
  }

  static pw.Widget _buildEngagementsSection() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Engagements'),
        _buildBullet("Visites d'inspection régulières du logement"),
        _buildBullet('Gestion des interventions nécessaires'),
        _buildBullet('Rapport mensuel de suivi'),
      ],
    );
  }

  static pw.Widget _buildBullet(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(left: 12, bottom: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('- ', style: const pw.TextStyle(fontSize: 11)),
          pw.Expanded(
            child: pw.Text(text, style: const pw.TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSignatureSection() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Container(
          width: 200,
          height: 80,
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Le Client',
                  style: pw.TextStyle(
                      fontSize: 11, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 40),
            ],
          ),
        ),
        pw.Container(
          width: 200,
          height: 80,
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('HAVENA',
                  style: pw.TextStyle(
                      fontSize: 11, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 40),
            ],
          ),
        ),
      ],
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
}
