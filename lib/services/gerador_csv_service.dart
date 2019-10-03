import 'dart:io';
import 'package:pmsbmibile3/naosuportato/open_file.dart'
    if (dart.library.io) 'package:open_file/open_file.dart';

import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:pmsbmibile3/models/models.dart';

class GeradorCsvService {
  // PUBLIC
  static generateCsvFromUsuarioModel(UsuarioModel usuarioModel) async {
    List<List<dynamic>> colunas = List<List<dynamic>>();

    //adicionar Colunas
    List<dynamic> colunaHead = List();
    colunaHead.add("Item");
    colunaHead.add("Valor");
    colunas.add(colunaHead);

    List<dynamic> colunaFoto = List();
    colunaFoto.add("Foto");
    colunaFoto.add("${usuarioModel.foto.url}");
    colunas.add(colunaFoto);

    List<dynamic> colunaId = List();
    colunaId.add("Id");
    colunaId.add("${usuarioModel.id}");
    colunas.add(colunaId);

    List<dynamic> colunaNome = List();
    colunaNome.add("Nome");
    colunaNome.add("${usuarioModel.nome}");
    colunas.add(colunaNome);

    List<dynamic> colunaCelular = List();
    colunaCelular.add("Celular");
    colunaCelular.add("${usuarioModel.celular}");
    colunas.add(colunaCelular);

    List<dynamic> colunaEmail = List();
    colunaEmail.add("Email");
    colunaEmail.add("${usuarioModel.email}");
    colunas.add(colunaEmail);

    List<dynamic> colunaEixo = List();
    colunaEixo.add("Eixo");
    colunaEixo.add("${usuarioModel.eixoID.nome}");
    colunas.add(colunaEixo);

    //gerar e salvar
    var csvDirectory = (await getExternalStorageDirectory()).path + "/";
    var fileDirectory = "$csvDirectory";
    String filename = "filename.csv";
    await _salvarArquivoCsv(colunas, filename, fileDirectory);
    await _openFileFromDirectory(filename, fileDirectory);
  }

  //PRIVATE
  static Future<File> _salvarArquivoCsv(
      List<List<dynamic>> rows, String filename, String fileDirectory) async {
    String csvData = ListToCsvConverter().convert(rows, fieldDelimiter: ';');

    File csvFile = new File(fileDirectory + "filename.csv");
    await csvFile.writeAsString(csvData);
    return csvFile;
  }

  static _openFileFromDirectory(String filename, String fileDirectory) async {
    await OpenFile.open(fileDirectory + filename,
        type:
            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
  }
}
