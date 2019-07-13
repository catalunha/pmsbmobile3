import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/eixo.dart';
import 'package:pmsbmibile3/models/questionario_model.dart';
import 'package:pmsbmibile3/pages/questionario/questionario_form_page_bloc.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:provider/provider.dart';

class QuestionarioFormPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return QuestionarioFormPageState();
  }
}

class QuestionarioFormPageState extends State<QuestionarioFormPage> {
  final bloc = QuestionarioFormPageBloc(Bootstrap.instance.firestore);

  _body(context) {
    return ListView(
      children: <Widget>[
        Padding(padding: EdgeInsets.all(5.0)),
        Center(
          child: EixoAtualUsuario(),
        ),
        Padding(padding: EdgeInsets.all(5.0)),
        Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(
              "Titulo do questionario:",
              style: TextStyle(fontSize: 15, color: Colors.blue),
            )),
        Padding(
          padding: EdgeInsets.all(5.0),
          child: NomeFormItem(),
        ),
        SafeArea(
            child: Row(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(5.0),
                child: RaisedButton(
                    color: Colors.red,
                    onPressed: () {
                      bloc.dispatch(DeleteQuestionarioFormPageBlocEvent());
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: <Widget>[
                        Text('Apagar', style: TextStyle(fontSize: 20)),
                        Icon(Icons.delete)
                      ],
                    ))),
          ],
        ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    //manda id do questionario se existir ou null no caso de settings.arguments = null
    final String questionarioId = ModalRoute.of(context).settings.arguments;
    bloc.dispatch(UpdateIdQuestionarioFormPageBlocEvent(questionarioId));

    //manda o id do usuario atual
    final authBloc = Provider.of<AuthBloc>(context);
    authBloc.perfil.listen((usuario) {
      bloc.dispatch(UpdateUserInfoQuestionarioFormPageBlocEvent(
        usuario.id,
        usuario.nome,
        usuario.eixoIDAtual.id,
        usuario.eixoIDAtual.nome,
      ));
    });

    return Provider<QuestionarioFormPageBloc>.value(
      value: bloc,
      child: Scaffold(
        appBar: AppBar(
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text((questionarioId != null ? "Editar" : "Adicionar") +
                " Questionario")),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.thumb_up),
          onPressed: () {
            // salvar e voltar
            bloc.dispatch(SaveQuestionarioFormPageBlocEvent());
            Navigator.pop(context);
          },
        ),
        body: _body(context),
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
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          controller: _textFieldController,
          onChanged: (text) {
            bloc.dispatch(UpdateNomeQuestionarioFormPageBlocEvent(text));
          },
        );
      },
    );
  }
}
