import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/preambulo.dart';
import 'package:pmsbmibile3/models/questionario_model.dart';
import 'package:pmsbmibile3/pages/questionario/questionario_form_page_bloc.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';

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
              ListTile(
                title: Text("Apagar"),
                trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _apagarAplicacao(context, bloc);
                    }),
              ),
              Divider(color: Colors.black87),
            ],
          );
        });
  }

  void _apagarAplicacao(context, QuestionarioFormPageBloc bloc) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(child: _DeleteDocumentOrField(bloc));
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
        child: Icon(
          Icons.thumb_up,
          color: Colors.white,
        ),
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
        return Container(
          height: 250,
          color: PmsbColors.fundo,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                Text(
                  'Para apagar, digite CONCORDO na caixa de texto abaixo e confirme:  ',
                  style: PmsbStyles.textoPrimario,
                ),
                Container(
                  child: Flexible(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Digite aqui",
                        hintStyle: TextStyle(
                            color: Colors.white38, fontStyle: FontStyle.italic),
                      ),
                      controller: _textFieldController,
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    // Botao de cancelar delete
                    // GestureDetector(
                    //  onTap: () {
                    //return;
                    // },
                    Container(
                      height: 50.0,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xffEB3349),
                                Color(0xffF45C43),
                                Color(0xffEB3349)
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 150.0, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: Text(
                              "Cancelar",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Botao de confirmar delete
                    GestureDetector(
                      onTap: () {
                        if (_textFieldController.text == 'CONCORDO') {
                          bloc.dispatch(DeleteQuestionarioFormPageBlocEvent());
                          Navigator.of(context).pop();
                        }
                      },
                      child: Container(
                        height: 50.0,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xff1D976C),
                                  Color(0xff1D976C),
                                  Color(0xff93F9B9)
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Container(
                              constraints: BoxConstraints(
                                  maxWidth: 150.0, minHeight: 50.0),
                              alignment: Alignment.center,
                              child: Text(
                                "Confirmar",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),

                // IconButton(
                //   icon: Icon(Icons.delete),
                //   onPressed: () {
                //     //Ir para a pagina visuais do produto
                //     if (_textFieldController.text == 'CONCORDO') {
                //       bloc.dispatch(DeleteMomentoAplicacaoPageBlocEvent());
                //       Navigator.of(context).pop();
                //     }
                //   },
                // )
              ],
            ),
          ),
        );
      },
    );
  }
}
//child: Container(
// color: Colors.red,
//child: Padding(
//padding: const EdgeInsets.all(10.0),
// child:
// Text('Cancelar', style: PmsbStyles.textoPrimario),
// ),
// ),
