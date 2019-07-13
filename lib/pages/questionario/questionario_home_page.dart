import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/models/questionario_model.dart';
import 'package:pmsbmibile3/pages/questionario/questionario_home_page_bloc.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:provider/provider.dart';

class QuestionarioHomePage extends StatelessWidget {
  final bloc = QuestionarioHomePageBloc(Bootstrap.instance.firestore);
  List<String> _questionarios = [
    "RS 01 - questionarios 001",
    "RS 01 - questionarios 002",
    "RS 01 - questionarios 003",
    "RS 01 - questionarios 004",
    "RS 01 - questionarios 005",
    "RS 01 - questionarios 006",
    "RS 01 - questionarios 007",
    "RS 01 - questionarios 008"
  ];

  String _eixo = "#eixo_exemplo";

  // widget de listagem

  _listaQuestionarios() {
    //TODO: refatorar
    return Builder(
      builder: (BuildContext context) =>
      new Container(
        child: _questionarios.length >= 0
            ? new ListView.separated(
          itemCount: _questionarios.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
                elevation: 10,
                child: Column(
                  //mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: Text(_questionarios[index]),
                    ),
                    ButtonTheme.bar(
                      child: ButtonBar(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.list),
                            onPressed: () {
                              // Listar paginas de perguntas
                              Navigator.pushNamed(
                                  context, '/pergunta/home');
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              // Editar questionario da lista
                              Navigator.pushNamed(context,
                                  '/questionario/adicionar_editar');
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ));
          },
          separatorBuilder: (BuildContext context, int index) =>
          new Divider(),
        )
            : new Container(),
      ),
    );
  }

  // estrutura de body's

  _bodyPastas(context) {
    return Container(
        child: Center(
            child: Text("Em construção", style: TextStyle(fontSize: 18))));
  }

  _bodyTodos(context) {
    return StreamBuilder<List<QuestionarioModel>>(
        stream: bloc.questionarios,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("ERROR");
          }
          if (!snapshot.hasData) {
            return Text("SEM DADOS");
          }
          if (snapshot.data.isEmpty) {
            return Center(child: Text("Nenhum Questionario"));
          }
          return ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: Text(
                  "Eixo - $_eixo",
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
              ...snapshot.data
                  .map((questionario) => QuestionarioItem(questionario))
                  .toList(),
            ],
          );
        });
  }

  _body(context) {
    return TabBarView(
      children: [
        _bodyTodos(context),
        _bodyPastas(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    //manda o id do usuario atual
    final authBloc = Provider.of<AuthBloc>(context);
    authBloc.userId.listen((userId) =>
        bloc.dispatch(UpdateUserIdQuestionarioHomePageBlocEvent(userId)));

    return Provider<QuestionarioHomePageBloc>.value(
      value: bloc,
      child: DefaultTabController(
        length: 2,
        child: DefaultScaffold(
          bottom: TabBar(
            tabs: [
              Tab(text: "Todos"),
              Tab(text: "Pastas"),
            ],
          ),
          title: Text('Questionarios'),
          body: _body(context),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              // Adicionar novo questionario a lista
              //Navigator.pushNamed(context, "/questionario/form");
              Navigator.pushNamed(context, '/questionario/adicionar_editar');
            },
          ),
        ),
      ),
    );
  }
}

class QuestionarioItem extends StatelessWidget {
  final QuestionarioModel _questionario;

  QuestionarioItem(this._questionario);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<QuestionarioHomePageBloc>(context);
    return Column(
      children: <Widget>[
        Text("${_questionario.nome}"),
        Text("Eixo: ${_questionario.eixoNome}"),
        Text("Editado por: ${_questionario.userId}"),
        Row(
          children: <Widget>[
            InkWell(
              child: Icon(Icons.edit),
              onTap: () {
                Navigator.pushNamed(context, "/questionario/form",
                    arguments: _questionario.id);
              },
            ),
            InkWell(
              child: Icon(Icons.delete),
              onTap: () {
                bloc.dispatch(
                    DeleteQuestionarioHomePageEvent(_questionario.id));
              },
            ),
          ],
        )
      ],
    );
  }
}
