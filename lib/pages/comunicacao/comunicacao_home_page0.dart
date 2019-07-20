import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/models/noticia_model.dart';
import 'package:provider/provider.dart';

import 'comunicacao_home_page_bloc.dart';
// import 'modal_filter_list.dart';

class ComunicacaoHomePage extends StatefulWidget {
  @override
  _ComunicacaoHomePageState createState() => _ComunicacaoHomePageState();
}

class _ComunicacaoHomePageState extends State<ComunicacaoHomePage> {
  final bloc = ComunicacaoHomePageBloc(Bootstrap.instance.firestore);

  @override
  Widget build(BuildContext context) {
    return Provider<ComunicacaoHomePageBloc>.value(
      value: bloc,
      child: DefaultScaffold(
        // backgroundColor: Colors.red,
        title: Text("Comunicação"),
        body: _body(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.pushNamed(context, '/comunicacao/crud_page');
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }

  Widget _body(context) {
    return Container(
      child: StreamBuilder<List<NoticiaModel>>(
          stream: bloc.noticiaModelListStream,
          initialData: [],
          builder: (context, snapshot) {
            if (snapshot.hasError)
              return Center(
                child: Text("Erro. Informe ao administrador do aplicativo"),
              );
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data.isEmpty)
              return Center(
                child: Text("Nenhuma notícia criada."),
              );
            else
              return ListView(
                children: snapshot.data
                    .map((noticia) => _cardBuild(noticia))
                    .toList(),
              );
          }),
    );
  }

  Widget _cardBuild(NoticiaModel noticia) {
    return Card(
        elevation: 10,
        child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/comunicacao/crud_page',
                  arguments: noticia.id);
            },
            child: Container(
              padding: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    // padding: EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      "${noticia.titulo}",
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                  Text("Publicar em: ${noticia.publicar}\n"),
                  MarkdownBody(
                    data: "${noticia.textoMarkdown}",
                  ),
                ],
              ),
            )));
  }
}
