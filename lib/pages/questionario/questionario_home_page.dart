import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/components/eixo.dart';
import 'package:pmsbmibile3/models/questionario_model.dart';
import 'package:pmsbmibile3/pages/questionario/questionario_home_page_bloc.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:provider/provider.dart';

class QuestionarioHomePage extends StatelessWidget {
  final bloc = QuestionarioHomePageBloc(Bootstrap.instance.firestore);

  _bodyPastas(context) {
    return Container(
        child: Center(
            child: Text("Em construção", style: TextStyle(fontSize: 18))));
  }

  _bodyTodos(context) {
    return ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 15, bottom: 15),
          child: Center(
            child: EixoAtualUsuario(),
          ),
        ),
        StreamBuilder<List<QuestionarioModel>>(
            stream: bloc.questionarios,
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
              if (snapshot.data.isEmpty) {
                return Center(child: Text("Nenhum Questionario"));
              }
              return Column(
                children: [
                  ...snapshot.data
                      .map((questionario) => QuestionarioItem(questionario))
                      .toList(),
                ],
              );
            }),
      ],
    );
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
    authBloc.perfil.listen((user) {
      bloc.dispatch(UpdateUserInfoQuestionarioHomePageBlocEvent(
        user.id,
        user.eixoIDAtual.id,
      ));
    });

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
              Navigator.pushNamed(context, "/questionario/form");
            },
          ),
        ),
      ),
    );
  }

  void dispose() {
    bloc.dispose();
  }
}

class QuestionarioItem extends StatelessWidget {
  final QuestionarioModel _questionario;

  QuestionarioItem(this._questionario);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Column(
        //mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: _questionario?.nome==null ? Text('Sem nome'):Text(_questionario?.nome),
            subtitle: Text("Último editor: ${_questionario.editou.nome}"),
          ),
          // Text("Eixo: ${_questionario.eixo.nome}"),
          // Text("Último editor: ${_questionario.editou.nome}"),
          ButtonTheme.bar(
            child: ButtonBar(
              alignment: MainAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.list),
                  onPressed: () {
                    // Listar paginas de perguntas
                    Navigator.pushNamed(
                      context,
                      '/pergunta/home',
                      arguments: _questionario.id,
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      "/questionario/form",
                      arguments: _questionario.id,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
