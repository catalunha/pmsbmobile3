import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pmsbmibile3/naosuportato/naosuportado.dart'
    show FilePicker, FileType;
import 'package:flutter/foundation.dart';
import 'package:pmsbmibile3/naosuportato/image_picker.dart'
    if (dart.library.io) 'package:image_picker/image_picker.dart';
import 'package:flutter/rendering.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/pages/aplicacao/pergunta/pergunta_imagem_arquivo_bloc.dart';

enum ArquivoTipo { image, aplication }

class PerguntaWigdetImagemArquivo extends StatefulWidget {
  final PerguntaAplicadaModel perguntaAplicada;
  final ArquivoTipo arquivoTipo;
  final String usuarioID;

  PerguntaWigdetImagemArquivo(this.perguntaAplicada, this.usuarioID,
      {Key key, this.arquivoTipo})
      : super(key: key);

  @override
  _PerguntaWigdetImagemArquivoState createState() =>
      _PerguntaWigdetImagemArquivoState();
}

class _PerguntaWigdetImagemArquivoState
    extends State<PerguntaWigdetImagemArquivo> {
  PerguntaImagemArquivoBloc bloc;

  final String _mensageaquivo = "Adicionar um novo arquivo :";
  final String _mensageimagem = "Adicionar uma nova imagem :";

  @override
  void initState() {
    super.initState();
    bloc = PerguntaImagemArquivoBloc(widget.perguntaAplicada, widget.usuarioID,
        Bootstrap.instance.firestore);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  Future _selecionarNovaImagem() async {
    try {
      File newfile = await ImagePicker.pickImage(source: ImageSource.camera);
      bloc.dispatch(
          AdicionarImagemPerguntaImagemArquivoBlocEvent(newfile.path));
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
  }

  void _selecionarNovosArquivos() async {
    try {
      Map<String, String> arquivos = await FilePicker.getMultiFilePath(
          type: widget.arquivoTipo == ArquivoTipo.aplication
              ? FileType.ANY
              : FileType.IMAGE);
      bloc.dispatch(AdicionarArquivosPerguntaImagemArquivoBlocEvent(arquivos));
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
  }

  Widget getListaArquivos() {
    return StreamBuilder<PerguntaImagemArquivoBlocState>(
      stream: bloc.state,
      builder: (context, snapshot) {
        final arquivos = widget.perguntaAplicada.arquivo.map((index, arquivo) {
          return MapEntry(
            index,
            ArquivoItem(
              arquivo,
              tipo: widget.arquivoTipo,
              onDeleted: () {
                bloc.dispatch(
                    RemoverArquivoUpdatePerguntaImagemArquivoBlocEvent(
                        arquivo));
              },
            ),
          );
        });
        return Column(
          children: arquivos.values.toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                "${widget.arquivoTipo == ArquivoTipo.aplication ? _mensageaquivo : _mensageimagem}",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              ButtonBar(
                children: <Widget>[
                  widget.arquivoTipo == ArquivoTipo.image
                      ? IconButton(
                          icon: Icon(Icons.camera_alt),
                          onPressed: _selecionarNovaImagem,
                        )
                      : Container(),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _selecionarNovosArquivos,
                  )
                ],
              )
            ],
          ),
          getListaArquivos(),
        ],
      ),
    );
  }
}

class ArquivoImagemItem extends StatelessWidget {
  final String nome;
  final String localPath;
  final String url;
  final Function() onDeleted;

  const ArquivoImagemItem(
    this.nome, {
    Key key,
    this.onDeleted,
    this.localPath,
    this.url,
  })  : assert(localPath != null || url != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        constraints: BoxConstraints.expand(
          height: 150.0,
        ),
        padding: EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: url != null ? NetworkImage(url) : AssetImage(localPath),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0.0,
              bottom: 0.0,
              child: Text(nome,
                  style: TextStyle(
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                  )),
            ),
            Positioned(
                right: 0.0,
                bottom: 0.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40.0),
                  child: Container(
                    color: Colors.white,
                    child: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.black,
                      ),
                      onPressed: onDeleted,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class ArquivoGenericoItem extends StatelessWidget {
  final String nome;
  final Function() onDeleted;

  const ArquivoGenericoItem(this.nome, {Key key, this.onDeleted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.attach_file),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: onDeleted,
      ),
      title: Text(nome),
      subtitle: Text("Tipo: Imagem"),
    );
  }
}

class ArquivoItem extends StatelessWidget {
  final Function onDeleted;
  final PerguntaAplicadaArquivo arquivo;
  final ArquivoTipo tipo;

  const ArquivoItem(
    this.arquivo, {
    Key key,
    this.onDeleted,
    this.tipo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return tipo == ArquivoTipo.image
        ? ArquivoImagemItem(
            arquivo.nome,
            localPath: arquivo.localPath,
            url: arquivo.url,
            onDeleted: onDeleted,
          )
        : ArquivoGenericoItem(arquivo.nome, onDeleted: onDeleted);
  }
}
