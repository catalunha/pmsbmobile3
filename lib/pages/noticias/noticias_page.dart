import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:provider/provider.dart';
import 'package:pmsbmibile3/state/services.dart';
import 'package:pmsbmibile3/models/models.dart';

class NoticiasNaoVisualizadasBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var db = Provider.of<DatabaseService>(context);
    var authBloc = Provider.of<AuthBloc>(context);

    return StreamBuilder(
      stream: authBloc.userId,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("ERRO"),
          );
        }
        if (!snapshot.hasData) {
          Center(
            child: CircularProgressIndicator(),
          );
        }
        return Container(
          child: StreamProvider<List<NoticiaUsuarioModel>>.value(
            // lista de documentos em /noticias_usuarios não visualizados
            stream: db.streamNoticiasUsuarios(
                userId: snapshot.data, visualizada: false),
            child: ListaNoticiasUsuarios(),
          ),
        );
      },
    );
  }
}

class NoticiasNaoVisualizadasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<AuthBloc>(context);

    return DefaultScaffold(
      title: StreamBuilder<UsuarioModel>(
        stream: authBloc.perfil,
        builder: (context, snap) {
          if(snap.hasError){
            return Text("ERROR");
          }
          if(!snap.hasData){
            return Text("SEM DADOS");
          }
          var perfil = snap.data;
          return Text("Ola, ${perfil.nome}");
        },
      ),
      body: NoticiasNaoVisualizadasBody(),
    );
  }
}

class NoticiasVisualizadasBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var db = Provider.of<DatabaseService>(context);
    var authBloc = Provider.of<AuthBloc>(context);

    return StreamBuilder(
      stream: authBloc.userId,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("ERRO"),
          );
        }
        if (!snapshot.hasData) {
          Center(
            child: CircularProgressIndicator(),
          );
        }
        return Container(
          child: StreamProvider<List<NoticiaUsuarioModel>>.value(
            // lista de documentos em /noticias_usuarios não visualizados
            stream: db.streamNoticiasUsuarios(userId: snapshot.data, visualizada: true),
            child: ListaNoticiasUsuarios(),
          ),
        );
      },
    );
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
    if (noticiaUsuario == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

//    return StreamBuilder<NoticiaModel>(
//      stream: db.streamNoticiaByDocumentReference(noticiaUsuario.noticia),
//      builder: (context, snap){
//        if(snap.hasError) return Text("Error ${snap.error}");
//        else if(snap.hasData) return Text("${snap.data.titulo}");
//        else return Center(child: Text("Noticia não encontrada"));
//
//      },
//    );

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: <Widget>[
          Divider(),
          StreamProvider<NoticiaModel>.value(
            stream: db.streamNoticiaById(noticiaUsuario.noticiaId),
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
            //TODO: replace all deve ir para bloc
            data: noticia.textoMarkdown.replaceAll("\\n", "\n"),
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
