import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:pmsbmibile3/models/arquivo_local_model.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart';
import 'package:flutter/rendering.dart';

import 'dart:io';
import 'dart:isolate';
import 'package:image/image.dart' as img;

enum ArquivoTipo { image, aplication }

class DecodeParam {
  final File file;
  final SendPort sendPort;
  DecodeParam(this.file, this.sendPort);
}

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
  //o objeto ArquivoLocalListModel tem um metodo 'arquivos.getListaFormatoFirebase( )' que vai retornar a lista de arquivos de acordo com o formato que vai ser enviado ao firebase
  ArquivoLocalListModel arquivos = new ArquivoLocalListModel();

  File _image;

  String _mensageaquivo = "Adicionar um novo arquivo :";
  String _mensageimagem = "Adicionar uma nova imagem :";

  var newfilepath;
  var file;

  @override
  void initState() {
    super.initState();
  }

  Future _selecionarNovaImagem() async {
    File newfile = null;
    try {
      newfile = await ImagePicker.pickImage(source: ImageSource.camera);

      if (newfile != null) {
        setState(() {
          arquivos.setNovasImagens(newfile.path);
        });
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
  }

  void _selecionarNovosArquivos() async {
    newfilepath = null;
    try {
      newfilepath = await FilePicker.getMultiFilePath(
          type: widget.arquivoTipo == ArquivoTipo.aplication
              ? FileType.ANY
              : FileType.IMAGE);
      if (newfilepath != null) {
        setState(() {
          arquivos.setNovosArquivo(newfilepath);
        });
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
  }

  _cardImagem(ArquivoLocalModel arquivo) {
    return Card(
        child: Container(
            constraints: new BoxConstraints.expand(
              height: 200.0,
            ),
            padding: new EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage(arquivo.endereco),
                fit: BoxFit.cover,
              ),
            ),
            child: new Stack(
              children: <Widget>[
                new Positioned(
                  left: 0.0,
                  bottom: 0.0,
                  child: new Text(arquivo.nome,
                      style: new TextStyle(
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      )),
                ),
                new Positioned(
                    right: 0.0,
                    bottom: 0.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40.0),
                      child: Container(
                        color: Colors.white,
                        child: new IconButton(
                          icon: new Icon(
                            Icons.delete,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            //apagar esta imagem
                            setState(() {
                              arquivos.removerArquivoLista(arquivo);
                            });
                          },
                        ),
                      ),
                    )),
              ],
            )));
  }

  _listTileArquivo(ArquivoLocalModel arquivo) {
    return ListTile(
      leading: Icon(Icons.attach_file),
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

  Widget getListaArquivos(Function construcaoWidget) {
    Set<Widget> list = new Set<Widget>();
    var lista = arquivos.getListaAquivos();

    for (int i = 0; i < lista.length; i++) {
      list.add(construcaoWidget(arquivos.getArquivoPorIndex(i)));
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
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
        Text(
            "${widget.arquivoTipo == ArquivoTipo.aplication ? _mensageaquivo : _mensageimagem}",
            style: TextStyle(fontSize: 16, color: Colors.black)),
        ButtonBar(
          children: <Widget>[
            widget.arquivoTipo == ArquivoTipo.image
                ? IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: () {
                      _selecionarNovaImagem();
                    },
                  )
                : Container(),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _selecionarNovosArquivos();
              },
            )
          ],
        )
      ]),
      widget.arquivoTipo == ArquivoTipo.aplication
          ? getListaArquivos(_listTileArquivo)
          : getListaArquivos(_cardImagem)
    ]));
  }
}
