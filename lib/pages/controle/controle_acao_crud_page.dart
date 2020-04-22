import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';

import 'controle_acao_crud_bloc.dart';

class ControleAcaoCrudPage extends StatefulWidget {
  final String tarefaID;
  final String acaoID;

  ControleAcaoCrudPage({this.tarefaID, this.acaoID});

  @override
  State<StatefulWidget> createState() {
    return _ControleAcaoCrudPageState();
  }
}

class _ControleAcaoCrudPageState extends State<ControleAcaoCrudPage> {
  final ControleAcaoCrudBloc bloc;

  _ControleAcaoCrudPageState()
      : bloc = ControleAcaoCrudBloc(Bootstrap.instance.firestore);

  @override
  void initState() {
    super.initState();
    bloc.eventSink(UpdateTarefaAcaoIDEvent(
        acaoID: widget.acaoID, tarefaID: widget.tarefaID));
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backToRootPage: false,
      title: Text('Editar ação'),
      floatingActionButton: StreamBuilder<ControleAcaoCrudBlocState>(
          stream: bloc.stateStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();

            return FloatingActionButton(
              onPressed: snapshot.data.isDataValid
                  ? () {
                      bloc.eventSink(SaveEvent());
                      Navigator.pop(context);
                    }
                  : null,
              child: Icon(Icons.cloud_upload),
              backgroundColor:
                  snapshot.data.isDataValid ? Colors.blue : Colors.grey,
            );
          }),
      body: ListView(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                "Descreva a ação a ser cumprida:",
                style: TextStyle(fontSize: 15, color: Colors.blue),
              )),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: AcaoEditar(bloc),
          ),
          Divider(),
          _DeleteDocumentOrField(bloc),
        ],
      ),
    );
  }
}

class AcaoEditar extends StatefulWidget {
  final ControleAcaoCrudBloc bloc;
  AcaoEditar(this.bloc);
  @override
  AcaoEditarState createState() {
    return AcaoEditarState(bloc);
  }
}

class AcaoEditarState extends State<AcaoEditar> {
  final _textFieldController = TextEditingController();
  final ControleAcaoCrudBloc bloc;
  AcaoEditarState(this.bloc);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ControleAcaoCrudBlocState>(
      stream: bloc.stateStream,
      builder: (BuildContext context,
          AsyncSnapshot<ControleAcaoCrudBlocState> snapshot) {
        if (_textFieldController.text.isEmpty) {
          _textFieldController.text = snapshot.data?.nome;
        }
        return TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          controller: _textFieldController,
          onChanged: (text) {
            bloc.eventSink(UpdateNomeEvent(text));
          },
        );
      },
    );
  }
}

class _DeleteDocumentOrField extends StatefulWidget {
  final ControleAcaoCrudBloc bloc;
  _DeleteDocumentOrField(this.bloc);
  @override
  _DeleteDocumentOrFieldState createState() {
    return _DeleteDocumentOrFieldState(bloc);
  }
}

class _DeleteDocumentOrFieldState extends State<_DeleteDocumentOrField> {
  final _textFieldController = TextEditingController();
  final ControleAcaoCrudBloc bloc;
  _DeleteDocumentOrFieldState(this.bloc);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ControleAcaoCrudBlocState>(
      stream: bloc.stateStream,
      builder: (BuildContext context,
          AsyncSnapshot<ControleAcaoCrudBlocState> snapshot) {
        return Row(
          children: <Widget>[
            Divider(),
            Text('Para apagar digite CONCORDO e click:  '),
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
