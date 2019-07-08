import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/models/noticia_model.dart';
import 'package:pmsbmibile3/pages/comunicacao/communication_create_edit.dart';
import 'package:provider/provider.dart';

import 'communication_bloc.dart';
import 'modal_filter_list.dart';

class CommunicationPage extends StatefulWidget {
  @override
  _CommunicationPageState createState() => _CommunicationPageState();
}

class _CommunicationPageState extends State<CommunicationPage> {
  final bloc = CommunicationBloc(Bootstrap.instance.firestore);

  @override
  Widget build(BuildContext context) {
    return Provider<CommunicationBloc>.value(
      value: bloc,
      child: DefaultScaffold(
        backgroundColor: Colors.red,
        body: _body(context),
        title: Text("Comunicação"),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.pushNamed(context, '/comunicacao/criar_editar');
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
          stream: bloc.noticias,
          initialData: [],
          builder: (context, snapshot) {
            if (snapshot.hasError)
              return Center(
                child: Text("Error"),
              );
            if (snapshot.hasData && snapshot.data == null)
              return Center(
                child: Text("Nenhuma noticia"),
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

  Widget _appBarBuild(context) {
    return AppBar(
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            modalEscolhaDeTipoFiltro(context);
          },
        ),
        //MoreAppAction(),
      ],
      //leading: Text("leading"),
      centerTitle: true,
      title: Text("Eixo de comunicaçsão"),
    );
  }

  Widget _cardBuild(NoticiaModel noticia) {
    return Card(
        elevation: 10,
        child: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  "# ${noticia.titulo}",
                  style: Theme.of(context).textTheme.title,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Text("# ${noticia.dataPublicacao}"),
              ),
              MarkdownBody(
                data: noticia.conteudoMarkdown,
              ),
              Divider(),
              ButtonTheme.bar(
                child: ButtonBar(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        bloc.dispatch(DeleteCommunicationEvent(noticia.id));
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.pushNamed(
                            context, '/comunicacao/criar_editar',
                            arguments: noticia.id);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
