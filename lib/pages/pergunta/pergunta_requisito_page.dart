import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/pergunta/pergunta_requisito_bloc.dart';
import 'package:pmsbmibile3/pages/pergunta/selecionar_requisito_pergunta_page_bloc.dart';

class PerguntaRequisitoPage extends StatelessWidget {
  final String perguntaID;
  final PerguntaRequisitoBloc bloc;

  PerguntaRequisitoPage({this.perguntaID})
      : bloc = PerguntaRequisitoBloc(Bootstrap.instance.firestore) {
    bloc.eventSink(UpdatePerguntaIDEvent(perguntaID: perguntaID));
  }
  void dispose() {
    bloc.dispose();
  }

  Widget _body() {
    return StreamBuilder<PerguntaRequisitoPageState>(
      stream: bloc.stateStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("ERROR");
        }
        if (!snapshot.hasData) {
          return Text("SEM DADOS");
        }

        final requisitos = snapshot.data.requisitosPerguntaList != null
            ? snapshot.data.requisitosPerguntaList
            : {};

        final widgetRequisitos = requisitos.map(
          (i, e) {
            return MapEntry(
              i,
              Card(
                child: CheckboxListTile(
                  value: e['checkbox'],
                  title: new Text('${e['questionario']}\n${e['pergunta']}'),
                  // subtitle: Text('${e['questionario']}'),
                  controlAffinity: ListTileControlAffinity.trailing,
                  onChanged: (bool val) {
                    bloc.eventSink(UpdateRequisitosListEvent(
                        requisitoUid: i, marcado: val));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.red,
          automaticallyImplyLeading: true,
          title: Text('Selecionar Requisitos'),
        ),
        floatingActionButton: StreamBuilder<PerguntaRequisitoPageState>(
            stream: bloc.stateStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("ERROR");
              }
              if (!snapshot.hasData) {
                return Text("SEM DADOS");
              }
              return FloatingActionButton(
                onPressed: () async {
                  await bloc.eventSink(SaveEvent());
                  await bloc.eventSink(CheckRequisitoEscolhaEvent());
                  if (snapshot.data.temReqEscolha) {
                    await Navigator.pushNamed(
                        context, "/pergunta/pergunta_requisito_marcar",
                        arguments: perguntaID);
                  }
                  Navigator.pop(context);
                },
                child: Icon(Icons.thumb_up),
              );
            }),
        body: _body());
  }
}
