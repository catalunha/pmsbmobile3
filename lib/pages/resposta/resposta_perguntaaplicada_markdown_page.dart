import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/resposta/resposta_perguntaaplicada_markdown_bloc.dart';

class RespostaPerguntaAplicadaPage extends StatelessWidget {
  final String questionarioID;
  final RespostaPerguntaAplicadaBloc bloc;

  RespostaPerguntaAplicadaPage({this.questionarioID})
      : bloc = RespostaPerguntaAplicadaBloc(Bootstrap.instance.firestore) {
    bloc.eventSink(UpdateQuestionarioIDEvent(questionarioId: questionarioID));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visão geral da pergunta'),
      ),
      body: _bodyPreview(),
    );
  }

  _bodyPreview() {
    return StreamBuilder<RespostaPerguntaAplicadaState>(
        stream: bloc.stateStream,
        builder: (BuildContext context,
            AsyncSnapshot<RespostaPerguntaAplicadaState> snapshot) {
          if (snapshot.hasError) {
            return Text("ERROR");
          }
          if (!snapshot.hasData) {
            return Text("SEM DADOS");
          }

            return Markdown(data: snapshot.data.questionarioPerguntaList2Mkd);

        });
  }
}
