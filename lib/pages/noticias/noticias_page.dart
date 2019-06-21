import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:pmsbmibile3/state/services.dart';
import 'package:pmsbmibile3/state/user_repository.dart';
import 'package:pmsbmibile3/models/models.dart';

class NoticiasNaoVisualizadasBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var db = Provider.of<DatabaseService>(context);
    var userRepository = Provider.of<UserRepository>(context);
    if (userRepository.user != null) {
      var userId;
      userId = userRepository.user.uid;
      return Container(
        child: StreamProvider<List<NoticiaUsuarioModel>>.value(
          // lista de documentos em /noticias_usuarios não visualizados
          stream: db.streamNoticiasUsuarios(userId: userId, visualizada: false),
          child: ListaNoticiasUsuarios(),
        ),
      );
    } else {
      return CircularProgressIndicator();
    }
  }
}

class NoticiasNaoVisualizadasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      title: Consumer(
        builder: (context, UsuarioModel usuario, _) =>
            Text("Ola, ${usuario.lastName}"),
      ),
      body: NoticiasNaoVisualizadasBody(),
    );
  }
}

class NoticiasVisualizadasBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var db = Provider.of<DatabaseService>(context);
    var userRepository = Provider.of<UserRepository>(context);
    if (userRepository.user != null) {
      var userId;
      userId = userRepository.user.uid;
      return Container(
        child: StreamProvider<List<NoticiaUsuarioModel>>.value(
          // lista de documentos em /noticias_usuarios não visualizados
          stream: db.streamNoticiasUsuarios(userId: userId, visualizada: true),
          child: ListaNoticiasUsuarios(),
        ),
      );
    } else {
      return CircularProgressIndicator();
    }
  }
}

class NoticiasVisualizadasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Noticias Arquivadas"),
      ),
      body: NoticiasVisualizadasBody(),
    );
  }
}

class ListaNoticiasUsuarios extends StatelessWidget {
  Widget _card(BuildContext context, NoticiaUsuarioModel noticiaUsuario) {
    var db = Provider.of<DatabaseService>(context);
    return noticiaUsuario != null
        ? Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: <Widget>[
                Divider(),
                StreamProvider<NoticiaModel>.value(
                  stream: db.streamNoticiaByDocumentReference(
                      noticiaUsuario.noticia),
                  child: NoticiaTile(),
                ),
                if (!noticiaUsuario.visualizada)
                  Container(
                    padding: EdgeInsets.all(12),
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        db.marcarNoticiaUsuarioVisualizada(noticiaUsuario.id);
                      },
                      child: Icon(Icons.thumb_up),
                    ),
                  ),
              ],
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  @override
  Widget build(BuildContext context) {
    var noticiasUsuarios = Provider.of<List<NoticiaUsuarioModel>>(context);
    if (noticiasUsuarios != null) {
      return ListView(
        shrinkWrap: true,
        children: noticiasUsuarios
            .map((noticiaUsuario) => _card(context, noticiaUsuario))
            .toList(),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}

class NoticiaTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NoticiaModel>(
      builder: (BuildContext context, NoticiaModel noticia, Widget child) {
        if (noticia != null) {
          return MarkdownBody(
            data: noticia.conteudoMarkdown,
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
