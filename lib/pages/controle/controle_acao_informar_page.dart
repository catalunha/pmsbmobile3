import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/controle/controle_acao_informar_bloc.dart';

class ControleAcaoInformarPage extends StatefulWidget {
  final String acaoID;

  ControleAcaoInformarPage(this.acaoID);

  @override
  State<StatefulWidget> createState() {
    return _ControleAcaoInformarPageState();
  }
}

class _ControleAcaoInformarPageState extends State<ControleAcaoInformarPage> {
  final ControleAcaoInformarBloc bloc;

  _ControleAcaoInformarPageState()
      : bloc = ControleAcaoInformarBloc(Bootstrap.instance.firestore);

  @override
  void initState() {
    super.initState();
    bloc.eventSink(UpdateAcaoIDEvent(widget.acaoID));
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
          title: Text('Informar url / obs da ação'),),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.cloud_upload),
        onPressed: () {
          bloc.eventSink(SaveAcaoEvent());
          Navigator.pop(context);
        },
      ),
      body: ListView(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                "Informar URL do Documento no Google Drive:",
              )),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: AcaoUrl(bloc),
          ),
          Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                "Observação no cumprimento da ação:",
              )),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: AcaoObs(bloc),
          ),
        ],
      ),
    );
  }
}

class AcaoUrl extends StatefulWidget {
  final ControleAcaoInformarBloc bloc;
  AcaoUrl(this.bloc);
  @override
  AcaoUrlState createState() {
    return AcaoUrlState(bloc);
  }
}

class AcaoUrlState extends State<AcaoUrl> {
  final _textFieldController = TextEditingController();
  final ControleAcaoInformarBloc bloc;
  AcaoUrlState(this.bloc);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ControleAcaoInformarBlocState>(
      stream: bloc.stateStream,
      builder:
          (BuildContext context, AsyncSnapshot<ControleAcaoInformarBlocState> snapshot) {
        if (_textFieldController.text.isEmpty) {
          _textFieldController.text = snapshot.data?.url;
        }
        return TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          controller: _textFieldController,
          onChanged: (text) {
            bloc.eventSink(UpdateUrlEvent(text));
          },
        );
      },
    );
  }
}


class AcaoObs extends StatefulWidget {
  final ControleAcaoInformarBloc bloc;
  AcaoObs(this.bloc);
  @override
  AcaoObsState createState() {
    return AcaoObsState(bloc);
  }
}

class AcaoObsState extends State<AcaoObs> {
  final _textFieldController = TextEditingController();
  final ControleAcaoInformarBloc bloc;
  AcaoObsState(this.bloc);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ControleAcaoInformarBlocState>(
      stream: bloc.stateStream,
      builder:
          (BuildContext context, AsyncSnapshot<ControleAcaoInformarBlocState> snapshot) {
        if (_textFieldController.text.isEmpty) {
          _textFieldController.text = snapshot.data?.obs;
        }
        return TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          controller: _textFieldController,
          onChanged: (text) {
            bloc.eventSink(UpdateObsEvent(text));
          },
        );
      },
    );
  }
}

