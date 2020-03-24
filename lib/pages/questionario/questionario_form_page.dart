import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/preambulo.dart';
import 'package:pmsbmibile3/models/questionario_model.dart';
import 'package:pmsbmibile3/pages/questionario/questionario_form_page_bloc.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';

class QuestionarioFormPage extends StatefulWidget {
  final AuthBloc authBloc;
  final String questionarioID;
  QuestionarioFormPage(this.authBloc, this.questionarioID);

  _QuestionarioFormPageState createState() =>
      _QuestionarioFormPageState(authBloc);
}

class _QuestionarioFormPageState extends State<QuestionarioFormPage> {
  final QuestionarioFormPageBloc bloc;

  String _questionarioId;

  _QuestionarioFormPageState(AuthBloc authBloc)
      : bloc = QuestionarioFormPageBloc(Bootstrap.instance.firestore, authBloc);

  @override
  void initState() {
    super.initState();
    bloc.dispatch(UpdateIdQuestionarioFormPageBlocEvent(widget.questionarioID));
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
              Preambulo(
                eixo: true,
                setor: true,
                questionarioID: widget.questionarioID,
              ),
              Padding(padding: EdgeInsets.all(5.0)),
              Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "Título do questionário:",
                    style: TextStyle(fontSize: 15, color: Colors.blue),
                  )),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: NomeFormItem(bloc),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: _DeleteDocumentOrField(bloc),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PmsbColors.fundo,
      appBar: AppBar(
        backgroundColor: PmsbColors.fundo,
        bottomOpacity: 0.0,
        elevation: 0.0,
        centerTitle: true,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text((_questionarioId != null ? "Editar" : "Adicionar") +
            " Questionário"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.thumb_up, color: Colors.white,), 
        backgroundColor: PmsbColors.cor_destaque,
        onPressed: () {
          bloc.dispatch(SaveQuestionarioFormPageBlocEvent());
          Navigator.pop(context);
        },
      ),
      body: _body(context),
    );
  }
}

class NomeFormItem extends StatefulWidget {
  final QuestionarioFormPageBloc bloc;

  NomeFormItem(this.bloc);

  @override
  NomeFormItemState createState() {
    return NomeFormItemState(bloc);
  }
}

class NomeFormItemState extends State<NomeFormItem> {
  final _textFieldController = TextEditingController();
  final QuestionarioFormPageBloc bloc;

  NomeFormItemState(this.bloc);

  @override
  Widget build(BuildContext context) {
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

class _DeleteDocumentOrField extends StatefulWidget {
  final QuestionarioFormPageBloc bloc;

  _DeleteDocumentOrField(this.bloc);

  @override
  _DeleteDocumentOrFieldState createState() {
    return _DeleteDocumentOrFieldState(bloc);
  }
}

class _DeleteDocumentOrFieldState extends State<_DeleteDocumentOrField> {
  final _textFieldController = TextEditingController();
  final QuestionarioFormPageBloc bloc;

  _DeleteDocumentOrFieldState(this.bloc);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuestionarioModel>(
      stream: bloc.instance,
      builder:
          (BuildContext context, AsyncSnapshot<QuestionarioModel> snapshot) {
        return Row(
          children: <Widget>[
            Divider(),
            Text('Para apagar digite CONCORDO e clique:  '),
            Container(
              child: Flexible(
                child: TextField(
                  controller: _textFieldController,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                if (_textFieldController.text == 'CONCORDO') {
                  bloc.dispatch(DeleteQuestionarioFormPageBlocEvent());
                  Navigator.of(context).pop();
                }
              },
            )
          ],
        );
      },
    );
  }
}
