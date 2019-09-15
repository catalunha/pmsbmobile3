import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';

class PdfSaveService {
  // PUBLIC

  static generatePdfAndOpen(Document pdf) async {
    print('generatePdfAndOpen');

    var fileName = "pdfRelatorio";
    // final String htmlText = mkd.markdownToHtml(markdownString);
    Directory pdfDirectory = await getExternalStorageDirectory();
    await _generateAndSavePdf(pdf, pdfDirectory, fileName);
    await _openFileFromDirectory(pdfDirectory, fileName);
  }

  //PRIVATE

  static Future<File> _generateAndSavePdf(
      Document pdf, Directory pdfDirectory, String fileName) async {
    var targetPath = pdfDirectory.path;
    final generatedPdfFile = File("${targetPath}/${fileName}.pdf");
    await generatedPdfFile.writeAsBytes(pdf.save());
    print('_generateAndSavePdf ${generatedPdfFile.length()}');

    return generatedPdfFile;
  }

  static _openFileFromDirectory(Directory pdfDirectory, String filename) async {
    await OpenFile.open("${pdfDirectory.path}/$filename.pdf",
        type: 'application/pdf');
  }
}
