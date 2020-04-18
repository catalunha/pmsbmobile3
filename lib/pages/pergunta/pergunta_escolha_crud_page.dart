import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/pages/pergunta/pergunta_escolha_crud_bloc.dart';
import 'package:pmsbmibile3/pages/produto/produto_crud_page_bloc.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';

class PerguntaEscolhaCRUDPage extends StatefulWidget {
  final String perguntaID;
  final String escolhaUID;

  PerguntaEscolhaCRUDPage(this.perguntaID, this.escolhaUID) {}

  @override
  _PerguntaEscolhaCRUDPageState createState() {
    return _PerguntaEscolhaCRUDPageState();
  }
}

class _PerguntaEscolhaCRUDPageState extends State<PerguntaEscolhaCRUDPage> {
  final PerguntaEscolhaCRUDPageBloc bloc;

  _PerguntaEscolhaCRUDPageState()
      : bloc = PerguntaEscolhaCRUDPageBloc(Bootstrap.instance.firestore);

  @override
  void initState() {
    super.initState();
    bloc.eventSink(UpdatePerguntaIDPageEvent(widget.perguntaID));
    bloc.eventSink(UpdateEscolhaIDPageEvent(widget.escolhaUID));
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  void _apagarAplicacao(context, PerguntaEscolhaCRUDPageBloc bloc) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext bc) {
        return SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(bc).viewInsets.bottom,
              ),
              child: Container(
                  height: 250,
                  color: Colors.black38,
                  child: _DeleteDocumentOrField(bloc))),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backToRootPage: false,
      title: Text(
          (widget.escolhaUID != null ? "Editar" : "Adicionar") + " Escolha"),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
        backgroundColor: PmsbColors.cor_destaque,
        onPressed: () {
          bloc.eventSink(SaveEvent());
          Navigator.pop(context);
        },
      ),
      body: ListView(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                "Texto da escolha:",
                style: PmsbStyles.textoPrimario,
              )),
          Padding(
            padding: EdgeInsets.all(6),
            child: TextoDaEscolha(bloc),
          ),
          Padding(padding: EdgeInsets.all(12)),
          Divider(color: Colors.black87),
          ListTile(
            title: Text("Apagar"),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _apagarAplicacao(context, bloc);
              },
            ),
          ),
          Divider(color: Colors.black87),
        ],
      ),
    );
  }
}

class TextoDaEscolha extends StatefulWidget {
  final PerguntaEscolhaCRUDPageBloc bloc;
  TextoDaEscolha(this.bloc);
  @override
  TextoDaEscolhaState createState() {
    return TextoDaEscolhaState(bloc);
  }
}

class TextoDaEscolhaState extends State<TextoDaEscolha> {
  final _textFieldController = TextEditingController();
  final PerguntaEscolhaCRUDPageBloc bloc;
  TextoDaEscolhaState(this.bloc);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PerguntaEscolhaCRUDPageState>(
      stream: bloc.stateStream,
      builder: (BuildContext context,
          AsyncSnapshot<PerguntaEscolhaCRUDPageState> snapshot) {
        if (_textFieldController.text.isEmpty) {
          _textFieldController.text = snapshot.data?.texto;
        }
        return TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          controller: _textFieldController,
          onChanged: (text) {
            bloc.eventSink(UpdateTextoEvent(text));
          },
        );
      },
    );
  }
}

class _DeleteDocumentOrField extends StatefulWidget {
  final PerguntaEscolhaCRUDPageBloc bloc;
  _DeleteDocumentOrField(this.bloc);
  @override
  _DeleteDocumentOrFieldState createState() {
    return _DeleteDocumentOrFieldState(bloc);
  }
}

class _DeleteDocumentOrFieldState extends State<_DeleteDocumentOrField> {
  final _textFieldController = TextEditingController();
  final PerguntaEscolhaCRUDPageBloc bloc;
  _DeleteDocumentOrFieldState(this.bloc);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PerguntaEscolhaCRUDPageState>(
      stream: bloc.stateStream,
      builder: (BuildContext context,
          AsyncSnapshot<PerguntaEscolhaCRUDPageState> snapshot) {
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
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 50.0,
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
                          constraints:
                              BoxConstraints(maxWidth: 150.0, minHeight: 50.0),
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

                    // Botao de confirmar delete
                    GestureDetector(
                      onTap: () {
                        if (_textFieldController.text == 'CONCORDO') {
                          bloc.eventSink((DeleteEvent));
                          _alerta(
                            "O texto da escolha foi removido",
                            () {
                              var count = 0;
                              Navigator.popUntil(context, (route) {
                                return count++ == 3;
                              });
                            },
                          );
                        } else {
                          _alerta(
                            "Verifique se a caixa de texto abaixo foi preenchida corretamente.",
                            () {
                              Navigator.pop(context);
                            },
                          );
                        }
                      },
                      child: Container(
                        height: 50.0,
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
                          constraints:
                              BoxConstraints(maxWidth: 150.0, minHeight: 50.0),
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
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _alerta(String msgAlerta, Function acao) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: PmsbColors.card,
          title: Text(msgAlerta),
          actions: <Widget>[
            FlatButton(child: Text('Ok'), onPressed: acao),
          ],
        );
      },
    );
  }
}
