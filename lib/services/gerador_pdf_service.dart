import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:markdown/markdown.dart' as mkd;
import 'package:pmsbmibile3/naosuportato/flutter_html_to_pdf.dart'
    if (dart.library.io) 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';

class GeradorPdfService {
  // PUBLIC

  static generatePdfFromMd(String markdownString) async {
    var fileName = "pdftestfile";
    final String htmlText = mkd.markdownToHtml(markdownString);
    Directory pdfDirectory = await getExternalStorageDirectory();
    await _generateAndSavePdfFromHtml(htmlText, pdfDirectory, fileName);
    await _openFileFromDirectory(pdfDirectory.path, fileName);
  }

  //PRIVATE

  static Future<File> _generateAndSavePdfFromHtml(
      String htmlContent, Directory pdfDirectory, String fileName) async {
    var targetPath = pdfDirectory.path;
    File generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
        htmlContent, targetPath, fileName);
    return generatedPdfFile;
  }

  static _openFileFromDirectory(String path, String filename) async {
    await OpenFile.open("$path/$filename.pdf", type: 'application/pdf');
  }
}
