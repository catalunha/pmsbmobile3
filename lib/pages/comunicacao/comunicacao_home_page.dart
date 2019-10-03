import 'package:flutter/material.dart';
import 'package:pmsbmibile3/naosuportato/flutter_markdown.dart'
    if (dart.library.io) 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/models/noticia_model.dart';
import 'package:pmsbmibile3/pages/chat/chat_page.dart';
import 'package:pmsbmibile3/pages/page_arguments.dart';
import 'package:pmsbmibile3/services/gerador_md_service.dart';
import 'package:pmsbmibile3/services/gerador_pdf_service.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';

import 'comunicacao_home_page_bloc.dart';

class ComunicacaoHomePage extends StatefulWidget {
  final AuthBloc authBloc;

  ComunicacaoHomePage(this.authBloc);

  @override
  _ComunicacaoHomePageState createState() => _ComunicacaoHomePageState();
}

class _ComunicacaoHomePageState extends State<ComunicacaoHomePage>
    with SingleTickerProviderStateMixin {
  final bloc = ComunicacaoHomePageBloc(Bootstrap.instance.firestore);
  var noticiaModelListData;

  // TabController _tabController;
// final List<Tab> myTabs = <Tab>[
//     Tab(text: 'LEFT'),
//     Tab(text: 'RIGHT'),
//     Tab(text: 'RIGHT'),
//   ];
  @override
  void initState() {
    super.initState();
    // _tabController = TabController(vsync: this, length: 3, initialIndex: 0);
    // _tabController.addListener(_handleTabIndex);
  }

  @override
  void dispose() {
    // _tabController.removeListener(_handleTabIndex);
    // _tabController.dispose();
    bloc.dispose();
    super.dispose();
  }

  // void _handleTabIndex() {
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: DefaultScaffold(
          bottom: TabBar(
            // controller: _tabController,
            // tabs: myTabs
            tabs: <Widget>[
              Tab(
                text: 'Em edição',
              ),
              Tab(
                text: 'Publicadas',
              ),
              // Tab(
              //   text: 'Chat',
              // ),
            ],
          ),
          actionsMore: <Widget>[
            IconButton(
              icon: Icon(Icons.message),
              tooltip: "Chat para comunicação",
              onPressed: () {
                Navigator.pushNamed(context, '/chat/home',
                    arguments: ChatPageArguments(
                        chatID: 'comunicacao',
                        modulo: 'Comunicação',
                        titulo: ''));
              },
            )
          ],
          title: Text("Notícias"),
          body: _body(context),
          // floatingActionButton: _tabController.index == 0
          //     ? FloatingActionButton(
          //         onPressed: () async {
          //           Navigator.pushNamed(context, '/comunicacao/crud_page');
          //         },
          //         child: Icon(Icons.add),
          //         backgroundColor: Colors.blue,
          //       )
          //     : null,

          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              Navigator.pushNamed(context, '/comunicacao/crud_page');
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.blue,
          )),
      // ),
    );
  }

  Widget _body(context) {
    return TabBarView(
      // controller: _tabController,
      children: <Widget>[
        _bodyEmEdicao(context),
        _bodyPublicadas(context),
        // _bodyChat(widget.authBloc),
      ],
    );
  }

  // Widget _bodyChat(AuthBloc authBloc) {
  //   return ChatPage(
  //       authBloc: authBloc,
  //       modulo: 'Comunicação',
  //       titulo: '',
  //       chatID: 'comunicacao');
  // }

  Widget _bodyEmEdicao(context) {
    return Container(
      child: StreamBuilder<List<NoticiaModel>>(
          stream: bloc.noticiaModelListEdicaoStream,
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

  Widget _bodyPublicadas(context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 9,
          child: StreamBuilder<List<NoticiaModel>>(
              stream: bloc.noticiaModelListPublicadaStream,
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
                if (snapshot.data.isEmpty) {
                  return Center(
                    child: Text("Nenhuma notícia publicada."),
                  );
                } else {
                  noticiaModelListData = snapshot.data;
                  return Column(
                    children: <Widget>[
                      Expanded(
                        child: ButtonTheme.bar(
                          child: ButtonBar(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.picture_as_pdf),
                                onPressed: () {
                                  var mdtext = GeradorMdService
                                      .generateMdFromNoticiaModelList(
                                          noticiaModelListData);
                                  GeradorPdfService.generatePdfFromMd(mdtext);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 9,
                        child: ListView(
                          children: snapshot.data
                              .map((noticia) => _cardBuildPublicada(noticia))
                              .toList(),
                        ),
                      ),
                    ],
                  );
                }
              }),
        ),
      ],
    );
  }

  Widget _cardBuildPublicada(NoticiaModel noticia) {
    return Card(
        color: Colors.black12,
        elevation: 10,
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
              Text("Publicada em: ${noticia.publicar}\n"),
              MarkdownBody(
                data: "${noticia.textoMarkdown}",
              ),
            ],
          ),
        ));
  }
}
