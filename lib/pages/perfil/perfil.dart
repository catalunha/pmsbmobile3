import 'package:flutter/material.dart';
import 'package:pmsbmibile3/state/models/variaveis_usuarios.dart';
import 'package:pmsbmibile3/state/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:pmsbmibile3/state/services.dart';
import 'package:pmsbmibile3/state/models/administrador_variaveis.dart';

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
        child: StreamProvider<List<AdministradorVariavel>>.value(
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
    return Consumer<List<AdministradorVariavel>>(
      builder: (
        BuildContext context,
        List<AdministradorVariavel> administradorVariaveis,
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
  final AdministradorVariavel variavel;

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
    var userRepository = Provider.of<UserRepository>(context);
    return StreamProvider<VarivelUsuario>.value(
      stream: db.streamVarivelUsuarioByNomeAndUserId(
          userId: userRepository.user.uid, nome: variavel.nome),
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
                      Navigator.pushNamed(context, "/perfil/editar_variavel",
                          arguments: variavel.id);
                    },
                    child: Icon(Icons.edit),
                  ),
                ],
              ),
              Consumer<VarivelUsuario>(
                builder: (BuildContext context, VarivelUsuario variavelUsuario,
                    Widget child) {
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
  }
}

class ConteudoVariavelUsuario extends StatelessWidget {
  final VarivelUsuario variavelUsuario;

  const ConteudoVariavelUsuario({Key key, this.variavelUsuario})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: retornar widget diferente para valor e arquivo
    return Text(variavelUsuario.conteudo);
  }
}
