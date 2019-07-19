import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/models/noticia_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:pmsbmibile3/pages/comunicacao/noticia_page_bloc.dart';
import 'package:provider/provider.dart';

import 'comunicacao_home_page_bloc.dart';


class NoticiaLeituraPage extends StatelessWidget {
final bloc = NoticiaPageBloc(Bootstrap.instance.firestore);

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      title: StreamBuilder<NoticiaPageState>(
        stream: bloc.noticiaPageStateStream,
        builder: (context, snap) {
          if(snap.hasError){
            return Text("ERROR");
          }
          if(!snap.hasData){
            return Text("Buscando usuario...");
          }
          return Text("Oi ${snap.data?.usuarioIDNome}");
        },
      ),
      // body: Text('oi')
      body: Container(
        child: StreamBuilder<List<NoticiaModel>>(
            stream: bloc.noticiaModelListStream,
            initialData: [],
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Erro. Na leitura de noticias do usuario."),
                );
              }
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                children: snapshot.data
                    .map((noticia) {
                      return ListTile(
                        title: Text('Titulo ${noticia?.titulo}'),
                      );
                    })
                    .toList(),
              );
            }),
      ),
    );
  }
}

class lixo {
/*

        // _firestore
        //   .collection(UsuarioNoticiaModel.collection)
        //   .where("usuarioID", isEqualTo: _noticiaPageState.usuarioIDNome)
        //   .where("visualizada", isEqualTo: false)
        //   .snapshots()
        //   .map((snap) => snap.documents
        // .map((doc) => UsuarioNoticiaModel(id:doc.documentID).fromMap(doc.data))
        // .toList())
        // .listen((List<UsuarioNoticiaModel> usuarioNoticiaModelList){
        //   usuarioNoticiaModelListSink(usuarioNoticiaModelList);

        //   usuarioNoticiaModelList.forEach((noticiaModel){
        //   _firestore
        //   .collection(NoticiaModel.collection)
        //   .where("usuarioIDDestino.${noticiaModel.}.id", isEqualTo: true)
        //   .snapshots()
        //   .map((snap) => snap.documents
        // .map((doc) => NoticiaModel(id:doc.documentID).fromMap(doc.data))
        // .toList()).pipe(_noticiaModelListController);
        //   });

        // });


class NoticiaLeituraPage extends StatelessWidget {
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
*/
}