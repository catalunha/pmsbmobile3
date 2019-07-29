import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/eixo.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/pages/pergunta/pergunta_home_page_bloc.dart';
import 'package:pmsbmibile3/pages/page_arguments.dart'
    show EditarApagarPerguntaPageArguments;

class PerguntaHomePage extends StatelessWidget {
  final String _questionarioId;
  final bloc = PerguntaHomePageBloc(Bootstrap.instance.firestore);

  PerguntaHomePage(this._questionarioId) {
    bloc.dispatch(
        UpdateQuestionarioIdPerguntaHomePageBlocEvent(_questionarioId));
  }

  void dispose() {
    bloc.dispose();
  }

  Widget _questionarioAtual(context) {
    return StreamBuilder<PerguntaHomePageBlocState>(
        stream: bloc.state,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("ERROR"),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: Text("SEM DADOS"),
            );
          }
          final questionario = snapshot.data.questionarioInstance;
          return Text(
            "Questionario: ${questionario.nome}",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          );
        });
  }

  List<Widget> _preambulo(context) {
    return [
      Padding(
        padding: EdgeInsets.only(top: 10),
        child: Center(
          child: EixoAtualUsuario(),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Center(
          child: _questionarioAtual(context),
        ),
      ),
    ];
  }

  Widget _body(context) {
    return StreamBuilder<PerguntaHomePageBlocState>(
      stream: bloc.state,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("ERROR"),
          );
        }
        if (!snapshot.hasData) {
          return Center(
            child: Text("SEM DADOS"),
          );
        }
        final ups = snapshot.data.ups;
        final downs = snapshot.data.downs;
        final perguntas =
            snapshot.data.perguntas != null ? snapshot.data.perguntas : [];
        return ListView(
          children: [
            ..._preambulo(context),
            ...perguntas
                .map((pergunta) => PerguntaItem(
                    pergunta, ups[pergunta.id], downs[pergunta.id], bloc))
                .toList(),
            Padding(padding: EdgeInsets.all(30)),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text("Lista de Perguntas"),
      ),
      body: _body(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Adicionar um nova pergunta
          Navigator.pushNamed(context, '/pergunta/criar_editar',
              arguments: EditarApagarPerguntaPageArguments(
                  questionarioID: _questionarioId));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class PerguntaItem extends StatelessWidget {
  final PerguntaModel _pergunta;
  final bool up;
  final bool down;
  final PerguntaHomePageBloc bloc;

  PerguntaItem(this._pergunta, this.up, this.down, this.bloc)
      : assert(up != null),
        assert(down != null);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(_pergunta.titulo),
            trailing: Text("${_pergunta.ordem}"),
            subtitle: Column(
              children: <Widget>[
                Text("Tipo: ${_pergunta.tipo.nome}"),
                Text("${_pergunta.id}"),
                Text("${_pergunta.referencia}"),
              ],
            ),
          ),
          ButtonTheme.bar(
            child: ButtonBar(
              children: <Widget>[
                IconButton(
                  tooltip: 'Descer ordem da pergunta',
                  icon: Icon(Icons.arrow_downward),
                  onPressed: down
                      ? () {
                          //Mover pergunta para baixo na ordem
                          bloc.dispatch(OrdemPerguntaPerguntaHomePageBlocEvent(
                              _pergunta.id, false));
                        }
                      : null,
                ),
                IconButton(
                  tooltip: 'Subir ordem na pergunta',
                  icon: Icon(Icons.arrow_upward),
                  onPressed: up
                      ? () {
                          //Mover pergunta para cima na ordem
                          bloc.dispatch(OrdemPerguntaPerguntaHomePageBlocEvent(
                              _pergunta.id, true));
                        }
                      : null,
                ),
                IconButton(
                  tooltip: 'Editar esta pergunta',
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    final result = Navigator.pushNamed(
                        context, "/pergunta/criar_editar",
                        arguments: EditarApagarPerguntaPageArguments(
                            perguntaID: _pergunta.id,
                            questionarioID: _pergunta.questionario.id));

                    //mensagem com resultado da ação
                    result.then((result) {
                      if (result != null && result is String) {
                        final snackBar = SnackBar(content: Text(result));
                        Scaffold.of(context).showSnackBar(snackBar);
                      }
                    });
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
