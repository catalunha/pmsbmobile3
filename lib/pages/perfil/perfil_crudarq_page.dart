import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/square_image.dart';
import 'package:pmsbmibile3/models/usuario_perfil_model.dart';
import 'package:pmsbmibile3/pages/perfil/perfil_crudarq_page_bloc.dart';
import 'package:provider/provider.dart';

class PerfilCRUDArqPage extends StatefulWidget {
  final String usuarioPerfilID;

  PerfilCRUDArqPage(this.usuarioPerfilID);

  _PerfilCRUDArqPageState createState() => _PerfilCRUDArqPageState();
}

class _PerfilCRUDArqPageState extends State<PerfilCRUDArqPage> {
  final PerfilCRUDArqPageBloc bloc =
      PerfilCRUDArqPageBloc(Bootstrap.instance.firestore);

  @override
  void initState() {
    super.initState();
    bloc.eventSink(UpDateUsuarioPerfilIDEvent(widget.usuarioPerfilID));
  }

  @override
  Widget build(BuildContext context) {
    return Provider<PerfilCRUDArqPageBloc>.value(
      value: bloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Configurações"),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: ListView(
            children: <Widget>[
              _FotoUsuario(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            bloc.eventSink(SaveEvent());
            Navigator.pop(context);
          },
          child: Icon(Icons.check),
        ),
      ),
    );
  }
}

class _FotoUsuario extends StatelessWidget {
  String fotoUrl;
  String fotoLocalPath;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<PerfilCRUDArqPageBloc>(context);

    return StreamBuilder<PerfilCRUDArqPageState>(
      stream: bloc.stateStream,
      builder: (BuildContext context,
          AsyncSnapshot<PerfilCRUDArqPageState> snapshot) {
        if (snapshot.hasError) {
          return Container(
            child: Center(child: Text('Erro.')),
          );
        }
        return Column(
          children: <Widget>[
            snapshot.data?.usuarioPerfilModel?.perfilID?.nome != null
                ? Text(snapshot.data?.usuarioPerfilModel?.perfilID?.nome)
                : Text('...'),
            ButtonTheme.bar(
                child: ButtonBar(children: <Widget>[
              Text('Atualizar arquivo'),
              IconButton(
                icon: Icon(Icons.file_download),
                onPressed: () async {
                  await _selecionarNovoArquivo().then((arq) {
                    fotoLocalPath = arq;
                  });
                  bloc.eventSink(UpDateArquivoEvent(fotoLocalPath));
                },
              ),
            ])),
            _ImagemUnica(
                fotoUrl: snapshot.data?.arquivoUrl,
                fotoLocalPath: snapshot.data?.arquivoLocalPath),
          ],
        );
      },
    );
  }

  Future<String> _selecionarNovoArquivo() async {
    try {
      var arquivoPath = await FilePicker.getFilePath(type: FileType.ANY);
      if (arquivoPath != null) {
        // print('>> newfilepath 1 >> ${arquivoPath}');
        return arquivoPath;
      }
    } catch (e) {
      print("Unsupported operation" + e.toString());
    }
  }
}

class _ImagemUnica extends StatelessWidget {
  final String fotoUrl;
  final String fotoLocalPath;

  const _ImagemUnica({this.fotoUrl, this.fotoLocalPath});

  @override
  Widget build(BuildContext context) {
    Widget foto;
    if (fotoUrl == null && fotoLocalPath == null) {
      foto = Center(child: Text('Sem imagem.'));
    } else if (fotoUrl != null) {
      foto = Container(
          child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Image.network(fotoUrl),
      ));
    } else {
      foto = Container(
          color: Colors.yellow,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Icon(Icons.people, size: 75), //Image.asset(fotoLocalPath),
          ));
    }

    return Row(
      children: <Widget>[
        Spacer(
          flex: 3,
        ),
        Expanded(
          flex: 4,
          child: foto,
        ),
        Spacer(
          flex: 3,
        ),
      ],
    );
  }
}
