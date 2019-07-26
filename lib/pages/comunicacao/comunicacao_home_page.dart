import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/models/noticia_model.dart';
import 'package:pmsbmibile3/services/gerador_md_service.dart';
import 'package:pmsbmibile3/services/gerador_pdf_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'comunicacao_home_page_bloc.dart';
// import 'modal_filter_list.dart';

class ComunicacaoHomePage extends StatefulWidget {
  @override
  _ComunicacaoHomePageState createState() => _ComunicacaoHomePageState();
}

class _ComunicacaoHomePageState extends State<ComunicacaoHomePage> {
  final bloc = ComunicacaoHomePageBloc(Bootstrap.instance.firestore);
  //auxiliares
  var noticiaModelListData;

  @override
  Widget build(BuildContext context) {
    // return Provider<ComunicacaoHomePageBloc>.value(
    //   value: bloc,
    //   child:
    return DefaultTabController(
      length: 2,
      child: DefaultScaffold(
        bottom: TabBar(
          tabs: <Widget>[
            Tab(
              text: 'Em edição',
            ),
            Tab(
              text: 'Publicadas',
            ),
          ],
        ),
        title: Text("Notícias"),

        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(choices[0].icon),
        //     onPressed: () {
        //       _select(choices[0]);
        //     },
        //   ),
        // ],
        body: _body(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.pushNamed(context, '/comunicacao/crud_page');
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
      ),
      // ),
    );
  }

  Widget _body(context) {
    return TabBarView(
      children: <Widget>[
        _bodyEmEdicao(context),
        _bodyPublicadas(context),
      ],
    );
  }

  Widget _bodyEmEdicao(context) {
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

  Widget _bodyPublicadas(context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 9,
          child: StreamBuilder<List<NoticiaModel>>(
              stream: bloc.noticiaModelListPublicadasStream,
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
                    child: Text("Nenhuma notícia criada."),
                  );
                } else {
                  noticiaModelListData = snapshot.data;
                  return Column(
                    children: <Widget>[
                      Expanded(
                        child: ButtonTheme.bar(
                          child: ButtonBar(
                            children: <Widget>[
                              // Text('csv'),
                              // IconButton(
                              //   icon: Icon(Icons.border_bottom),
                              //   onPressed: () {
                              //     // launch(snapshotState.data.urlCSV);
                              //   },
                              // ),
                              // Text('web'),
                              // IconButton(
                              //   icon: Icon(Icons.web),
                              //   onPressed: () {
                              //     // launch(snapshotState.data.urlMD);
                              //   },
                              // ),
                              // Text('pdf'),
                              IconButton(
                                icon: Icon(Icons.picture_as_pdf),
                                onPressed: () {
                                  // launch(snapshotState.data.urlPDF);
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

// Expanded(
//   flex: 1,
//   child: StreamBuilder<ComunicacaoHomePageState>(
//     stream: bloc.comunicacaoHomePageStateStream,
//     builder: (BuildContext context,
//         AsyncSnapshot<ComunicacaoHomePageState> snapshotState) {
//       if (snapshotState.hasError) {
//         return Center(
//           child: Text("Error"),
//         );
//       }
//       if (!snapshotState.hasData) {
//         return Center(
//           child: CircularProgressIndicator(),
//         );
//       }
//       // noticiaModelData = snapshotState.data.;

//       return ButtonTheme.bar(
//         child: ButtonBar(
//           children: <Widget>[
//             // Text('csv'),
//             // IconButton(
//             //   icon: Icon(Icons.border_bottom),
//             //   onPressed: () {
//             //     // launch(snapshotState.data.urlCSV);
//             //   },
//             // ),
//             // Text('web'),
//             // IconButton(
//             //   icon: Icon(Icons.web),
//             //   onPressed: () {
//             //     // launch(snapshotState.data.urlMD);
//             //   },
//             // ),
//             // Text('pdf'),
//             IconButton(
//               icon: Icon(Icons.picture_as_pdf),
//               onPressed: () {
//                 // launch(snapshotState.data.urlPDF);
//                 // var mdtext =
//                 //     GeradorMdService.generateMdFromUsuarioModel(
//                 //         noticiaModelData);
//                 // GeradorPdfService.generatePdfFromMd(mdtext);
//               },
//             ),
//           ],
//         ),
//       );
//     },
//   ),
// ),
