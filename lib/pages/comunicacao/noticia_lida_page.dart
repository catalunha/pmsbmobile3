import 'package:flutter/material.dart';
import 'package:pmsbmibile3/naosuportato/flutter_markdown.dart'
    if (dart.library.io) 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/noticia_model.dart';
import 'package:pmsbmibile3/pages/comunicacao/noticia_page_bloc.dart';

class NoticiaLidaPage extends StatefulWidget {
  NoticiaLidaPage({Key key}) : super(key: key);

  _NoticiaLidaPageState createState() => _NoticiaLidaPageState();
}

class _NoticiaLidaPageState extends State<NoticiaLidaPage> {

  final bloc = NoticiaPageBloc(
      firestore: Bootstrap.instance.firestore, visualizada: true);

  @override
  void initState() {
    super.initState();
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
        title: Text('Notícias lidas'),
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
