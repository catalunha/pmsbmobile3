import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/square_image.dart';
import 'package:pmsbmibile3/models/arquivo_model.dart';
import 'package:pmsbmibile3/models/setor_censitario_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:pmsbmibile3/pages/perfil/configuracao_bloc.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

class ConfiguracaoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ConfiguracaoState();
  }
}

class ConfiguracaoState extends State<ConfiguracaoPage> {
  final bloc = ConfiguracaoBloc();

  @override
  Widget build(BuildContext context) {
    return Provider<ConfiguracaoBloc>.value(
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
              SelecionarTema(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: AtualizarEmail(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: AtualizarNumeroCelular(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: AtualizarNomeNoProjeto(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: AtualizarImagemPerfil(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: RaisedButton(
                  onPressed: () => bloc.dispatch(ConfiguracaoSaveEvent()),
                  child: Text("salvar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelecionarEixo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ConfiguracaoBloc>(context);
    return InkWell(
      onTap: () {
        showDialog(context: context, builder: (context) => OpcoesEixo(bloc));
      },
      child: StreamBuilder<ConfiguracaoBlocState>(
        stream: bloc.state,
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return Text("ERRO");
          }
          if(!snapshot.hasData){
            return Text("SEM DADOS");
          }
          return Container(
            margin: EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Escolha o Eixo: ${snapshot.data.eixoAtualNome}"),
                Icon(Icons.search),
              ],
            ),
          );
        }
      ),
    );
  }
}

class OpcoesEixo extends StatelessWidget {
  final ConfiguracaoBloc bloc;
  OpcoesEixo(this.bloc);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UsuarioModel>(
      stream: bloc.perfil,
      builder: (context, snapshot) {
        if(snapshot.hasError){
          return Text("ERRO");
        }
        if(!snapshot.hasData){
          return Text("SEM DADOS");
        }
        var lista = [];
        if(snapshot.data.listaPossivelEixoAtual != null){
          lista = snapshot.data.listaPossivelEixoAtual;
        }

        //snapshot.data.listaPossivelEixoAtual
        return SimpleDialog(
          children: lista.map((eixo){
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("${eixo.eixoNome}"),
            );
          }).toList(),
        );
      }
    );
  }
}

class SelecionarSetorCensitario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ConfiguracaoBloc>(context);
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) => OpcoesSetorCensitario(bloc));
      },
      child: StreamBuilder<ConfiguracaoBlocState>(
        stream: bloc.state,
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return Text("ERRO");
          }
          if(!snapshot.hasData){
            return Text("SEM DADOS");
          }
          return Container(
            margin: EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Escolha o Setor Censitário: ${snapshot.data.setorCensitarioNome}"),
                Icon(Icons.search),
              ],
            ),
          );
        }
      ),
    );
  }
}

class OpcoesSetorCensitario extends StatelessWidget {
  final ConfiguracaoBloc bloc;

  OpcoesSetorCensitario(this.bloc);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SetorCensitarioModel>>(
        stream: bloc.setores,
        builder: (context, snapshot) {
          if (snapshot.data == null) return Text("...");
          return SimpleDialog(
            children: snapshot.data
                .map(
                  (setor) => SimpleDialogOption(
                        onPressed: () {
                          bloc.dispatch(UpdateSetorCensitarioConfiguracaoUpdateNomeProjetoEvent(setor.id, setor.nome));
                          Navigator.pop(context);
                        },
                        child: Text(setor.nome),
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

class AtualizarEmail extends StatefulWidget {
  @override
  AtualizarEmailState createState() => AtualizarEmailState();
}

class AtualizarEmailState extends State<AtualizarEmail> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ConfiguracaoBloc>(context);
    return StreamBuilder<UsuarioModel>(
        stream: bloc.perfil,
        builder: (context, snapshot) {
          if (_controller.text == null || _controller.text.isEmpty) {
            _controller.text = snapshot.data?.email;
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Atualizar Email"),
              TextField(
                controller: _controller,
                onChanged: (email) =>
                    bloc.dispatch(ConfiguracaoUpdateEmailEvent(email)),
              ),
            ],
          );
        });
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
    final bloc = Provider.of<ConfiguracaoBloc>(context);
    return StreamBuilder<UsuarioModel>(
        stream: bloc.perfil,
        builder: (context, snapshot) {
          if (_controller.text == null || _controller.text.isEmpty) {
            _controller.text = snapshot.data?.celular;
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Atualizar numero celular"),
              TextField(
                controller: _controller,
                onChanged: (celular){
                  bloc.dispatch(ConfiguracaoUpdateCelularEvent(celular));
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
    final bloc = Provider.of<ConfiguracaoBloc>(context);
    return StreamBuilder<UsuarioModel>(
        stream: bloc.perfil,
        builder: (context, snapshot) {
          if (_controller.text == null || _controller.text.isEmpty) {
            _controller.text = snapshot.data?.nomeProjeto;
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Atualizar nome no projeto"),
              TextField(
                controller: _controller,
                onChanged: (nomeProjeto){
                  bloc.dispatch(ConfiguracaoUpdateNomeProjetoEvent(nomeProjeto));
                },
              ),
            ],
          );
        });
  }
}

class AtualizarImagemPerfil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ConfiguracaoBloc>(context);
    return StreamBuilder<UsuarioModel>(
        stream: bloc.perfil,
        builder: (context, snapshot) {
          var perfil = snapshot.data;
          dynamic image = FlutterLogo();
          if (snapshot.data?.imagemPerfilUrl != null) {
            image = SquareImage(image: NetworkImage(perfil.imagemPerfilUrl));
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text("Atualizar imagem do perfil"),
              ),
              InkWell(
                child: Row(
                  children: <Widget>[
                    Spacer(
                      flex: 2,
                    ),
                    StreamBuilder<ArquivoModel>(
                        stream: bloc.uploadBloc.arquivo,
                        builder: (context, snapshot) {
                          return Expanded(
                            flex: 4,
                            child: snapshot.data == null
                                ? image
                                : SquareImage(
                                    image: NetworkImage(snapshot.data.url)),
                          );
                        }),
                    Spacer(
                      flex: 2,
                    ),
                  ],
                ),
                onTap: () async {
                  var filepath =
                      await FilePicker.getFilePath(type: FileType.IMAGE);
                  bloc.updateImagemPerfil(filepath);
                },
              ),
            ],
          );
        });
  }
}
