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
            "Questionario - ${questionario.nome}",
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
    return StreamBuilder<List<PerguntaModel>>(
      stream: bloc.perguntas,
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
        return ListView(
          children: [
            ..._preambulo(context),
            ...snapshot.data
                .map((pergunta) => PerguntaItem(pergunta, bloc))
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
  final PerguntaHomePageBloc bloc;

  PerguntaItem(this._pergunta, this.bloc);

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
                Text("${_pergunta.id}"),
                Text("${_pergunta.anterior}"),
                Text("${_pergunta.posterior}"),
              ],
            ),
          ),
          ButtonTheme.bar(
            child: ButtonBar(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_downward),
                  onPressed: _pergunta.anterior == null || _pergunta.posterior == null
                      ? null
                      : () {
                          //Mover pergunta para baixo na ordem
                          bloc.dispatch(OrdemPerguntaPerguntaHomePageBlocEvent(
                              _pergunta.id, false));
                        },
                ),
                IconButton(
                  icon: Icon(Icons.arrow_upward),
                  onPressed: _pergunta.anterior == null || _pergunta.posterior == null
                      ? null
                      : () {
                          //Mover pergunta para cima na ordem
                          bloc.dispatch(OrdemPerguntaPerguntaHomePageBlocEvent(
                              _pergunta.id, true));
                        },
                ),
                IconButton(
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
    ;
  }
}
