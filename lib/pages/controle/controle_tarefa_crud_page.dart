import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/pages/controle/controle_tarefa_crud_bloc.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/widgets/selecting_text_editing_controller.dart';

//TODO: Mudar esta abordagem para authBloc de main e revisar bloc
class ControleTarefaCrudPage extends StatefulWidget {
  final String controleTarefaID;
  final AuthBloc authBloc;

  const ControleTarefaCrudPage(this.authBloc, this.controleTarefaID);

  @override
  _ControleTarefaCrudBlocState createState() => _ControleTarefaCrudBlocState();
}

class _ControleTarefaCrudBlocState extends State<ControleTarefaCrudPage> {
  ControleTarefaCrudBloc bloc;
  var result = List<Map<String, dynamic>>();

  //Dados do formulario
  bool showFab;
  DateTime _date = new DateTime.now();
  TimeOfDay _hora = new TimeOfDay.now();
  var myController = new SelectingTextEditingController();
  final _tituloController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bloc =
        ControleTarefaCrudBloc(Bootstrap.instance.firestore, widget.authBloc);
    // bloc.eventSink(UpdateTarefaIDEvent(widget.controleTarefaID));
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }
// --------- TELA DADOS ---------

  _texto(String texto) {
    return Padding(
        padding: EdgeInsets.all(5.0),
        child: Text(
          texto,
          style: TextStyle(fontSize: 15, color: Colors.blue),
        ));
  }

  _tituloTarefa() {
    return StreamBuilder<ControleTarefaCrudBlocState>(
        stream: bloc.stateStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _tituloController.text = snapshot.data.nome;
          }
          return Padding(
              padding: EdgeInsets.all(5.0),
              child: TextField(
                controller: _tituloController,
                onChanged: (String t) => bloc.eventSink(UpdateNomeEvent(t)),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ));
        });
  }

  Future<Null> _selectDateInicio(BuildContext context) async {
    final DateTime selectedDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2019),
      lastDate: DateTime(2022),
    );
    if (selectedDate != null) {
      bloc.eventSink(UpdateInicioEvent(data: selectedDate));
      setState(() {
        _date = selectedDate;
      });
    }
  }

  Future<Null> _selectHorarioInicio(BuildContext context) async {
    TimeOfDay selectedTime = await showTimePicker(
      initialTime: _hora,
      context: context,
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    );
    if (selectedTime != null) {
      setState(() {
        bloc.eventSink(UpdateInicioEvent(hora: selectedTime));
        _hora = selectedTime;
      });
    }
  }

  Future<Null> _selectHorarioFim(BuildContext context) async {
    TimeOfDay selectedTime = await showTimePicker(
      initialTime: _hora,
      context: context,
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    );
    if (selectedTime != null) {
      setState(() {
        bloc.eventSink(UpdateFimEvent(hora: selectedTime));
        _hora = selectedTime;
      });
    }
  }

  Future<Null> _selectDateFim(BuildContext context) async {
    final DateTime selectedDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2019),
      lastDate: DateTime(2022),
    );
    if (selectedDate != null) {
      bloc.eventSink(UpdateFimEvent(data: selectedDate));
      setState(() {
        _date = selectedDate;
      });
    }
  }

  _dataHorarioInicio(context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          StreamBuilder<ControleTarefaCrudBlocState>(
              stream: bloc.stateStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.inicio != null) {
                    _date = DateTime(snapshot.data.inicio.year,
                        snapshot.data.inicio.month, snapshot.data.inicio.day);
                    _hora = TimeOfDay.fromDateTime(snapshot.data.inicio);
                    return Text(snapshot.data.inicio.toString());
                  }
                } else {
                  return Text('...');
                }
              }),
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () {
              _selectDateInicio(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.access_time),
            onPressed: () {
              _selectHorarioInicio(context);
            },
          ),
        ],
      ),
    );
  }

  _dataHorarioFim(context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          StreamBuilder<ControleTarefaCrudBlocState>(
              stream: bloc.stateStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.fim != null) {
                    _date = DateTime(snapshot.data.fim.year,
                        snapshot.data.fim.month, snapshot.data.fim.day);
                    _hora = TimeOfDay.fromDateTime(snapshot.data.fim);
                    return Text(snapshot.data.fim.toString());
                  }
                } else {
                  return Text('...');
                }
              }),
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () {
              _selectDateFim(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.access_time),
            onPressed: () {
              _selectHorarioFim(context);
            },
          ),
        ],
      ),
    );
  }

  // _destinatarios(context) {
  //   // List<Map<String, dynamic>> litems = [
  //   //   {'id': '1', 'nome': 'um'},
  //   //   {'id': '2', 'nome': 'dois'},
  //   // ];
  //   return Column(
  //     children: <Widget>[
  //       IconButton(
  //         icon: Icon(Icons.check_box),
  //         onPressed: () async {
  //           var destinatarioList = await Navigator.push(context,
  //               MaterialPageRoute(builder: (context) {
  //             return ComunicacaoDestinatariosPage();
  //           }));
  //           if (destinatarioList != null) {
  //             bloc.eventSink(
  //                 UpdateDestinatarioListEvent(destinatarioList));
  //           }
  //           // print('>>>> Retorno ${result}');
  //         },
  //       ),
  //       StreamBuilder<ControleTarefaCrudBlocState>(
  //           stream: bloc.stateStream,
  //           builder: (context, snapshot) {
  //             if (!snapshot.hasData) {
  //               return Text('Sem destinatarios');
  //             }
  //             if (snapshot.data.destinatarioListMap == null) {
  //               return Text('destinatarios vazia');
  //             } else {
  //               return Column(
  //                   children: snapshot.data.destinatarioListMap
  //                       .map((item) => Text('${item['nome']}'))
  //                       .toList());
  //             }
  //           })
  //     ],
  //   );
  // }

  _bodyDados(context) {
    return SafeArea(
        top: false,
        bottom: false,
        child: ListView(
          padding: EdgeInsets.all(5),
          children: <Widget>[
            _texto("Titulo da tarefa:"),
            _tituloTarefa(),
            _texto("Data / Hora Inicio:"),
            _dataHorarioInicio(context),
            _texto("Data / Hora Fim:"),
            _dataHorarioFim(context),
            _texto("Escolha o destinatário:"),
            // _destinatarios(context),
            Divider(),
            _DeleteDocumentOrField(bloc),
          ],
        ));
  }

  // ---------- TELA BUILD ----------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Criação e edicao de tarefa'),
        ),
        body: _bodyDados(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //TODO: remover o pop?
            bloc.eventSink(SaveEvent());
          },
          child: Icon(Icons.cloud_upload),
        ));
  }
}

class _DeleteDocumentOrField extends StatefulWidget {
  final ControleTarefaCrudBloc bloc;
  _DeleteDocumentOrField(this.bloc);
  @override
  _DeleteDocumentOrFieldState createState() {
    return _DeleteDocumentOrFieldState(bloc);
  }
}

class _DeleteDocumentOrFieldState extends State<_DeleteDocumentOrField> {
  final _textFieldController = TextEditingController();
  final ControleTarefaCrudBloc bloc;
  _DeleteDocumentOrFieldState(this.bloc);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ControleTarefaCrudBlocState>(
      stream: bloc.stateStream,
      builder: (BuildContext context,
          AsyncSnapshot<ControleTarefaCrudBlocState> snapshot) {
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
