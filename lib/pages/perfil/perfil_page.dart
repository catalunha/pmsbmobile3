import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/models.dart';
import 'package:provider/provider.dart';
import 'package:pmsbmibile3/state/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/pages/perfil/perfil_bloc.dart';

class PerfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var db = Provider.of<DatabaseService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        child: StreamProvider<List<AdministradorVariavelModel>>.value(
          stream: db.streamAdministradorVariaveis(),
          child: ListaAdministradorVariavel(),
        ),
      ),
    );
  }
}

class ListaAdministradorVariavel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<List<AdministradorVariavelModel>>(
      builder: (
        BuildContext context,
        List<AdministradorVariavelModel> administradorVariaveis,
        Widget child,
      ) {
        if (administradorVariaveis == null) {
          return child;
        }
        return ListView(
          children: administradorVariaveis
              .map((variavel) => ItemListaAdministradorVariavel(
                    variavel: variavel,
                  ))
              .toList(),
        );
      },
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ItemListaAdministradorVariavel extends StatelessWidget {
  final AdministradorVariavelModel variavel;

  const ItemListaAdministradorVariavel({Key key, this.variavel})
      : super(key: key);

  Widget _tipoWidget() {
    if (variavel.tipo == "arquivo") {
      return Icon(Icons.attach_file);
    } else {
      return Icon(Icons.text_fields);
    }
  }

  @override
  Widget build(BuildContext context) {
    var db = Provider.of<DatabaseService>(context);
    var authBloc = Provider.of<AuthBloc>(context);

    return StreamBuilder<String>(
      stream: authBloc.userId,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("ERROR");
        }
        if (!snapshot.hasData) {
          return Text("SEM DADOS");
        }
        final String userId = snapshot.data;

        return StreamProvider<VariavelUsuarioModel>.value(
          stream: db.streamVarivelUsuarioByNomeAndUserId(
              userId: userId, variavelId: variavel.id),
          child: Card(
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${variavel.nome}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _tipoWidget(),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, "/perfil/editar_variavel",
                              arguments: variavel.id);
                        },
                        child: Icon(Icons.edit),
                      ),
                    ],
                  ),
                  Consumer<VariavelUsuarioModel>(
                    builder: (BuildContext context,
                        VariavelUsuarioModel variavelUsuario, Widget child) {
                      if (variavelUsuario != null) {
                        return ConteudoVariavelUsuario(
                          variavelUsuario: variavelUsuario,
                        );
                      } else {
                        return child;
                      }
                    },
                    child: Text(
                      "Não preenchido",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ConteudoVariavelUsuario extends StatelessWidget {
  final VariavelUsuarioModel variavelUsuario;
  final bloc = ConteudoVariavelUsuarioBloc(Bootstrap.instance.firestore);

  ConteudoVariavelUsuario({
    Key key,
    this.variavelUsuario,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (variavelUsuario.tipo == "valor") {
      return Text(variavelUsuario.conteudo);
    } else {
      bloc.setArquivoId(variavelUsuario.conteudo.toString());
      return StreamBuilder<ArquivoModel>(
          stream: bloc.arquivo,
          initialData: null,
          builder: (context, snapshot) {
            if (snapshot.data == null) return Text("...");
            return InkWell(
              onTap: () {
                launch(snapshot.data.url);
              },
              child: Text(
                snapshot.data.titulo != null? snapshot.data.titulo: "titulo arquivo",
                style: TextStyle(color: Colors.blue),
              ),
            );
          });
    }
  }
}
