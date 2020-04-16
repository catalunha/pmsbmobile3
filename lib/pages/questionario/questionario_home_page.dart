import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/pages/questionario/questionario_home_page_bloc.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/naosuportato/url_launcher.dart'
    if (dart.library.io) 'package:url_launcher/url_launcher.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';

class QuestionarioHomePage extends StatefulWidget {
  final AuthBloc authBloc;

  const QuestionarioHomePage(this.authBloc, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _QuestionarioHomePageState();
  }
}

class _QuestionarioHomePageState extends State<QuestionarioHomePage> {
  QuestionarioHomePageBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = QuestionarioHomePageBloc(Bootstrap.instance.firestore, widget.authBloc);
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  _bodyPastas(context) {
    return Container(
      child: Center(
        child: Text(
          "Em construção",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  _bodyTodos() {
    return Container(
      color: PmsbColors.fundo,
      child: StreamBuilder<QuestionarioHomePageBlocState>(
        stream: bloc.stateStream,
        builder: (BuildContext context,
            AsyncSnapshot<QuestionarioHomePageBlocState> snapshot) {
          if (snapshot.hasError) {
            return Text("ERROR");
          }

          if (!snapshot.hasData) {
            return Text("SEM DADOS");
          }

          // Lista de questionarios

          List<Widget> list = List<Widget>();

          if (snapshot.data.isDataValid) {
            int lengthEscolha = snapshot.data?.questionarioMap?.length;
            int ordemLocal = 1;
            snapshot.data.questionarioMap.forEach(
              (questID, questionario) {
                final i = ordemLocal;
                list.add(
                  Container(
                    height: 130,
                    color: Colors.transparent,
                    key: ValueKey("value$ordemLocal"),
                    child: Card(
                      color: PmsbColors.card,
                      elevation: 10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          ListTile(
                            trailing: Text('${ordemLocal}'),
                            title: Text('${questionario.nome}'),
                          ),
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            children: <Widget>[

                              IconButton(
                                tooltip: 'Criar perguntas neste questionário',
                                color: Colors.pink,
                                icon: Icon(Icons.list),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/pergunta/home',
                                    arguments: questionario.id,
                                  );
                                },
                              ),
                              snapshot.data?.relatorioPdfMakeModel?.pdfGerar !=
                                          null &&
                                      snapshot.data?.relatorioPdfMakeModel
                                              ?.pdfGerar ==
                                          false &&
                                      snapshot.data?.relatorioPdfMakeModel
                                              ?.pdfGerado ==
                                          true &&
                                      snapshot.data?.relatorioPdfMakeModel
                                              ?.tipo ==
                                          'questionario02' &&
                                      snapshot.data?.relatorioPdfMakeModel
                                              ?.document ==
                                          questionario.id
                                  ? IconButton(
                                      tooltip:
                                          'Ver relatório deste questionario.',
                                      icon: Icon(
                                        Icons.link,
                                        color: Colors.green,
                                      ),
                                      onPressed: () async {
                                        bloc.eventSink(
                                            GerarRelatorioPdfMakeEvent(
                                                pdfGerar: false,
                                                pdfGerado: false,
                                                tipo: 'questionario02',
                                                collection: 'Questionario',
                                                document: questionario.id));
                                        launch(snapshot
                                            .data?.relatorioPdfMakeModel?.url);
                                      },
                                    )
                                  : snapshot.data?.relatorioPdfMakeModel
                                                  ?.pdfGerar !=
                                              null &&
                                          snapshot.data?.relatorioPdfMakeModel
                                                  ?.pdfGerar ==
                                              true &&
                                          snapshot.data?.relatorioPdfMakeModel
                                                  ?.pdfGerado ==
                                              false &&
                                          snapshot.data?.relatorioPdfMakeModel
                                                  ?.tipo ==
                                              'questionario02' &&
                                          snapshot.data?.relatorioPdfMakeModel
                                                  ?.document ==
                                              questionario.id
                                      ? CircularProgressIndicator()
                                      : IconButton(
                                          tooltip:
                                              'Atualizar PDF deste questionario.',
                                          icon: Icon(Icons.picture_as_pdf, color: Colors.green,),
                                          onPressed: () async {
                                            bloc.eventSink(
                                                GerarRelatorioPdfMakeEvent(
                                                    pdfGerar: true,
                                                    pdfGerado: false,
                                                    tipo: 'questionario02',
                                                    collection: 'Questionario',
                                                    document: questionario.id));
                                          },
                                        ),
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue,),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    "/questionario/form",
                                    arguments: questionario.id,
                                  );
                                },
                              ),
                              IconButton(
                                  icon: Icon(Icons.arrow_downward),
                                  onPressed: (ordemLocal) < lengthEscolha
                                      ? () {
                                          // print(
                                          //     'em  down => ${i} ${ordemLocal} (${v.ordem})');
                                          // Mover pra baixo na ordem
                                          //TODO: refatorar este codigo com o i fica mais fácil
                                          bloc.eventSink(
                                            OrdenarQuestionarioEvent(
                                                questID, false),
                                          );
                                        }
                                      : null),
                              IconButton(
                                  icon: Icon(Icons.arrow_upward),
                                  onPressed: ordemLocal > 1
                                      ? () {
                                          // print(
                                          //     'em up => ${i} ${ordemLocal} (${v.ordem})');

                                          // Mover pra cima na ordem
                                          //TODO: refatorar este codigo com o i fica mais fácil
                                          bloc.eventSink(
                                            OrdenarQuestionarioEvent(
                                                questID, true),
                                          );
                                        }
                                      : null),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
                ordemLocal++;
              },
            );

            // list.add(
            //   Container(
            //     padding: EdgeInsets.only(top: 80),
            //   ),
            // );
            return Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    //Expanded(
                    //flex: 10,
                    //child:
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                        color: Colors.black12,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          " ${snapshot.data.usuarioModel.eixoID.nome} ",
                          style: PmsbStyles.textStyleListPerfil01,
                        ),
                      ),
                    ),
                    //),
                    Wrap(
                      alignment: WrapAlignment.start,
                      children: <Widget>[
                        snapshot.data?.relatorioPdfMakeModel?.pdfGerar != null &&
                                snapshot.data?.relatorioPdfMakeModel?.pdfGerar ==
                                    false &&
                                snapshot.data?.relatorioPdfMakeModel?.pdfGerado ==
                                    true &&
                                snapshot.data?.relatorioPdfMakeModel?.tipo ==
                                    'questionario01'
                            ? IconButton(
                                tooltip:
                                    'Ver relatório geral das tarefas recebidas.',
                                icon: Icon(Icons.link),
                                onPressed: () async {
                                  bloc.eventSink(GerarRelatorioPdfMakeEvent(
                                      pdfGerar: false,
                                      pdfGerado: false,
                                      tipo: 'questionario01',
                                      collection: 'Eixo',
                                      document: snapshot
                                          .data.usuarioModel.eixoID.id));
                                  launch(snapshot
                                      .data?.relatorioPdfMakeModel?.url);
                                },
                              )
                            : snapshot.data?.relatorioPdfMakeModel?.pdfGerar !=
                                        null &&
                                    snapshot.data?.relatorioPdfMakeModel
                                            ?.pdfGerar ==
                                        true &&
                                    snapshot.data?.relatorioPdfMakeModel
                                            ?.pdfGerado ==
                                        false &&
                                    snapshot.data?.relatorioPdfMakeModel
                                            ?.tipo ==
                                        'questionario01'
                                ? CircularProgressIndicator()
                                : IconButton(
                                    tooltip:
                                        'Atualizar PDF geral das tarefas recebidas.',
                                    icon: Icon(Icons.picture_as_pdf),
                                    onPressed: () async {
                                      bloc.eventSink(GerarRelatorioPdfMakeEvent(
                                          pdfGerar: true,
                                          pdfGerado: false,
                                          tipo: 'questionario01',
                                          collection: 'Eixo',
                                          document: snapshot
                                              .data.usuarioModel.eixoID.id));
                                    },
                                  ),
                      ],
                    ),
                  ],
                ),
                // Expanded(
                //   flex: 10,
                //   child: ListView(
                //     children: list,
                //   ),
                // )

                

                Expanded(
                    child: ListView(
                  // header: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: <Widget>[
                  //       Text(
                  //         "Eixo: ",
                  //         style: TextStyle(
                  //             color: PmsbColors.texto_secundario,
                  //             fontSize: 14,
                  //             fontWeight: FontWeight.bold),
                  //       ),
                  //       Text(" Palmas", style: PmsbStyles.textStyleListPerfil),
                  //     ]),
                  children: list,
                  // onReorder: (int oldIndex, int newIndex) {
                    // setState(
                    //   () {
                    //     _updateMyItems(oldIndex, newIndex);
                    //   },
                    // );
                  // },
                ))
              ],
            );
          } else {
            return Text('Dados inválidos...');
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold(
    //   body: Container(
    //     color: PmsbColors.fundo,
    //     child: ListView(
    //       children: <Widget>[
    //         Padding(
    //           padding: EdgeInsets.only(bottom: 9, top: 9),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             children: <Widget>[
    //               IconButton(
    //                   icon: Icon(
    //                     Icons.arrow_back,
    //                     size: 30,
    //                     color: PmsbColors.texto_terciario,
    //                   ),
    //                   onPressed: () {
    //                     Navigator.pop(context);
    //                   }),
    //               SizedBox(
    //                 width: 70,
    //               ),
    //               Text(
    //                 "Configurações",
    //                 style: PmsbStyles.textStyleListBold,
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );

    return DefaultTabController(
      length: 2,
      child: DefaultScaffold(
        backToRootPage: true,
        title: Text('Questionários'),
        body: _bodyTodos(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: PmsbColors.cor_destaque,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, "/questionario/form");
          },
        ),
      ),
    );
  }
}
