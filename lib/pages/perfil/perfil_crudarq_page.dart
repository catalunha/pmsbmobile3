import 'package:flutter/material.dart';
import 'package:pmsbmibile3/naosuportato/naosuportado.dart'
    show FilePicker, FileType;
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/perfil/perfil_crudarq_page_bloc.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';

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
    return Scaffold(
      backgroundColor: PmsbColors.fundo,
      appBar: AppBar(
        backgroundColor: PmsbColors.fundo,
        bottomOpacity: 0.0,
        elevation: 0.0,
        centerTitle: true,
        title: Text("Editar Imagem"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: ListView(
          children: <Widget>[
            _FotoUsuario(bloc),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bloc.eventSink(SaveEvent());
          Navigator.pop(context);
        },
        child: Icon(Icons.check, color: Colors.white,),
        backgroundColor: PmsbColors.cor_destaque,
      ),
    );
  }
}

class _FotoUsuario extends StatelessWidget {
  String fotoUrl;
  String fotoLocalPath;
  final PerfilCRUDArqPageBloc bloc;

  _FotoUsuario(this.bloc);

  @override
  Widget build(BuildContext context) {
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
            Wrap(children: <Widget>[
              Text('Atualizar arquivo', style: PmsbStyles.textoPrimario,),
              IconButton(
                icon: Icon(Icons.file_download),
                onPressed: () async {
                  await _selecionarNovoArquivo().then((arq) {
                    fotoLocalPath = arq;
                  });
                  bloc.eventSink(UpDateArquivoEvent(fotoLocalPath));
                },
              ),
            ]),
            Column(
              
              children: <Widget>[
                _ImagemUnica(              
                    fotoUrl: snapshot.data?.arquivoUrl,
                    fotoLocalPath: snapshot.data?.arquivoLocalPath),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<String> _selecionarNovoArquivo() async {
    try {
      var arquivoPath = await FilePicker.getFilePath(type: FileType.ANY);
      if (arquivoPath != null) {
        return arquivoPath;
      }
    } catch (e) {
      print("Unsupported operation" + e.toString());
    }
    return null;
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
      foto = Center(child: Text('Sem imagem.', style: PmsbStyles.textStyleListBold,));
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
            child: Image.asset(fotoLocalPath),
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
