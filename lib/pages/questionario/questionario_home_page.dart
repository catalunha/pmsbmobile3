import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/components/eixo.dart';
import 'package:pmsbmibile3/models/questionario_model.dart';
import 'package:pmsbmibile3/pages/page_arguments.dart';
import 'package:pmsbmibile3/pages/questionario/questionario_home_page_bloc.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/services/gerador_md_service.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/services/services.dart';

class QuestionarioHomePage extends StatelessWidget {
  final QuestionarioHomePageBloc bloc;
  final AuthBloc authBloc;
  QuestionarioHomePage(this.authBloc)
      : bloc = QuestionarioHomePageBloc(Bootstrap.instance.firestore, authBloc);

  _bodyPastas(context) {
    return Container(
        child: Center(
            child: Text("Em construção", style: TextStyle(fontSize: 18))));
  }

  // _bodyTodos(context) {
  //   return ListView(
  //     children: <Widget>[
  //       Container(
  //         padding: EdgeInsets.only(top: 15, bottom: 15),
  //         child: Center(
  //           child: EixoAtualUsuario(authBloc),
  //         ),
  //       ),
  //       StreamBuilder<List<QuestionarioModel>>(
  //           stream: bloc.questionarios,
  //           builder: (context, snapshot) {
  //             if (snapshot.hasError) {
  //               return Center(
  //                 child: Text("ERROR"),
  //               );
  //             }
  //             if (!snapshot.hasData) {
  //               return Center(
  //                 child: Text("SEM DADOS"),
  //               );
  //             }
  //             if (snapshot.data.isEmpty) {
  //               return Center(child: Text("Nenhum Questionario"));
  //             }
  //             return Column(
  //               children: [
  //                 ...snapshot.data
  //                     .map((questionario) => QuestionarioItem(questionario))
  //                     .toList(),
  //               ],
  //             );
  //           }),
  //     ],
  //   );
  // }

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
                    // leading: Text('${ordemLocal} (${v.ordem})'),
                    leading: Text('${ordemLocal}'),
                    title: Text('${questionario.nome}'),
                    subtitle: Text('${questionario.id}'),
                  ),
                  ButtonTheme.bar(
                    child: ButtonBar(
                      alignment: MainAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          tooltip: 'Criar perguntas neste questionário',
                          icon: Icon(Icons.list),
                          onPressed: () {
                            // Listar paginas de perguntas
                            Navigator.pushNamed(
                              context,
                              '/pergunta/home',
                              arguments: questionario.id,
                            );
                          },
                        ),
                        IconButton(
                          tooltip: 'Conferir todas as perguntas criadas',
                          icon: Icon(Icons.picture_as_pdf),
                          onPressed: () async {
                            var mdtext = await GeradorMdService
                                .generateMdFromQuestionarioModel(questionario);
                            GeradorPdfService.generatePdfFromMd(mdtext);
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
                                    bloc.eventSink(OrdenarQuestionarioEvent(
                                        questID, false));
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
                                    bloc.eventSink(OrdenarQuestionarioEvent(
                                        questID, true));
                                  }
                                : null),
                        IconButton(
                          icon: Icon(Icons.message),
                          tooltip: 'Chat para o produto',
                          onPressed: () {
                            Navigator.pushNamed(context, '/chat/home',
                                arguments: ChatPageArguments(
                                    chatID: questionario.id,
                                    modulo: 'Q: ${questionario.eixo.nome}.',
                                    titulo: 'T: ${questionario.nome}. '));
                          },
                        ),
                        IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              // Editar uma nova escolha
                              Navigator.pushNamed(
                                context,
                                "/questionario/form",
                                arguments: questionario.id,
                              );
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ));
            ordemLocal++;
          });
          return Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: Center(
                    child: EixoAtualUsuario(authBloc),
                  ),
                ),
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

  _body(context) {
    return TabBarView(
      children: [
        _bodyTodos(),
        _bodyPastas(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: DefaultScaffold(
        bottom: TabBar(
          tabs: [
            Tab(text: "Todos"),
            Tab(text: "Pastas"),
          ],
        ),
        title: Text('Questionarios'),
        body: _body(context),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            // Adicionar novo questionario a lista
            Navigator.pushNamed(context, "/questionario/form");
          },
        ),
      ),
      // ),
    );
  }

  void dispose() {
    bloc.dispose();
  }
}
