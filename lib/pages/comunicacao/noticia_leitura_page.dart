import 'package:flutter/material.dart';
import 'package:pmsbmibile3/naosuportato/flutter_markdown.dart'
    if (dart.library.io) 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/models/noticia_model.dart';
import 'package:pmsbmibile3/pages/comunicacao/noticia_page_bloc.dart';

class NoticiaLeituraPage extends StatefulWidget {
  NoticiaLeituraPage({Key key}) : super(key: key);

  _NoticiaLeituraPageState createState() => _NoticiaLeituraPageState();
}

class _NoticiaLeituraPageState extends State<NoticiaLeituraPage> {
  final bloc = NoticiaPageBloc(
      firestore: Bootstrap.instance.firestore, visualizada: false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backToRootPage: true,
      title: StreamBuilder<NoticiaPageState>(
        stream: bloc.noticiaPageStateStream,
        builder: (context, snap) {
          if (snap.hasError) {
            return Text("ERROR");
          }
          if (!snap.hasData) {
            return Text("Buscando usuario...");
          }
          return Text("Oi ${snap.data?.usuarioIDNome}");
        },
      ),
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
              if (snapshot.data.isEmpty) {
                return Center(
                  child: Text(
                      "Seja bem vindo(a)\nAo Aplicativo de gestão de dados para o\nPlano Municipal de Saneamento Básico\ndo estado do Tocantins.\nEscolha um menu a esquerda ou direita."),
                );
              }
              return ListView(
                children: snapshot.data.map((noticia) {
                  return Card(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text('Titulo ${noticia?.titulo}'),
                          subtitle: Text(
                              "Editor: ${noticia.usuarioIDEditor.nome}\nem: ${noticia.publicar}\n"),
                          trailing: IconButton(
                            icon: Icon(bloc.visualizada
                                ? Icons.arrow_back
                                : Icons.arrow_forward),
                            onPressed: () {
                              bloc.noticiaPageEventSink(
                                  UpdateNoticiaVisualizadaEvent(
                                      noticiaID: noticia.id));
                            },
                          ),
                        ),
                        ListTile(
                          title: MarkdownBody(
                            data: "${noticia.textoMarkdown}",
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            }),
      ),
    );
  }
}
