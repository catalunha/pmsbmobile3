import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/setor_censitario_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:pmsbmibile3/pages/perfil/configuracao_bloc.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';

class ConfiguracaoPage extends StatefulWidget {
  final AuthBloc authBloc;

  const ConfiguracaoPage(this.authBloc);

  @override
  State<StatefulWidget> createState() {
    return ConfiguracaoState(authBloc);
  }
}

class ConfiguracaoState extends State<ConfiguracaoPage> {
  final ConfiguracaoPageBloc bloc;

  ConfiguracaoState(AuthBloc authBloc)
      : bloc = ConfiguracaoPageBloc(Bootstrap.instance.firestore, authBloc);

  @override
  void initState() {
    super.initState();
    bloc.eventSink(UpdateUsuarioIDEvent());
    bloc.eventSink(PullSetorCensitarioEvent());
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<ConfiguracaoPageBloc>.value(
      value: bloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Configurações"),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: ListView(
            children: <Widget>[
              SelecionarEixo(),
              SelecionarSetorCensitario(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: AtualizarNumeroCelular(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: AtualizarNomeNoProjeto(),
              ),
              FotoUsuario(),
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

class SelecionarEixo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ConfiguracaoPageBloc>(context);
    return InkWell(
      onTap: () {
        showDialog(context: context, builder: (context) => OpcoesEixo(bloc));
      },
      child: StreamBuilder<ConfiguracaoPageState>(
          stream: bloc.stateStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("ERRO");
            }
            if (!snapshot.hasData) {
              return Text("SEM DADOS");
            }
            return Container(
              margin: EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Alterar Eixo: ${snapshot.data.eixoIDAtualNome}"),
                  Icon(Icons.search),
                ],
              ),
            );
          }),
    );
  }
}

class OpcoesEixo extends StatelessWidget {
  final ConfiguracaoPageBloc bloc;
  OpcoesEixo(this.bloc);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UsuarioModel>(
        stream: bloc.usuarioModelStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("ERRO");
          }
          if (!snapshot.hasData) {
            return Text("SEM DADOS");
          }
          var lista = List<EixoID>();
          if (snapshot.data.eixoIDAcesso != null) {
            lista = snapshot.data.eixoIDAcesso;
          }

          return SimpleDialog(
            children: lista.map((eixo) {
              return SimpleDialogOption(
                onPressed: () {
                  bloc.eventSink(UpdateEixoIDAtualEvent(eixo.id, eixo.nome));
                  Navigator.pop(context);
                },
                child: Text("${eixo.nome}"),
              );
            }).toList(),
          );
        });
  }
}

class SelecionarSetorCensitario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ConfiguracaoPageBloc>(context);
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) => OpcoesSetorCensitario(bloc));
      },
      child: StreamBuilder<ConfiguracaoPageState>(
          stream: bloc.stateStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("ERRO");
            }
            if (!snapshot.hasData) {
              return Text("SEM DADOS");
            }
            return Container(
              margin: EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                      "Alterar Setor Censitário: ${snapshot.data.setorCensitarioIDnome}"),
                  Icon(Icons.search),
                ],
              ),
            );
          }),
    );
  }
}

class OpcoesSetorCensitario extends StatelessWidget {
  final ConfiguracaoPageBloc bloc;

  OpcoesSetorCensitario(this.bloc);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SetorCensitarioModel>>(
        stream: bloc.setorCensitarioModelListStream,
        builder: (context, snapshot) {
          if (snapshot.data == null) return Text("...");
          return SimpleDialog(
            children: snapshot.data
                .map(
                  (setor) => SimpleDialogOption(
                    child: Text('Setor: ${setor.nome}'),
                    onPressed: () {
                      bloc.eventSink(
                          UpdateSetorCensitarioEvent(setor.id, setor.nome));
                      Navigator.pop(context);
                    },
                  ),
                )
                .toList(),
          );
        });
  }
}

class SelecionarTema extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(context: context, builder: (context) => OpcoesTema());
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Escolha o Tema"),
            Icon(Icons.search),
          ],
        ),
      ),
    );
  }
}

class OpcoesTema extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Dark"),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Light"),
        ),
      ],
    );
  }
}

class AtualizarNumeroCelular extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AtualizarNumeroCelularState();
  }
}

class AtualizarNumeroCelularState extends State<AtualizarNumeroCelular> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ConfiguracaoPageBloc>(context);
    return StreamBuilder<UsuarioModel>(
        stream: bloc.usuarioModelStream,
        builder: (context, snapshot) {
          if (_controller.text == null || _controller.text.isEmpty) {
            _controller.text = snapshot.data?.celular;
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Atualizar número do celular"),
              TextField(
                controller: _controller,
                onChanged: (celular) {
                  bloc.eventSink(UpdateCelularEvent(celular));
                },
              ),
            ],
          );
        });
  }
}

class AtualizarNomeNoProjeto extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AtualizarNomeNoProjetoState();
  }
}

class AtualizarNomeNoProjetoState extends State<AtualizarNomeNoProjeto> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ConfiguracaoPageBloc>(context);
    return StreamBuilder<UsuarioModel>(
        stream: bloc.usuarioModelStream,
        builder: (context, snapshot) {
          if (_controller.text == null || _controller.text.isEmpty) {
            _controller.text = snapshot.data?.nome;
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Atualizar nome no projeto"),
              TextField(
                controller: _controller,
                onChanged: (nomeProjeto) {
                  bloc.eventSink(UpdateNomeEvent(nomeProjeto));
                },
              ),
            ],
          );
        });
  }
}

class FotoUsuario extends StatelessWidget {
  String fotoUrl;
  String fotoLocalPath;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ConfiguracaoPageBloc>(context);

    return StreamBuilder<ConfiguracaoPageState>(
      stream: bloc.stateStream,
      builder: (BuildContext context,
          AsyncSnapshot<ConfiguracaoPageState> snapshot) {
        if (snapshot.hasError) {
          return Container(
            child: Center(child: Text('Erro.')),
          );
        }
        return Column(
          children: <Widget>[
            ButtonTheme.bar(
                child: ButtonBar(children: <Widget>[
              Text('Atualizar foto de usuario'),
              IconButton(
                icon: Icon(Icons.file_download),
                onPressed: () async {
                  await _selecionarNovoArquivo().then((arq) {
                    fotoLocalPath = arq;
                  });
                  bloc.eventSink(UpdateFotoEvent(fotoLocalPath));
                },
              ),
            ])),
            ImagemUnica(
                fotoUrl: snapshot.data?.fotoUrl,
                fotoLocalPath: snapshot.data?.fotoLocalPath),
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

class ImagemUnica extends StatelessWidget {
  final String fotoUrl;
  final String fotoLocalPath;

  const ImagemUnica({this.fotoUrl, this.fotoLocalPath});

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
            // child: Icon(Icons.people, size: 75),
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
