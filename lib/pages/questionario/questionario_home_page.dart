import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/components/eixo.dart';
import 'package:pmsbmibile3/pages/page_arguments.dart';
import 'package:pmsbmibile3/pages/questionario/questionario_home_page_bloc.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/services/gerador_md_service.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/services/services.dart';
import 'package:pmsbmibile3/naosuportato/url_launcher.dart'
    if (dart.library.io) 'package:url_launcher/url_launcher.dart';

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
    bloc =
        QuestionarioHomePageBloc(Bootstrap.instance.firestore, widget.authBloc);
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  _bodyPastas(context) {
    return Container(
        child: Center(
            child: Text("Em construção", style: TextStyle(fontSize: 18))));
  }

  _bodyTodos() {
    return StreamBuilder<QuestionarioHomePageBlocState>(
      stream: bloc.stateStream,
      builder: (BuildContext context,
          AsyncSnapshot<QuestionarioHomePageBlocState> snapshot) {
        if (snapshot.hasError) {
          return Text("ERROR");
        }
        if (!snapshot.hasData) {
          return Text("SEM DADOS");
        }
        List<Widget> list = List<Widget>();
        if (snapshot.data.isDataValid) {
          int lengthEscolha = snapshot.data?.questionarioMap?.length;
          int ordemLocal = 1;
          snapshot.data.questionarioMap.forEach((questID, questionario) {
            final i = ordemLocal;
            list.add(Card(
              elevation: 10,
              child: Column(
                children: <Widget>[
                  ListTile(
                    trailing: Text('${ordemLocal}'),
                    title: Text('${questionario.nome}'),
                  ),
                  Wrap(
                    alignment: WrapAlignment.start,
                    children: <Widget>[
                      IconButton(
                        tooltip: 'Criar perguntas neste questionário',
                        icon: Icon(Icons.list),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/pergunta/home',
                            arguments: questionario.id,
                          );
                        },
                      ),
           
                      snapshot.data?.relatorioPdfMakeModel?.pdfGerar != null &&
                              snapshot.data?.relatorioPdfMakeModel?.pdfGerar ==
                                  false &&
                              snapshot.data?.relatorioPdfMakeModel?.pdfGerado ==
                                  true &&
                              snapshot.data?.relatorioPdfMakeModel?.tipo ==
                                  'questionario02' &&
                              snapshot.data?.relatorioPdfMakeModel?.document ==
                                  questionario.id
                          ? IconButton(
                              tooltip: 'Ver relatório desta questionario.',
                              icon: Icon(Icons.link),
                              onPressed: () async {
                                bloc.eventSink(GerarRelatorioPdfMakeEvent(
                                    pdfGerar: false,
                                    pdfGerado: false,
                                    tipo: 'questionario02',
                                    collection: 'Questionario',
                                    document: questionario.id));
                                launch(
                                    snapshot.data?.relatorioPdfMakeModel?.url);
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
                                  snapshot.data?.relatorioPdfMakeModel?.tipo ==
                                      'questionario02' &&
                                  snapshot.data?.relatorioPdfMakeModel
                                          ?.document ==
                                      questionario.id
                              ? CircularProgressIndicator()
                              : IconButton(
                                  tooltip: 'Atualizar PDF deste questionario.',
                                  icon: Icon(Icons.picture_as_pdf),
                                  onPressed: () async {
                                    bloc.eventSink(GerarRelatorioPdfMakeEvent(
                                        pdfGerar: true,
                                        pdfGerado: false,
                                        tipo: 'questionario02',
                                        collection: 'Questionario',
                                        document: questionario.id));
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
                                      OrdenarQuestionarioEvent(questID, false));
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
                                      OrdenarQuestionarioEvent(questID, true));
                                }
                              : null),
                   
                      IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              "/questionario/form",
                              arguments: questionario.id,
                            );
                          }),
                    ],
                  ),
                ],
              ),
            ));
            ordemLocal++;
          });
          list.add(
            Container(
              padding: EdgeInsets.only(top: 80),
            ),
          );
          return Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 10,
                    child:
                        Text('Eixo: ${snapshot.data.usuarioModel.eixoID.nome}'),
                  ),
                  Wrap(alignment: WrapAlignment.start, children: <Widget>[
                   
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
                                  document:
                                      snapshot.data.usuarioModel.eixoID.id));
                              launch(snapshot.data?.relatorioPdfMakeModel?.url);
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
                                snapshot.data?.relatorioPdfMakeModel?.tipo ==
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
                  ]),
                ],
              ),
            
              Expanded(
                flex: 10,
                child: ListView(
                  children: list,
                ),
              )
            ],
          );
        } else {
          return Text('Dados inválidos...');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: DefaultScaffold(
        title: Text('Questionários'),
        body: _bodyTodos(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, "/questionario/form");
          },
        ),
      ),
    );
  }
}
