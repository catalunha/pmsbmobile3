import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/noticia_model.dart';
import 'package:pmsbmibile3/pages/comunicacao/noticia_page_bloc.dart';

class NoticiaLidaPage extends StatelessWidget {
  final bloc = NoticiaPageBloc(firestore:Bootstrap.instance.firestore,visualizada:true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notícias lidas'),
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
                children: snapshot.data.map((noticia) {
                  return Card(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text('Titulo ${noticia?.titulo}'),
                          subtitle: Text(
                              "Editor: ${noticia.usuarioIDEditor.nome}\nem: ${noticia.publicar}\n"),
                          trailing: IconButton(
                            icon: Icon(bloc.visualizada ? Icons.arrow_back : Icons.arrow_forward),
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
                        // Container(
                        //   // padding: EdgeInsets.symmetric(vertical: 6),
                        //   child: Text(
                        //     "${noticia.titulo}",
                        //     style: Theme.of(context).textTheme.title,
                        //   ),
                        // ),
                        // Text(
                        //     "Editor: ${noticia.usuarioIDEditor.nome} em: ${noticia.publicar}\n"),
                        // MarkdownBody(
                        //   data: "${noticia.textoMarkdown}",
                        // ),
                      ],
                    ),
                  );

                  //   return ListTile(
                  //     title: Text('Titulo ${noticia?.titulo}'),
                  //   );
                }).toList(),
              );
            }),
      ),
    );
  }
}
