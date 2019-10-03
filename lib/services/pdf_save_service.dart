import 'dart:io';
import 'package:pmsbmibile3/naosuportato/path_provider.dart'
    if (dart.library.io) 'package:path_provider/path_provider.dart';
import 'package:pmsbmibile3/naosuportato/open_file.dart'
    if (dart.library.io) 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart';

class PdfSaveService {
  // PUBLIC

  static generatePdfAndOpen(Document pdf) async {
    var fileName = "Relatorio";
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
    return generatedPdfFile;
  }

  static _openFileFromDirectory(Directory pdfDirectory, String filename) async {
    await OpenFile.open("${pdfDirectory.path}/$filename.pdf",
        type: 'application/pdf');
  }
}
