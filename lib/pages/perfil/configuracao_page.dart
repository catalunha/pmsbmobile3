import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/setor_censitario_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:pmsbmibile3/pages/perfil/configuracao_bloc.dart';
import 'package:pmsbmibile3/services/recursos.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/naosuportato/naosuportado.dart'
    show FilePicker, FileType;
import 'package:pmsbmibile3/models/propriedade_for_model.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';
import 'package:pmsbmibile3/widgets/round_image.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PmsbColors.fundo,
        bottomOpacity: 0.0,
        elevation: 0.0,
        centerTitle: true,
        title: Text("Configurações"),
      ),
      body: Container(
        color: PmsbColors.fundo,
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: ListView(
            children: <Widget>[
              FotoUsuario(bloc),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: AtualizarNomeNoProjeto(bloc),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: AtualizarNumeroCelular(bloc),
              ),
              SelecionarEixo(bloc),
              SelecionarSetorCensitario(bloc),
              SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: PmsbColors.cor_destaque,
        onPressed: () {
          bloc.eventSink(SaveEvent());
          Navigator.pop(context);
        },
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
      ),
    );
  }
}

class SelecionarEixo extends StatelessWidget {
  final ConfiguracaoPageBloc bloc;

  const SelecionarEixo(this.bloc);

  @override
  Widget build(BuildContext context) {
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
              child: ListTile(
                trailing: Icon(Icons.search),
                subtitle: Text(
                  "${snapshot.data.eixoIDAtualNome}",
                  style: PmsbStyles.textoPrimario,
                ),
                title: Text(
                  "Alterar eixo: ",
                  style: PmsbStyles.textoSecundario,
                ),
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
  final ConfiguracaoPageBloc bloc;

  const SelecionarSetorCensitario(this.bloc);

  @override
  Widget build(BuildContext context) {
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
              child: ListTile(
                trailing: Icon(Icons.search),
                title: Text(
                  "Alterar setor censitário:",
                  style: PmsbStyles.textoSecundario,
                ),
                subtitle: Text(
                  "${snapshot.data.setorCensitarioIDnome}",
                  style: PmsbStyles.textoPrimario,
                ),
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
  final ConfiguracaoPageBloc bloc;

  const AtualizarNumeroCelular(this.bloc);

  @override
  State<StatefulWidget> createState() {
    return AtualizarNumeroCelularState(bloc);
  }
}

class AtualizarNumeroCelularState extends State<AtualizarNumeroCelular> {
  final ConfiguracaoPageBloc bloc;

  final _controller = TextEditingController();

  AtualizarNumeroCelularState(this.bloc);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UsuarioModel>(
        stream: bloc.usuarioModelStream,
        builder: (context, snapshot) {
          if (_controller.text == null || _controller.text.isEmpty) {
            _controller.text = snapshot.data?.celular;
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Atualizar número do celular:",
                style: PmsbStyles.textoSecundario,
              ),
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
  final ConfiguracaoPageBloc bloc;

  AtualizarNomeNoProjeto(this.bloc);

  @override
  State<StatefulWidget> createState() {
    return AtualizarNomeNoProjetoState(bloc);
  }
}

class AtualizarNomeNoProjetoState extends State<AtualizarNomeNoProjeto> {
  final ConfiguracaoPageBloc bloc;

  final _controller = TextEditingController();

  AtualizarNomeNoProjetoState(this.bloc);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UsuarioModel>(
        stream: bloc.usuarioModelStream,
        builder: (context, snapshot) {
          if (_controller.text == null || _controller.text.isEmpty) {
            _controller.text = snapshot.data?.nome;
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Atualizar nome no projeto:",
                style: PmsbStyles.textoSecundario,
              ),
              TextField(
                style: PmsbStyles.textoPrimario,
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
  final ConfiguracaoPageBloc bloc;

  FotoUsuario(this.bloc);

  @override
  Widget build(BuildContext context) {
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
            RoundImage(
                heigth: 150,
                width: 150,
                corBorda: Colors.white54,
                espesuraBorda: 6,
                fotoUrl: snapshot.data?.fotoUrl,
                fotoLocalPath: snapshot.data?.fotoLocalPath),
            if (Recursos.instance.disponivel("file_picking"))
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Atualizar foto de usuário:'),
                    IconButton(
                      icon: Icon(Icons.file_upload),
                      onPressed: () async {
                        await _selecionarNovoArquivo().then((arq) {
                          fotoLocalPath = arq;
                        });
                        bloc.eventSink(UpdateFotoEvent(fotoLocalPath));
                      },
                    ),
                  ]),
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
