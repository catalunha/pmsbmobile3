import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/models/models.dart';
import 'package:pmsbmibile3/pages/pergunta/pergunta_requisito_bloc.dart';
import 'package:pmsbmibile3/pages/pergunta/selecionar_requisito_pergunta_page_bloc.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';

class PerguntaRequisitoPage extends StatelessWidget {
  final String perguntaID;
  final PerguntaRequisitoBloc bloc;
  bool isGoingDown = true;
  PerguntaRequisitoPage({this.perguntaID})
      : bloc = PerguntaRequisitoBloc(Bootstrap.instance.firestore) {
    bloc.eventSink(UpdatePerguntaIDEvent(perguntaID: perguntaID));

    Bootstrap.instance.authBloc.perfil.listen((usuario) {
      bloc.eventSink(UpdateUsuarioPerguntaRequisitoPageEvent(usuario));
    });
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

        if (snapshot.data.questionario == null) {
          final widgetQuest =
              snapshot.data.questionarios.map((q) => QuestionarioListItem(
                    questionario: q,
                    onSelecionar: () {
                      bloc.eventSink(
                          SelecionarQuestionarioPerguntaRequisitoPageEvent(q));
                    },
                  ));
          return ListView(children: [
            ...widgetQuest.toList(),
            Container(
              padding: EdgeInsets.only(top: 80),
            )
          ]);
        }

        final widgetRequisitos = snapshot.data.requisitos.map(
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
            QuestionarioListItem(
              questionario: snapshot.data.questionario,
              onRemover: () {
                bloc.eventSink(RemoverQuestionarioPerguntaRequisitoPageEvent());
              },
            ),
            ...widgetRequisitos.values.toList(),
            Container(
              padding: EdgeInsets.only(top: 80),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backToRootPage: false,
      body: _body(),
      title: Text('Selecionar Requisitos'),
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
              child: Icon(Icons.check, color: Colors.white,),
              backgroundColor: PmsbColors.cor_destaque,
            );
          }),
    );
  }
}

class QuestionarioListItem extends StatelessWidget {
  final QuestionarioModel questionario;
  final Function onSelecionar;
  final Function onRemover;

  const QuestionarioListItem(
      {Key key, this.questionario, this.onSelecionar, this.onRemover})
      : assert(onSelecionar == null && onRemover != null ||
            onSelecionar != null && onRemover == null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("${questionario.nome}"),
      trailing: InkWell(
        child: onSelecionar == null ? Text("Remover") : Container(child: Text("Selecionar")),
        onTap: onSelecionar == null ? onRemover : onSelecionar,
      ),
    );
  }
}
