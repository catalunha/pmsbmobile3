import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/pergunta/pergunta_escolha_crud_bloc.dart';
import 'package:provider/provider.dart';

class PerguntaEscolhaCRUDPage extends StatefulWidget {
  final String perguntaID;
  final String escolhaUID;

  PerguntaEscolhaCRUDPage(this.perguntaID, this.escolhaUID) {
    // print('>>> perguntaID <<< ${perguntaID}');
    // print('>>> escolhaUID <<< ${escolhaUID}');
  }

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

  @override
  Widget build(BuildContext context) {
    return Provider<PerguntaEscolhaCRUDPageBloc>.value(
      value: bloc,
      child: Scaffold(
        appBar: AppBar(
            title: Text((widget.escolhaUID != null ? "Editar" : "Adicionar") +
                " escolha")),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.thumb_up),
          onPressed: () {
            // salvar e voltar
            bloc.eventSink(SaveEvent());
            Navigator.pop(context);
          },
        ),
        body: ListView(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "Texto da escolha:",
                  style: TextStyle(fontSize: 15, color: Colors.blue),
                )),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: TextoDaEscolha(),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: _DeleteDocumentOrField(),
            ),
          ],
        ),
      ),
    );
  }
}

class TextoDaEscolha extends StatefulWidget {
  @override
  TextoDaEscolhaState createState() {
    return TextoDaEscolhaState();
  }
}

class TextoDaEscolhaState extends State<TextoDaEscolha> {
  final _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<PerguntaEscolhaCRUDPageBloc>(context);
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
  @override
  _DeleteDocumentOrFieldState createState() {
    return _DeleteDocumentOrFieldState();
  }
}

class _DeleteDocumentOrFieldState extends State<_DeleteDocumentOrField> {
  final _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<PerguntaEscolhaCRUDPageBloc>(context);
    return StreamBuilder<PerguntaEscolhaCRUDPageState>(
      stream: bloc.stateStream,
      builder: (BuildContext context,
          AsyncSnapshot<PerguntaEscolhaCRUDPageState> snapshot) {
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
                  bloc.eventSink(DeleteEvent());
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
