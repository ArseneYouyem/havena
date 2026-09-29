import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Génère le PDF de la procédure interne du coordinateur (cahier des
/// charges §15) : document statique, sans entité liée.
class ProcedureCoordinateurPdfGenerator {
  static const _green = PdfColor.fromInt(0xFF1E7A4B);
  static const _orange = PdfColor.fromInt(0xFFE8792E);
  static const _grey = PdfColor.fromInt(0xFF6B7280);

  static const _steps = [
    'Identifier le client.',
    'Identifier le logement.',
    'Enregistrer la demande.',
    "Attribuer une référence d'intervention.",
    "Évaluer l'urgence.",
    'Sélectionner le prestataire.',
    'Obtenir le devis.',
    'Faire valider le client.',
    "Planifier l'intervention.",
    "Suivre l'intervention.",
    'Vérifier le résultat.',
    'Enregistrer le paiement.',
    'Mettre à jour le dossier.',
    'Demander la satisfaction du client.',
    'Archiver les photos et documents.',
  ];

  static Future<Uint8List> generate() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildHeader(),
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
          pw.Text(
            'Étapes à suivre lorsqu\'un client contacte HAVENA :',
            style: const pw.TextStyle(fontSize: 11, color: _grey),
          ),
          pw.SizedBox(height: 16),
          for (var i = 0; i < _steps.length; i++) _buildStepRow(i + 1, _steps[i]),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader() {
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
                'Procédure du coordinateur',
                style: const pw.TextStyle(fontSize: 12, color: _grey),
              ),
            ],
          ),
          pw.Text(
            'Document interne',
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

  static pw.Widget _buildStepRow(int number, String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 22,
            height: 22,
            alignment: pw.Alignment.center,
            decoration: pw.BoxDecoration(
              color: _green,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(11)),
            ),
            child: pw.Text(
              '$number',
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
            ),
          ),
          pw.SizedBox(width: 10),
          pw.Expanded(
            child: pw.Text(text, style: const pw.TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }
}
