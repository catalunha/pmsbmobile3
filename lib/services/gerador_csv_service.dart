import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:pmsbmibile3/models/models.dart';

class GeradorCsvService {
  // PUBLIC
  static generateCsvFromUsuarioModel(UsuarioModel usuarioModel) async {
    List<List<dynamic>> colunas = List<List<dynamic>>();

    //Coluna com o nome das variaveis
    List<dynamic> colunaNomeValor = List();
    colunaNomeValor.add("Foto");
    colunaNomeValor.add("Id");
    colunaNomeValor.add("Nome");
    colunaNomeValor.add("Celular");
    colunaNomeValor.add("Email");
    colunaNomeValor.add("Eixo");
    colunas.add(colunaNomeValor);

    //coluna com os valores de usuarioModel
    List<dynamic> colunaValores = List();
    colunaValores.add("${usuarioModel.usuarioArquivoID.url}");
    colunaValores.add("${usuarioModel.id}");
    colunaValores.add("${usuarioModel.nome}");
    colunaValores.add("${usuarioModel.celular}");
    colunaValores.add("${usuarioModel.email}");
    colunaValores.add("${usuarioModel.eixoID.nome}");
    colunas.add(colunaValores);

    //gerar e salvar
    var csvDirectory = (await getExternalStorageDirectory()).absolute.path + "/documents";
    var fileDirectory = "$csvDirectory";
    String filename = "filename.csv";
    await _salvarArquivoCsv(colunas, filename, fileDirectory);
    await _openFileFromDirectory(filename, fileDirectory);
  }

  //PRIVATE
  static Future<File> _salvarArquivoCsv(List<List<dynamic>> rows, String filename, String fileDirectory) async {
    //String dir = (await getExternalStorageDirectory()).absolute.path + "/documents";
    //var file = "$dir";
    //File f = new File(file + "filename.csv");

    // convert rows to String and write as csv file

    //await f.writeAsString(csv);
    //await saveFile(file);

    String csvData = ListToCsvConverter().convert(rows);

    // var csvDirectory = await getExternalStorageDirectory();
    // var file = csvDirectory.path;
    // String filename = "planilha.csv";

    File csvFile = new File(fileDirectory + "filename.csv");
    await csvFile.writeAsString(csvData);
    return csvFile;
  }

  static _openFileFromDirectory(String filename, String fileDirectory) async {
    print('>>> fileDirectory >>> ${fileDirectory}');
    print('>>> filename >>> ${filename}');
    await OpenFile.open(fileDirectory + filename, type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
  }
}
