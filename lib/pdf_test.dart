import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

Future<File> pdfTest() async {
  final doc = pw.Document();

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(24),
      header: (context) => pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('Header'),
          pw.Text('p. ${context.pageNumber}/${context.pagesCount}'),
        ],
      ),
      footer: (context) => pw.Center(child: pw.Text('Footer')),
      build: (context) => [
        pw.Text('Hello, world!'),
        pw.SizedBox(height: 12),
        pw.Text('This is a sample PDF document.'),
      ],
    ),
  );

  final bytes = await doc.save();

  // 1) Salvar em local acessível da app
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/sample.pdf');
  await file.writeAsBytes(bytes, flush: true);

  // 2) (Opcional) abrir/compartilhar direto sem salvar em Downloads
  // await Printing.sharePdf(bytes: bytes, filename: 'sample.pdf');
  // await Printing.layoutPdf(onLayout: (_) async => bytes); // preview nativo

  return file;
}
