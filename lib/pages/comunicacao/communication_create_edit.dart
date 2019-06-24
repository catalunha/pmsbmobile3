import 'package:flutter/material.dart';
import 'package:pmsbmibile3/pages/area_checked_list.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pmsbmibile3/widgets/selecting_text_editing_controller.dart';

import '../user_files.dart';
import 'package:pmsbmibile3/pages/comunicacao/communication_create_edit_bloc.dart';

class CommunicationCreateEdit extends StatefulWidget {
  @override
  _CommunicationCreateEditState createState() =>
      _CommunicationCreateEditState();
}

class _CommunicationCreateEditState extends State<CommunicationCreateEdit> {
  final bloc = CommunicationCreateEditBloc();

  //Dados do formulario
  bool showFab;
  DateTime _date = new DateTime.now();
  TimeOfDay _hora = new TimeOfDay.now();
  String _textoMarkdown = "  ";
  var myController = new SelectingTextEditingController();
  final _tituloController = TextEditingController();

  @override
  void initState() {}

// --------- TELA DADOS ---------

  _texto(String texto) {
    return Padding(
        padding: EdgeInsets.all(5.0),
        child: Text(
          texto,
          style: TextStyle(fontSize: 15, color: Colors.blue),
        ));
  }

  _tituloNoticia() {
    return StreamBuilder<CommunicationCreateEditState>(
      stream: bloc.initialState,
      builder: (context, snapshot) {
        if (snapshot.hasData){
          _tituloController.text = snapshot.data.titulo;
        }
        return Padding(
            padding: EdgeInsets.all(5.0),
            child: TextField(
              controller: _tituloController,
              onChanged: (String t) => bloc.dispatch(UpdateNoticiaTituloEvent(t)),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                //labelText: 'Titulo da notícia',
              ),
            ));
      }
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2019),
        lastDate: DateTime(2022),
        builder: (BuildContext context, Widget child) {
          return FittedBox(
            child: Theme(
              child: child,
              data: ThemeData(
                primaryColor: Colors.purple[300],
              ),
            ),
          );
        });
    if (picked != null) {
      bloc.dispatch(UpdateNoticiaDataPublicacaoEvent(picked));
      setState(() {
        _date = picked;
      });
    }
  }

  _selectHorario(context) async {
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
        bloc.dispatch(UpdateNoticiaDataPublicacaoEvent(selectedTime));
        _hora = selectedTime;
      });
    }
  }

  _ajustarTempoAux(tempo) {
    if (tempo > 9) {
      return tempo;
    }
    return "0$tempo";
  }

  _dataHorarioNoticia(context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Flexible(
            child: TextField(
              obscureText: true,
              enabled: false,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  //labelText: '${_datestring}',
                  hintText:
                      "${_ajustarTempoAux(_date.day)}/${_ajustarTempoAux(_date.month)}/${_date.year} ${_ajustarTempoAux(_hora.hour)}:${_ajustarTempoAux(_hora.minute)}"),
            ),
          ),
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () {
              _selectDate(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.access_time),
            onPressed: () {
              _selectHorario(context);
            },
          ),
        ],
      ),
    );
  }

  _botoes() {
    return SafeArea(
        child: Row(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(5.0),
            child: RaisedButton(
                color: Colors.red,
                onPressed: () {
                  //delete action
                },
                child: Row(
                  children: <Widget>[
                    Text('Apagar', style: TextStyle(fontSize: 20)),
                    Icon(Icons.delete)
                  ],
                ))),
      ],
    ));
  }

  _eixos(context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Flexible(
            child: TextField(
              obscureText: true,
              enabled: false,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  //labelText: '${_datestring}',
                  hintText: ""),
            ),
          ),
          IconButton(
            icon: Icon(Icons.check_box),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AreaCheckedList();
              }));
            },
          ),
        ],
      ),
    );
  }

  _bodyDados(context) {
    return SafeArea(
        top: false,
        bottom: false,
        child: ListView(
          padding: EdgeInsets.all(5),
          children: <Widget>[
            _texto("Titulo da notícia:"),
            _tituloNoticia(),
            _texto("Data / Hora da notícia:"),
            _dataHorarioNoticia(context),
            _texto("Escolha um ou varios destinatarios:"),
            _eixos(context),
            _botoes()
          ],
        ));
  }

  // --------- TELA TEXTO ---------

  _textoNoticia() {
    return StreamBuilder<CommunicationCreateEditState>(
      stream: bloc.initialState,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          myController.text = snapshot.data.conteudoMarkdown;
        }
        return Padding(
            padding: EdgeInsets.all(5.0),
            child: TextField(
              onChanged: (text) {
                bloc.dispatch(UpdateNoticiaConteudoEvent(text));
                _textoMarkdown = text;
                print(myController.selection);
              },
              controller: myController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ));
      }
    );
  }

  _atualizarMarkdown(texto, posicao) {
    String inicio =
        _textoMarkdown.substring(0, myController.selection.baseOffset);
    print("INICIO:" + inicio);
    String fim = _textoMarkdown.substring(
        myController.selection.baseOffset, _textoMarkdown.length);
    print("FIM:" + fim);

    _textoMarkdown = "$inicio$texto$fim";
    myController.setTextAndPosition(_textoMarkdown,
        caretPosition: myController.selection.baseOffset + posicao);
  }

  _iconesLista() {
    return !showFab
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.format_bold),
                onPressed: () {
                  _atualizarMarkdown("****", 2);
                },
              ),
              IconButton(
                icon: Icon(Icons.format_size),
                onPressed: () {
                  _atualizarMarkdown("#", 1);
                },
              ),
              IconButton(
                icon: Icon(Icons.format_list_numbered),
                onPressed: () {
                  _atualizarMarkdown("- ", 2);
                },
              ),
              IconButton(
                icon: Icon(Icons.link),
                onPressed: () {
                  _atualizarMarkdown("[ clique aqui ](   )", 17);
                },
              ),
              IconButton(
                  icon: Icon(Icons.attach_file),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return UserFilesFirebaseList();
                    }));
                  })
            ],
          )
        : null;
  }

  _bodyTexto(context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        new Expanded(
          child: ListView(
            padding: EdgeInsets.all(5),
            children: <Widget>[
              _texto("Texto da notícia:"),
              _textoNoticia(),
            ],
          ),
        ),
        new Container(
          color: Colors.white,
          padding: new EdgeInsets.all(10.0),
          child: _iconesLista(),
        ),
      ],
    );
  }

  // ---------- TELA PREVIEW ----------

  _bodyPreview(context) {
    return StreamBuilder<CommunicationCreateEditState>(
      stream: bloc.initialState,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          myController.text = snapshot.data.conteudoMarkdown;
        }
        return Markdown(data: myController.text);
      }
    );
  }

  // ---------- TELA BUILD ----------

  @override
  Widget build(BuildContext context) {
    showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    myController.setTextAndPosition(_textoMarkdown);

    //TODO: isso talvez não seja aqui
    var noticiaId = ModalRoute.of(context).settings.arguments;
    if (noticiaId != null) {
      bloc.dispatch(UpdateNoticiaIdEvent(noticiaId));
    }
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            bottom: TabBar(
              tabs: [
                Tab(text: "Dados"),
                Tab(text: "Texto"),
                Tab(text: "Preview"),
              ],
            ),
            title: Text('Criação e edicao de notícias'),
          ),
          body: TabBarView(
            children: [
              _bodyDados(context),
              _bodyTexto(context),
              _bodyPreview(context),
            ],
          ),
          floatingActionButton: showFab
              ? FloatingActionButton(
                  onPressed: () {
                    //TODO: remover o pop?
                    //Navigator.of(context).pop();
                    bloc.dispatch(SaveEvent());
                  },
                  child: Icon(Icons.thumb_up),
                  backgroundColor: Colors.blue,
                )
              : null),
    );
  }
}
