import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/eixo.dart';
import 'package:pmsbmibile3/models/questionario_model.dart';
import 'package:pmsbmibile3/pages/questionario/questionario_form_page_bloc.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:provider/provider.dart';

class QuestionarioFormPage extends StatelessWidget {
  final AuthBloc authBloc;
  final QuestionarioFormPageBloc bloc;

  QuestionarioFormPage(this.authBloc)
      : bloc = QuestionarioFormPageBloc(Bootstrap.instance.firestore,authBloc);

  String _questionarioId;

  _body(context) {
    return StreamBuilder<QuestionarioModel>(
        stream: bloc.instance,
        builder: (context, snapshot) {
          if (!snapshot.hasData && _questionarioId != null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: <Widget>[
              Padding(padding: EdgeInsets.all(5.0)),
              Center(
                child: Container(),
                // child: EixoAtualUsuario(this.authBloc),
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
                child: NomeFormItem(bloc),
              ),
              // _btnApagar(context),
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
    //manda id do questionario se existir ou null no caso de settings.arguments = null
    _questionarioId = ModalRoute.of(context).settings.arguments;
    bloc.dispatch(UpdateIdQuestionarioFormPageBlocEvent(_questionarioId));

    //manda o id do usuario atual
    // final authBloc = Provider.of<AuthBloc>(context);


    return
        //  Provider<QuestionarioFormPageBloc>.value(
        //   value: bloc,
        //   child:
        Scaffold(
      appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text((_questionarioId != null ? "Editar" : "Adicionar") +
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
      // ),
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
    // final bloc = Provider.of<QuestionarioFormPageBloc>(context);
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
    // final bloc = Provider.of<QuestionarioFormPageBloc>(context);
    return StreamBuilder<QuestionarioModel>(
      stream: bloc.instance,
      builder:
          (BuildContext context, AsyncSnapshot<QuestionarioModel> snapshot) {
        return Row(
          children: <Widget>[
            Divider(),
            Text('Para apagar digite CONCORDO e click:  '),
            Container(
              child: Flexible(
                child: TextField(
                  controller: _textFieldController,
                  // onChanged: (text) {
                  //   bloc.eventSink(DeleteProdutoIDEvent);
                  // },
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                //Ir para a pagina visuais do produto
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
