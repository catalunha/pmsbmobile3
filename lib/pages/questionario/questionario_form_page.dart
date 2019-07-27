import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/eixo.dart';
import 'package:pmsbmibile3/models/questionario_model.dart';
import 'package:pmsbmibile3/pages/questionario/questionario_form_page_bloc.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:provider/provider.dart';

class QuestionarioFormPage extends StatefulWidget {
  final String questionarioID;
  final AuthBloc authBloc;

  const QuestionarioFormPage(this.authBloc, this.questionarioID, {Key key}) : super(key: key);

  @override
  _QuestionarioFormPageState createState() {
    return _QuestionarioFormPageState();
  }
}

class _QuestionarioFormPageState extends State<QuestionarioFormPage> {
  final bloc = QuestionarioFormPageBloc(Bootstrap.instance.firestore);

  _QuestionarioFormPageState();

  @override
  void initState() {
    super.initState();
    bloc.dispatch(UpdateIdQuestionarioFormPageBlocEvent(widget.questionarioID));
    widget.authBloc.perfil.listen((usuario) {
      bloc.dispatch(UpdateUserInfoQuestionarioFormPageBlocEvent(
        usuario.id,
        usuario.nome,
        usuario.eixoIDAtual.id,
        usuario.eixoIDAtual.nome,
      ));
    });
  }

  Widget _btnApagar(BuildContext context) {
    return StreamBuilder<QuestionarioModel>(
        stream: bloc.instance,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          return SafeArea(
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
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  _body(context) {
    return StreamBuilder<QuestionarioModel>(
        stream: bloc.instance,
        builder: (context, snapshot) {
          if (!snapshot.hasData && widget.questionarioID != null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
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
              _btnApagar(context),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Provider<QuestionarioFormPageBloc>.value(
      value: bloc,
      child: Scaffold(
        appBar: AppBar(
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text((widget.questionarioID != null ? "Editar" : "Adicionar") +
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
