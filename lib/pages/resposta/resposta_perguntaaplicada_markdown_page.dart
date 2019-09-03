import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/resposta/resposta_perguntaaplicada_markdown_bloc.dart';

class RespostaPerguntaAplicadaMarkdownPage extends StatefulWidget {
  final String questionarioID;

  RespostaPerguntaAplicadaMarkdownPage({this.questionarioID});

  _RespostaPerguntaAplicadaMarkdownPageState createState() =>
      _RespostaPerguntaAplicadaMarkdownPageState();
}

class _RespostaPerguntaAplicadaMarkdownPageState
    extends State<RespostaPerguntaAplicadaMarkdownPage> {
  final RespostaPerguntaAplicadaMarkdownBloc bloc =
      RespostaPerguntaAplicadaMarkdownBloc(Bootstrap.instance.firestore);

  @override
  void initState() {
    super.initState();
    bloc.eventSink(
        UpdateQuestionarioIDEvent(questionarioId: widget.questionarioID));
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visão geral das respostas'),
      ),
      body: _bodyPreview(),
    );
  }

  _bodyPreview() {
    return StreamBuilder<RespostaPerguntaAplicadaMarkdownState>(
        stream: bloc.stateStream,
        builder: (BuildContext context,
            AsyncSnapshot<RespostaPerguntaAplicadaMarkdownState> snapshot) {
          if (snapshot.hasError) {
            return Text("ERROR");
          }
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          // return Text("ok...");
          return Markdown(data: snapshot.data.questionarioPerguntaList2Mkd);
        });
  }
}
