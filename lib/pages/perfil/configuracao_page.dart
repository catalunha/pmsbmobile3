import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/perfis_usuarios_model.dart';
import 'package:pmsbmibile3/pages/perfil/configuracao_bloc.dart';
import 'package:provider/provider.dart';

class ConfiguracaoPage extends StatefulWidget{
  @override
  ConfiguracaoState createState() {
    return ConfiguracaoState();
  }
}

class ConfiguracaoState extends State<ConfiguracaoPage> {
  final bloc = ConfiguracaoBloc();
  @override
  void initState() {
    bloc.setUserId("gMTTsGDyXiWto3mOYYEFrqnI85S2");
    super.initState();
  }

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
    return InkWell(
      onTap: () {
        showDialog(
            context: context, builder: (context) => OpcoesSetorCensitario());
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
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Setor 1"),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Setor 2"),
        ),
      ],
    );
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
          if(snapshot.data != null) celular = snapshot.data.celular;
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
          if(snapshot.data != null) nomeProjeto = snapshot.data.nomeProjeto;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Atualizar nome no projeto"),
              Text("atual: $nomeProjeto"),
              TextField(
                onChanged: (String v){
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
        Text("Atualizar imagem do perfil"),
        Icon(Icons.attach_file),
      ],
    );
  }
}
