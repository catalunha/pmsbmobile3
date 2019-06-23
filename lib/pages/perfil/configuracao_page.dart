import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/perfis_usuarios_model.dart';
import 'package:pmsbmibile3/models/setores_censitarios_model.dart';
import 'package:pmsbmibile3/pages/perfil/configuracao_bloc.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';


class ConfiguracaoPage extends StatelessWidget {
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
                child: StreamBuilder<bool>(
                    initialData: false,
                    stream: bloc.isValidForm,
                    builder: (context, snapshot) {
                      return RaisedButton(
                        onPressed:
                            snapshot.data ? () => bloc.processForm(true) : null,
                        child: Text("salvar"),
                      );
                    }),
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
    return InkWell(
      onTap: () {
        showDialog(context: context, builder: (context) => OpcoesEixo());
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Escolha o Eixo para sua visibilidade"),
            Icon(Icons.search),
          ],
        ),
      ),
    );
  }
}

class OpcoesEixo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Eixo 1"),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Eixo 2"),
        ),
      ],
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
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Escolha o Setor Censitário"),
            Icon(Icons.search),
          ],
        ),
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
          if(snapshot.data == null) return Text("...");
          return SimpleDialog(
            children: snapshot.data.map(
              (setor) => SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(setor.nome),
                  ),
            ).toList(),
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

class AtualizarNumeroCelular extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ConfiguracaoBloc>(context);
    return StreamBuilder<PerfilUsuarioModel>(
        stream: bloc.perfil,
        builder: (context, snapshot) {
          var celular = "";
          if (snapshot.data != null) celular = snapshot.data.celular;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Atualizar numero celular"),
              Text("atual: ${celular}"),
              TextField(
                onChanged: bloc.updateNumeroCelular,
              ),
            ],
          );
        });
  }
}

class AtualizarNomeNoProjeto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ConfiguracaoBloc>(context);
    return StreamBuilder<PerfilUsuarioModel>(
        stream: bloc.perfil,
        builder: (context, snapshot) {
          var nomeProjeto = "";
          if (snapshot.data != null) nomeProjeto = snapshot.data.nomeProjeto;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Atualizar nome no projeto"),
              Text("atual: $nomeProjeto"),
              TextField(
                onChanged: (String v) {
                  print("change");
                  bloc.updateNomeProjeto(v);
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
              Expanded(
                flex: 4,
                child: FlutterLogo(size: 150,),
                //Image.network("https://avatars1.githubusercontent.com/u/3485625?s=460&v=4")
              ),
              Spacer(
                flex: 2,
              ),
            ],
          ),
          onTap: () async {
            var filepath = await FilePicker.getFilePath(type: FileType.IMAGE);
            bloc.updateImagemPerfil(filepath);
            print(filepath);
          },
        ),
      ],
    );
  }
}
