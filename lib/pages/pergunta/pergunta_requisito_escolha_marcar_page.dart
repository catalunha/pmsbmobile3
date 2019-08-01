import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/pages/pergunta/pergunta_requisito_escolha_marcar_bloc.dart';

class PerguntaRequisitoEscolhaMarcarPage extends StatelessWidget {
  final String perguntaID;
  final PerguntaRequisitoEscolhaMarcarBloc bloc;

  PerguntaRequisitoEscolhaMarcarPage({this.perguntaID})
      : bloc =
            PerguntaRequisitoEscolhaMarcarBloc(Bootstrap.instance.firestore) {
    bloc.eventSink(UpdatePerguntaIDEvent(perguntaID: perguntaID));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Atualizar requisito escolha'),
        ),
        body: Column(
          children: <Widget>[
            Text('      Esta pergunta atual tem como requisito o questionário, pergunta e escolha conforme listado a seguir.'),
            Text('      Quando a aquela pergunta, como listado abaixo, for respondida a escolha deve estar que forma. Marcada ou desmarcada ?'),
            Text('      Para ser considerada como requisito atendido para aplicação desta pergunta atual.'),
            Expanded(
              child: _body(),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
                    bloc.eventSink(
                        SaveEvent());


            Navigator.pop(context);
          },
          child: Icon(Icons.thumb_up),
        ));
  }

  Widget _body() {
    return StreamBuilder<PerguntaRequisitoEscolhaMarcarPageState>(
      stream: bloc.stateStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("ERROR");
        }
        if (!snapshot.hasData) {
          return Text("SEM DADOS");
        }
        Map<String, Requisito> requisitos =
            snapshot.data.requisitoEscolha != null
                ? snapshot.data.requisitoEscolha
                : {};

        final widgetRequisitos = requisitos.map(
          (i, e) {
            return MapEntry(
              i,
              Card(
                child: CheckboxListTile(
                  value: e.escolha.marcada,
                  title: Text('${e.escolha.label}'),
                  // title:  e['requisitoEscolha'] !=null? Text('${e['requisitoEscolha']}'):Text('nulo'),
                  // subtitle: Text('${e['questionario']}'),
                  controlAffinity: ListTileControlAffinity.trailing,
                  onChanged: (bool val) {
                    bloc.eventSink(
                        UpdateReqEscolhaEvent(requisitoUid: i, marcado: val));
                  },
                ),
              ),
            );
          },
        );
        return ListView(
          children: [
            ...widgetRequisitos.values.toList(),
            Container(
              padding: EdgeInsets.only(top: 75),
            ),
          ],
        );
      },
    );
  }
}
