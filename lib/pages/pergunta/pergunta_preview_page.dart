import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/pages/pergunta/pergunta_preview_bloc.dart';
import 'package:queries/collections.dart';

class PerguntaPreviewPage extends StatelessWidget {
  final String perguntaID;
  final PerguntaPreviewBloc bloc;

  PerguntaPreviewPage({this.perguntaID})
      : bloc = PerguntaPreviewBloc(Bootstrap.instance.firestore){
        bloc.eventSink(UpdatePerguntaIDEvent(perguntaID: perguntaID));
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
    return StreamBuilder<PerguntaPreviewPageState>(
        stream: bloc.stateStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("ERROR");
          }
          if (!snapshot.hasData) {
            return Text("SEM DADOS");
          }
          // return Markdown(data: snapshot.data.textoMarkdown);
          StringBuffer texto = new StringBuffer();
          // texto.writeln("## Titulo da pergunta");
          texto.writeln("## ${snapshot.data.perguntaModel.titulo}");
          // texto.writeln("## Texto da pergunta");
          texto.writeln("### ${snapshot.data.perguntaModel.textoMarkdown}");

          List<Widget> escolhas = List<Widget>();
          if (snapshot.data?.escolhas != null &&
              snapshot.data.escolhas.isNotEmpty) {
            texto.writeln("#### Opções de escolha:");
            Map<String, Escolha> escolhaMap = Map<String, Escolha>();
            var dicEscolhas = Dictionary.fromMap(snapshot.data.escolhas);
            var escolhasAscOrder = dicEscolhas
                .orderBy((kv) => kv.value.ordem)
                .toDictionary$1((kv) => kv.key, (kv) => kv.value);
            escolhaMap = escolhasAscOrder.toMap();

            escolhaMap.forEach((k, v) {
              texto.writeln("- ${v.texto}");
            });
          }
            texto.writeln("---");
            texto.writeln("#### Observações:");
            texto.writeln("Pergunta tipo: ${snapshot.data.perguntaModel.tipo.nome}");
          List<Widget> requisitos = List<Widget>();
          if (snapshot.data?.requisitos != null &&
              snapshot.data.requisitos.isNotEmpty) {
            texto.writeln("##### Requisitos:");
            texto.writeln("Esta pergunta somente será respondida se os requisitos a seguir forem simultânea e completamente atendidos.");
            snapshot.data.requisitos?.forEach((k, v) {
              if (v.label != null) {
                texto.writeln("- ${v.label}");
              }
              if (v.escolha != null && v.escolha.label != null) {
                texto.writeln("- ${v.escolha.label} (${v.escolha.marcada})");
              }
            });
          }
          return Markdown(data: texto.toString());
        });
  }
}
