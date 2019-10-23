import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/models.dart';
import 'package:pmsbmibile3/pages/controle/controle_tarefa_crud_bloc.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';

class ControleTarefaCrudPage extends StatefulWidget {
  final AuthBloc authBloc;
  final String tarefa;
  final String acao;
  final String acaoNome;

  const ControleTarefaCrudPage(
      {this.authBloc, this.tarefa, this.acao, this.acaoNome});

  @override
  _ControleTarefaCrudBlocState createState() => _ControleTarefaCrudBlocState();
}

class _ControleTarefaCrudBlocState extends State<ControleTarefaCrudPage> {
  ControleTarefaCrudBloc bloc;
  var result = List<Map<String, dynamic>>();

  DateTime _date = new DateTime.now();
  TimeOfDay _hora = new TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    bloc =
        ControleTarefaCrudBloc(Bootstrap.instance.firestore, widget.authBloc);
    bloc.eventSink(UpdateTarefaIDEvent(
        tarefaId: widget.tarefa,
        acaoId: widget.acao,
        acaoNome: widget.acaoNome));
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

  Future<Null> _selectDateInicio(BuildContext context) async {
    final DateTime selectedDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2019),
      lastDate: DateTime(2022),
    );
    if (selectedDate != null) {
      bloc.eventSink(UpdateInicioEvent(data: selectedDate));
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
              builder: (BuildContext context,
                  AsyncSnapshot<ControleTarefaCrudBlocState> snapshot) {
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
                return Text('Algo não esta certo...');
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
              builder: (BuildContext context,
                  AsyncSnapshot<ControleTarefaCrudBlocState> snapshot) {
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
                return Text('Algo não esta certo...');
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

  _destinatarios(context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.person),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext bc) {
                  return UsuarioListaModalSelect(bloc);
                });
          },
        ),
        StreamBuilder<ControleTarefaCrudBlocState>(
            stream: bloc.stateStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text('Sem destinatários');
              }
              if (snapshot.data.destinatario == null) {
                return Text('Destinatário não selecionado');
              } else {
                return Text('${snapshot.data.destinatario.nome}');
              }
            })
      ],
    );
  }

  _bodyDados(context) {
    return SafeArea(
        top: false,
        bottom: false,
        child: ListView(
          padding: EdgeInsets.all(5),
          children: <Widget>[
            _texto("Título da tarefa:"),
            TarefaNome(bloc),
            _texto("Data / Hora Início:"),
            _dataHorarioInicio(context),
            _texto("Data / Hora Fim:"),
            _dataHorarioFim(context),
            _texto("Escolha o destinatário:"),
            _destinatarios(context),
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
          title: Text('Criação e edição de tarefa'),
        ),
        body: _bodyDados(context),
        floatingActionButton: StreamBuilder<ControleTarefaCrudBlocState>(
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
            }));
  }
}

class TarefaNome extends StatefulWidget {
  final ControleTarefaCrudBloc bloc;
  TarefaNome(this.bloc);
  @override
  TarefaNomeState createState() {
    return TarefaNomeState(bloc);
  }
}

class TarefaNomeState extends State<TarefaNome> {
  final _textFieldController = TextEditingController();
  final ControleTarefaCrudBloc bloc;
  TarefaNomeState(this.bloc);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ControleTarefaCrudBlocState>(
      stream: bloc.stateStream,
      builder: (BuildContext context,
          AsyncSnapshot<ControleTarefaCrudBlocState> snapshot) {
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

/// Selecao de usuario que vao receber alerta
class UsuarioListaModalSelect extends StatefulWidget {
  final ControleTarefaCrudBloc bloc;

  const UsuarioListaModalSelect(this.bloc);

  @override
  _UsuarioListaModalSelectState createState() =>
      _UsuarioListaModalSelectState(this.bloc);
}

class _UsuarioListaModalSelectState extends State<UsuarioListaModalSelect> {
  final ControleTarefaCrudBloc bloc;

  _UsuarioListaModalSelectState(this.bloc);

  Widget _listaUsuarios() {
    return StreamBuilder<ControleTarefaCrudBlocState>(
      stream: bloc.stateStream,
      builder: (BuildContext context,
          AsyncSnapshot<ControleTarefaCrudBlocState> snapshot) {
        if (snapshot.hasError)
          return Center(
            child: Text("Erro. Informe ao administrador do aplicativo"),
          );
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data.usuarioList == null) {
          return Center(
            child: Text("Nenhum usuario neste chat."),
          );
        }
        if (snapshot.data.usuarioList.isEmpty) {
          return Center(
            child: Text("Vazio."),
          );
        }

        var lista = List<Widget>();
        for (var usuario in snapshot.data.usuarioList) {
          lista.add(_cardBuild(context, usuario));
        }

        return ListView(
          children: lista,
        );
      },
    );
  }

  Widget _cardBuild(BuildContext context, UsuarioModel usuario) {
    return ListTile(
      title: Text('${usuario.nome}'),
      subtitle: Text('Eixo: ${usuario.eixoID?.nome}'),
      trailing: IconButton(
        icon: Icon(Icons.check),
        onPressed: () {
          bloc.eventSink(SelectDestinatarioIDEvent(usuario));
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Escolha um destinatário"),
      ),
      body: _listaUsuarios(),
    );
  }
}
