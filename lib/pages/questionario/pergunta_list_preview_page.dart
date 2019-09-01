import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/models/questionario_model.dart';
import 'package:pmsbmibile3/pages/questionario/pergunta_list_preview_bloc.dart';
import 'package:pmsbmibile3/services/gerador_md_service.dart';
import 'package:queries/collections.dart';

class PerguntaListPreviewPage extends StatelessWidget {
  final String questionarioID;
  final PerguntaListPreviewBloc bloc;

  PerguntaListPreviewPage({this.questionarioID})
      : bloc = PerguntaListPreviewBloc(Bootstrap.instance.firestore) {
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
    return StreamBuilder<PerguntaListPreviewPageState>(
        stream: bloc.stateStream,
        builder: (BuildContext context,
            AsyncSnapshot<PerguntaListPreviewPageState> snapshot) {
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
