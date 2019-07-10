import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/questionario_model.dart';
import 'package:pmsbmibile3/pages/questionario/questionario_form_page_bloc.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:provider/provider.dart';

class QuestionarioFormPage extends StatelessWidget {
  final bloc = QuestionarioFormPageBloc(Bootstrap.instance.firestore);

  @override
  Widget build(BuildContext context) {
    //manda id do questionario se existir ou null no caso de settings.arguments = null
    final String questionarioId = ModalRoute.of(context).settings.arguments;
    bloc.dispatch(UpdateIdQuestionarioFormPageBlocEvent(questionarioId));

    //manda o id do usuario atual
    final authBloc = Provider.of<AuthBloc>(context);
    authBloc.userId.listen((userId)=>bloc.dispatch(UpdateUserIdQuestionarioFormPageBlocEvent(userId)));

    return Provider<QuestionarioFormPageBloc>.value(
      value: bloc,
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(12),
              child: NomeFormItem(),
            ),
            Container(
              padding: EdgeInsets.all(12),
              child: RaisedButton(
                onPressed: () {
                  bloc.dispatch(SaveQuestionarioFormPageBlocEvent());
                  Navigator.pop(context);
                },
                child: Text("Salvar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NomeFormItem extends StatefulWidget {
  @override
  NomeFormItemState createState() {
    return NomeFormItemState();
  }
}

class NomeFormItemState extends State<NomeFormItem> {
  final _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<QuestionarioFormPageBloc>(context);
    return StreamBuilder<QuestionarioModel>(
      stream: bloc.instance,
      builder: (context, snapshot) {
        if (_textFieldController.text.isEmpty) {
          _textFieldController.text = snapshot.data?.nome;
        }
        return TextField(
          controller: _textFieldController,
          onChanged: (text) {
            bloc.dispatch(UpdateNomeQuestionarioFormPageBlocEvent(text));
          },
        );
      },
    );
  }
}
