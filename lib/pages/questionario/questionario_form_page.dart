import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/eixo.dart';
import 'package:pmsbmibile3/models/questionario_model.dart';
import 'package:pmsbmibile3/pages/questionario/questionario_form_page_bloc.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:provider/provider.dart';

class QuestionarioFormPage extends StatelessWidget {
  final bloc = QuestionarioFormPageBloc(Bootstrap.instance.firestore);
  String _questionarioId;

  // Widget _btnApagar(BuildContext context) {
  //   return StreamBuilder<QuestionarioModel>(
  //       stream: bloc.instance,
  //       builder: (context, snapshot) {
  //         if (!snapshot.hasData) {
  //           return Container();
  //         }
  //         return SafeArea(
  //           child: Row(
  //             children: <Widget>[
  //               Padding(
  //                 padding: EdgeInsets.all(5.0),
  //                 child: RaisedButton(
  //                   color: Colors.red,
  //                   onPressed: () {
  //                     bloc.dispatch(DeleteQuestionarioFormPageBlocEvent());
  //                     Navigator.pop(context);
  //                   },
  //                   child: Row(
  //                     children: <Widget>[
  //                       Text('Apagar', style: TextStyle(fontSize: 20)),
  //                       Icon(Icons.delete)
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       });
  // }

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
              // _btnApagar(context),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: _DeleteDocumentOrField(),
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

class _DeleteDocumentOrField extends StatefulWidget {
  @override
  _DeleteDocumentOrFieldState createState() {
    return _DeleteDocumentOrFieldState();
  }
}

class _DeleteDocumentOrFieldState extends State<_DeleteDocumentOrField> {
  final _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<QuestionarioFormPageBloc>(context);
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
