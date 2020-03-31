import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/naosuportato/flutter_markdown.dart'
    if (dart.library.io) 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/models/questionario_model.dart';
import 'package:pmsbmibile3/pages/questionario/pergunta_list_preview_bloc.dart';
import 'package:pmsbmibile3/services/gerador_md_service.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
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
    return DefaultScaffold(
      backToRootPage: true,
      body: _bodyPreview(),
      title: Text('Visão geral da Pergunta sad as'),
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
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return Markdown(data: snapshot.data.questionarioPerguntaList2Mkd);
      },
    );
  }
}
