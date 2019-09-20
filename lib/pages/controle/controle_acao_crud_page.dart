import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';

import 'controle_acao_crud_bloc.dart';

class ControleAcaoCrudPage extends StatefulWidget {
  final String tarefaID;
  final String acaoID;

  ControleAcaoCrudPage({this.tarefaID,this.acaoID});

  // @override
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
    bloc.eventSink(UpdateTarefaAcaoIDEvent(acaoID:widget.acaoID,tarefaID: widget.tarefaID));
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar ação'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.cloud_upload),
        onPressed: () {
          // salvar e voltar
          bloc.eventSink(SaveAcaoEvent());
          Navigator.pop(context);
        },
      ),
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
          // Padding(
          //     padding: EdgeInsets.all(5.0),
          //     child: Text(
          //       "Observação no cumprimento da ação:",
          //       style: TextStyle(fontSize: 15, color: Colors.blue),
          //     )),
          // Padding(
          //   padding: EdgeInsets.all(5.0),
          //   child: AcaoObs(bloc),
          // ),
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

// class AcaoObs extends StatefulWidget {
//   final ControleAcaoCrudBloc bloc;
//   AcaoObs(this.bloc);
//   @override
//   AcaoObsState createState() {
//     return AcaoObsState(bloc);
//   }
// }

// class AcaoObsState extends State<AcaoObs> {
//   final _textFieldController = TextEditingController();
//   final ControleAcaoCrudBloc bloc;
//   AcaoObsState(this.bloc);
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<ControleAcaoCrudBlocState>(
//       stream: bloc.stateStream,
//       builder: (BuildContext context,
//           AsyncSnapshot<ControleAcaoCrudBlocState> snapshot) {
//         if (_textFieldController.text.isEmpty) {
//           _textFieldController.text = snapshot.data?.obs;
//         }
//         return TextField(
//           keyboardType: TextInputType.multiline,
//           maxLines: null,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(),
//           ),
//           controller: _textFieldController,
//           onChanged: (text) {
//             bloc.eventSink(UpdateObsEvent(text));
//           },
//         );
//       },
//     );
//   }
// }
