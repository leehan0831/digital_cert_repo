import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> generateCertificatePDF({
  required String recipient,
  required String organization,
  required String purpose,
  required String issueDate,
  required String expiryDate,
}) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Container(
          padding: pw.EdgeInsets.all(32),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 2),
          ),
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                'Certificate of Achievement',
                style: pw.TextStyle(
                  fontSize: 28,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Presented to',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                recipient,
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text('For: $purpose', style: pw.TextStyle(fontSize: 16)),
              pw.Text(
                'Organization: $organization',
                style: pw.TextStyle(fontSize: 16),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Issued on: $issueDate'),
              pw.Text('Valid until: $expiryDate'),
              pw.SizedBox(height: 30),
              pw.Align(
                alignment: pw.Alignment.bottomRight,
                child: pw.Text(
                  'Authorized Signature',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontStyle: pw.FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );

  return pdf.save();
}
