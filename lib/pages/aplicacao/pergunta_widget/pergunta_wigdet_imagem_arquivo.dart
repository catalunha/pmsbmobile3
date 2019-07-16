import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:pmsbmibile3/models/arquivo_local_model.dart';

enum ArquivoTipo { image, aplication }


class PerguntaWigdetImagemArquivo extends StatefulWidget {
  final ArquivoTipo arquivoTipo;

  PerguntaWigdetImagemArquivo({Key key, @required this.arquivoTipo})
      : super(key: key);

  @override
  _PerguntaWigdetImagemArquivoState createState() =>
      _PerguntaWigdetImagemArquivoState();
}

class _PerguntaWigdetImagemArquivoState
    extends State<PerguntaWigdetImagemArquivo> {
  ArquivoLocalListModel arquivos = new ArquivoLocalListModel();

  String _mensageaquivo = "Adicionar um novo arquivo :";
  String _mensageimagem = "Adicionar uma nova imagem :";

  FileType _pickingType = FileType.ANY;

  var newfilepath;
  var file;

  @override
  void initState() {
    super.initState();
  }

  void _selecionarNovosArquivos() async {
    newfilepath = null;
    try {
      newfilepath = await FilePicker.getMultiFilePath(type: _pickingType);
      if (newfilepath != null) {
        setState(() {
          arquivos.setNovosArquivo(newfilepath);
        });
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    //if (!mounted) return;
  }

  _listTileArquivo(ArquivoLocalModel arquivo) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(arquivo.endereco),
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          //apagar esta imagem
          setState(() {
            arquivos.removerArquivoLista(arquivo);
          });
        },
      ),
      title: Text(arquivo.nome),
      subtitle: Text("Tipo: Imagem"),
    );
  }

  Widget makeRadioTiles() {
    Set<Widget> list = new Set<Widget>();
    var lista = arquivos.getListaAquivos();

    for (int i = 0; i < lista.length; i++) {
      list.add(_listTileArquivo(arquivos.getArquivoPorIndex(i)));
    }

    Column column = new Column(
      children: list.toList(),
    );
    return column;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: <Widget>[
      ListTile(
          title: Text("${widget.arquivoTipo == ArquivoTipo.aplication ? _mensageaquivo: _mensageimagem}"),
          trailing: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _selecionarNovosArquivos();
            },
          )),
      makeRadioTiles()
    ]));
  }
}
