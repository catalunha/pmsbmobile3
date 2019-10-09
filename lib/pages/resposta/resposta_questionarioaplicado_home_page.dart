import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/models/questionario_model.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/resposta/resposta_questionarioaplicado_home_bloc.dart';
import 'package:pmsbmibile3/services/gerador_md_service.dart';
import 'package:pmsbmibile3/services/gerador_pdf_service.dart';
import 'package:pmsbmibile3/services/pdf_create_service.dart';
import 'package:pmsbmibile3/services/pdf_save_service.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/naosuportato/url_launcher.dart'
    if (dart.library.io) 'package:url_launcher/url_launcher.dart';

class RespostaQuestionarioAplicadoHomePage extends StatefulWidget {
  final AuthBloc authBloc;

  const RespostaQuestionarioAplicadoHomePage(this.authBloc, {Key key}) : super(key: key);

  @override
  _RespostaQuestionarioAplicadoHomePageState createState() {
    return _RespostaQuestionarioAplicadoHomePageState(authBloc);
  }
}

class _RespostaQuestionarioAplicadoHomePageState extends State<RespostaQuestionarioAplicadoHomePage> {
  final RespostaQuestionarioAplicadoHomeBloc bloc;

  _RespostaQuestionarioAplicadoHomePageState(AuthBloc authBloc)
      : bloc = RespostaQuestionarioAplicadoHomeBloc(authBloc, Bootstrap.instance.firestore);

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
        builder: (BuildContext context, AsyncSnapshot<RespostaQuestionarioAplicadoHomeState> snapshot) {
          if (snapshot.hasError) {
            return Text("ERROR");
          }
          if (!snapshot.hasData) {
            return Text("SEM DADOS");
          }
          if (snapshot.hasData) {
            List<Widget> listaWdg = List<Widget>();
            Widget icone;
            if (snapshot.data.isDataValid) {
              for (var questionarioAplicado in snapshot.data.questionarioAplicadoList) {
                // icone = CircularProgressIndicator();

                if (snapshot.data?.relatorioPdfMakeModel?.tipo == 'resposta01' &&
                    snapshot.data?.relatorioPdfMakeModel?.document == questionarioAplicado.id &&
                    snapshot.data?.relatorioPdfMakeModel?.pdfGerar == false &&
                    snapshot.data?.relatorioPdfMakeModel?.pdfGerado == true) {
                  icone = IconButton(
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
                  );
                }
                if (snapshot.data?.relatorioPdfMakeModel?.tipo == 'resposta01' &&
                    snapshot.data?.relatorioPdfMakeModel?.document == questionarioAplicado.id &&
                    snapshot.data?.relatorioPdfMakeModel?.pdfGerar == false &&
                    snapshot.data?.relatorioPdfMakeModel?.pdfGerado == false) {
                  icone = IconButton(
                    tooltip: 'Atualizar PDF geral das tarefas recebidas.',
                    icon: Icon(Icons.picture_as_pdf),
                    onPressed: () async {
                      bloc.eventSink(GerarRelatorioPdfMakeEvent(
                          pdfGerar: true,
                          pdfGerado: false,
                          tipo: 'resposta01',
                          collection: 'QuestionarioAplicado',
                          document: questionarioAplicado.id));
                    },
                  );
                }
                if (snapshot.data?.relatorioPdfMakeModel?.tipo == 'resposta01' &&
                    snapshot.data?.relatorioPdfMakeModel?.document == questionarioAplicado.id &&
                    snapshot.data?.relatorioPdfMakeModel?.pdfGerar == true &&
                    snapshot.data?.relatorioPdfMakeModel?.pdfGerado == false) {
                  icone = CircularProgressIndicator();
                }
                listaWdg.add(ListTile(
                  title: Text(
                      'Questionário: ${questionarioAplicado.nome}\nReferência: ${questionarioAplicado.referencia}'),
                  // subtitle: Text(
                  //     'Aplicador: ${questionarioAplicado.aplicador.nome}\nAplicado: ${questionarioAplicado.aplicado}\nid: ${questionarioAplicado.id}'),
                  trailing: icone,
                  // trailing: snapshot.data?.relatorioPdfMakeModel?.pdfGerar != null &&
                  //         snapshot.data?.relatorioPdfMakeModel?.pdfGerar == false &&
                  //         snapshot.data?.relatorioPdfMakeModel?.pdfGerado == true &&
                  //         snapshot.data?.relatorioPdfMakeModel?.tipo == 'resposta01' &&
                  //         snapshot.data?.relatorioPdfMakeModel?.document == questionarioAplicado.id
                  //     ? IconButton(
                  //         tooltip: 'Ver relatório geral das tarefas recebidas.',
                  //         icon: Icon(Icons.link),
                  //         onPressed: () async {
                  //           bloc.eventSink(GerarRelatorioPdfMakeEvent(
                  //               pdfGerar: false,
                  //               pdfGerado: false,
                  //               tipo: 'resposta01',
                  //               collection: 'QuestionarioAplicado',
                  //               document: questionarioAplicado.id));
                  //           launch(snapshot.data?.relatorioPdfMakeModel?.url);
                  //         },
                  //       )
                  //     : IconButton(
                  //         tooltip: 'Atualizar PDF geral das tarefas recebidas.',
                  //         icon: Icon(Icons.picture_as_pdf),
                  //         onPressed: () async {
                  //           bloc.eventSink(GerarRelatorioPdfMakeEvent(
                  //               pdfGerar: true,
                  //               pdfGerado: false,
                  //               tipo: 'resposta01',
                  //               collection: 'QuestionarioAplicado',
                  //               document: questionarioAplicado.id));
                  //         },
                  //       ),
                ));
              }
              return ListView(
                children: listaWdg,
              );
            } else {
              return Text('Existem dados inválidos...');
            }
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

class _CardText extends StatelessWidget {
  final String text;

  const _CardText(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2, left: 5),
      child: Text(
        text,
        // style: TextStyle(fontSize: 15),
      ),
    );
  }
}

// class QuestionarioAplicadoItem extends StatelessWidget {
//   final QuestionarioAplicadoModel _questionario;
//   final RespostaQuestionarioAplicadoHomeBloc bloc;
//   const QuestionarioAplicadoItem(this.bloc, this._questionario, {Key key})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//         elevation: 10,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             // _CardText("id: ${_questionario.id}"),
//             _CardText("Questionário: ${_questionario.nome}"),
//             _CardText("Referência: ${_questionario.referencia}"),
//             _CardText("Aplicador: ${_questionario.aplicador.nome}"),
//             _CardText("Aplicado: ${_questionario.aplicado.toDate()}"),
//             _CardText("id: ${_questionario.id}"),
//             ButtonTheme.bar(
//               child: ButtonBar(
//                 children: <Widget>[
//                   // IconButton(
//                   //   tooltip: 'Lista das respostas em PDF',
//                   //   icon: Icon(Icons.picture_as_pdf),
//                   //   onPressed: () async {
//                   //     var mdtext = await GeradorMdService
//                   //         .generateMdFromQuestionarioAplicadoModel(
//                   //             _questionario);
//                   //     GeradorPdfService.generatePdfFromMd(mdtext);
//                   //   },
//                   // ),
//                   // IconButton(
//                   //   tooltip: 'Relatorio em tela',
//                   //   icon: Icon(Icons.text_fields),
//                   //   onPressed: () {
//                   //     Navigator.pushNamed(context, "/resposta/pergunta",
//                   //         arguments: _questionario.id);
//                   //   },
//                   // ),
//                   // IconButton(
//                   //   tooltip: 'Google Docs das respostas',
//                   //   icon: Icon(Icons.book),
//                   //   onPressed: () {
//                   //     bloc.eventSink(CreateRelatorioEvent(_questionario));
//                   //   },
//                   // ),
//                   // IconButton(
//                   //   tooltip: 'Relatorio em PDF.',
//                   //   icon: Icon(Icons.picture_as_pdf),
//                   //   onPressed: () async {
//                   //     var pdf = await PdfCreateService
//                   //         .createPdfForQuestionarioAplicadoModel(_questionario);
//                   //     PdfSaveService.generatePdfAndOpen(pdf);
//                   //   },
//                   // ),

//                   bloc.snapshot.data?.relatorioPdfMakeModel?.pdfGerar != null &&
//                           snapshot.data?.relatorioPdfMakeModel?.pdfGerar ==
//                               false &&
//                           snapshot.data?.relatorioPdfMakeModel?.pdfGerado ==
//                               true &&
//                           snapshot.data?.relatorioPdfMakeModel?.tipo ==
//                               'controle01'
//                       ? IconButton(
//                           tooltip: 'Ver relatório geral das tarefas recebidas.',
//                           icon: Icon(Icons.link),
//                           onPressed: () async {
//                             bloc.eventSink(GerarRelatorioPdfMakeEvent(
//                                 pdfGerar: false,
//                                 pdfGerado: false,
//                                 tipo: 'controle01',
//                                 collection: 'Usuario',
//                                 document: snapshot.data.usuarioID.id));
//                             launch(snapshot.data?.relatorioPdfMakeModel?.url);
//                           },
//                         )
//                       : IconButton(
//                           tooltip: 'Atualizar PDF geral das tarefas recebidas.',
//                           icon: Icon(Icons.picture_as_pdf),
//                           onPressed: () async {
//                             bloc.eventSink(GerarRelatorioPdfMakeEvent(
//                                 pdfGerar: true,
//                                 pdfGerado: false,
//                                 tipo: 'controle01',
//                                 collection: 'Usuario',
//                                 document: snapshot.data.usuarioID.id));
//                           },
//                         ),
//                 ],
//               ),
//             )
//           ],
//         ));
//   }
// }
