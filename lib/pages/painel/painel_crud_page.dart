import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/painel/painel_crud_bloc.dart';

class PainelCrudPage extends StatefulWidget {
  final String setorCensitarioId;

  const PainelCrudPage(this.setorCensitarioId);

  _PainelCrudPageState createState() => _PainelCrudPageState();
}

class _PainelCrudPageState extends State<PainelCrudPage> {
  final PainelCrudBloc bloc;

  _PainelCrudPageState()
      : bloc = PainelCrudBloc(Bootstrap.instance.firestore);

  @override
  void initState() {
    super.initState();
    bloc.eventSink(GetSetorCensitarioIDEvent(setorCensitarioId:widget.setorCensitarioId));
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
        title: Text('Editar item do painel'),
      ),
      //  floatingActionButton: StreamBuilder<PainelCrudBlocState>(
      //       stream: bloc.stateStream,
      //       builder: (context, snapshot) {
      //         if (!snapshot.hasData) return Container();

      //         return FloatingActionButton(
      //           onPressed: snapshot.data.isDataValid
      //               ? () {
      //                   //salvar e voltar
      //                   bloc.eventSink(SaveEvent());
      //                   Navigator.pop(context);
      //                 }
      //               : null,
      //           child: Icon(Icons.cloud_upload),
      //           backgroundColor:
      //               snapshot.data.isDataValid ? Colors.blue : Colors.grey,
      //         );
      //       }),
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
            child: PainelObservacao(bloc),
          ),
        ],
      ),
    );
  }
}


class PainelObservacao extends StatefulWidget {
  final PainelCrudBloc bloc;
  PainelObservacao(this.bloc);
  @override
  PainelObservacaoState createState() {
    return PainelObservacaoState(bloc);
  }
}

class PainelObservacaoState extends State<PainelObservacao> {
  final _textFieldController = TextEditingController();
  final PainelCrudBloc bloc;
  PainelObservacaoState(this.bloc);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PainelCrudBlocState>(
      stream: bloc.stateStream,
      builder: (BuildContext context,
          AsyncSnapshot<PainelCrudBlocState> snapshot) {
        if (_textFieldController.text.isEmpty) {
          _textFieldController.text = snapshot.data?.observacao;
        }
        return TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          controller: _textFieldController,
          onChanged: (text) {
            bloc.eventSink(UpdateObservacaoEvent(text));
          },
        );
      },
    );
  }
}
