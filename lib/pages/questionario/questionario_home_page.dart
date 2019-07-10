import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/questionario_model.dart';
import 'package:pmsbmibile3/pages/questionario/questionario_home_page_bloc.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:provider/provider.dart';

class QuestionarioHomePage extends StatelessWidget {
  final bloc = QuestionarioHomePageBloc(Bootstrap.instance.firestore);

  @override
  Widget build(BuildContext context) {

    //manda o id do usuario atual
    final authBloc = Provider.of<AuthBloc>(context);
    authBloc.userId.listen((userId)=>bloc.dispatch(UpdateUserIdQuestionarioHomePageBlocEvent(userId)));

    return Provider<QuestionarioHomePageBloc>.value(
      value: bloc,
      child: Scaffold(
        body: StreamBuilder<List<QuestionarioModel>>(
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
                children: snapshot.data
                    .map((questionario) => QuestionarioItem(questionario))
                    .toList(),
              );
            }),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, "/questionario/form");
          },
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
                Navigator.pushNamed(context, "/questionario/form", arguments: _questionario.id);
              },
            ),
            InkWell(
              child: Icon(Icons.delete),
              onTap: () {
                bloc.dispatch(DeleteQuestionarioHomePageEvent(_questionario.id));
              },
            ),
          ],
        )
      ],
    );
  }
}
