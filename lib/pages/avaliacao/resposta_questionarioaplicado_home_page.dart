import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/resposta/resposta_questionarioaplicado_home_bloc.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/naosuportato/url_launcher.dart'
    if (dart.library.io) 'package:url_launcher/url_launcher.dart';


class RespostaQuestionarioAplicadoHomePage extends StatefulWidget {
  final AuthBloc authBloc;

  const RespostaQuestionarioAplicadoHomePage(this.authBloc, {Key key})
      : super(key: key);

  @override
  _RespostaQuestionarioAplicadoHomePageState createState() {
    return _RespostaQuestionarioAplicadoHomePageState(authBloc);
  }
}

class _RespostaQuestionarioAplicadoHomePageState
    extends State<RespostaQuestionarioAplicadoHomePage> {
  final RespostaQuestionarioAplicadoHomeBloc bloc;

  _RespostaQuestionarioAplicadoHomePageState(AuthBloc authBloc)
      : bloc = RespostaQuestionarioAplicadoHomeBloc(
            authBloc, Bootstrap.instance.firestore);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  _listaQuestionarioAplicado() {
    return StreamBuilder<RespostaQuestionarioAplicadoHomeState>(
        stream: bloc.stateStream,
        builder: (BuildContext context,
            AsyncSnapshot<RespostaQuestionarioAplicadoHomeState> snapshot) {
          if (snapshot.hasError) {
            return Text("ERROR");
          }
          if (!snapshot.hasData) {
            return Text("SEM DADOS");
          }
          List<Widget> listaWdg = List<Widget>();
          if (snapshot.data.isDataValid) {
            for (var questionarioAplicado
                in snapshot.data.questionarioAplicadoList) {
              listaWdg.add(Card(
                  child: ListTile(
                title: Text(
                    'Questionário: ${questionarioAplicado.nome}\nReferência: ${questionarioAplicado.referencia}'),
                subtitle: Text(
                    'Aplicador: ${questionarioAplicado.aplicador.nome}\nAplicado: ${questionarioAplicado.aplicado} \nid: ${questionarioAplicado.id}'),
                trailing: snapshot.data?.relatorioPdfMakeModel?.pdfGerar !=
                            null &&
                        snapshot.data?.relatorioPdfMakeModel?.pdfGerar ==
                            false &&
                        snapshot.data?.relatorioPdfMakeModel?.pdfGerado ==
                            true &&
                        snapshot.data?.relatorioPdfMakeModel?.tipo ==
                            'resposta01' &&
                        snapshot.data?.relatorioPdfMakeModel?.document ==
                            questionarioAplicado.id
                    ? IconButton(
                        tooltip: 'Ver relatório geral das tarefas recebidas.',
                        icon: Icon(Icons.link),
                        onPressed: () async {
                          bloc.eventSink(GerarRelatorioPdfMakeEvent(
                              pdfGerar: false,
                              pdfGerado: false,
                              tipo: 'resposta01',
                              collection: 'QuestionarioAplicado',
                              document: questionarioAplicado.id));
                          launch(snapshot.data?.relatorioPdfMakeModel?.url);
                        },
                      )
                    : snapshot.data?.relatorioPdfMakeModel?.pdfGerar != null &&
                            snapshot.data?.relatorioPdfMakeModel?.pdfGerar ==
                                true &&
                            snapshot.data?.relatorioPdfMakeModel?.pdfGerado ==
                                false &&
                            snapshot.data?.relatorioPdfMakeModel?.tipo ==
                                'resposta01' &&
                            snapshot.data?.relatorioPdfMakeModel?.document ==
                                questionarioAplicado.id
                        ? CircularProgressIndicator()
                        : IconButton(
                            tooltip:
                                'Atualizar PDF geral das tarefas recebidas.',
                            icon: Icon(Icons.picture_as_pdf),
                            onPressed: () async {
                              bloc.eventSink(GerarRelatorioPdfMakeEvent(
                                  pdfGerar: true,
                                  pdfGerado: false,
                                  tipo: 'resposta01',
                                  collection: 'QuestionarioAplicado',
                                  document: questionarioAplicado.id));
                            },
                          ),
              )));
            }
            return ListView(
              children: listaWdg,
            );
          } else {
            return Text('Existem dados inválidos...');
          }
        });
  }

  _body() {
    return Column(
      children: <Widget>[Expanded(child: _listaQuestionarioAplicado())],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: DefaultScaffold(
        title: Text('Resposta do questionario'),
        body: _body(),
      ),
    );
  }
}

