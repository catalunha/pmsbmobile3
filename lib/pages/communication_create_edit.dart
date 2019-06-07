import 'package:flutter/material.dart';
import 'package:pmsbmibile3/pages/area_checked_list.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'user_files.dart';

class SelectingTextEditingController extends TextEditingController {
  SelectingTextEditingController({String text}) : super(text: text) {
    if (text != null) setTextAndPosition(text);
  }

  void setTextAndPosition(String newText, {int caretPosition}) {
    int offset = caretPosition != null ? caretPosition : newText.length;
    value = value.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: offset),
        composing: TextRange.empty);
  }
}

class CommunicationCreateEdit extends StatefulWidget {
  @override
  _CommunicationCreateEditState createState() =>
      _CommunicationCreateEditState();
}

class _CommunicationCreateEditState extends State<CommunicationCreateEdit> {
  //Dados do formulario

  DateTime _date = new DateTime.now();
  TimeOfDay _hora = new TimeOfDay.now();
  String _textoMarkdown = "  ";
  var myController = new SelectingTextEditingController();

// --------- TELA DADOS ---------

  //Destinatario
  _tituloNoticia() {
    return Padding(
        padding: EdgeInsets.all(5.0),
        child: TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            //labelText: 'Titulo da notícia',
          ),
        ));
  }

  // Data - Horario
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

  //Anexo

  // --------- TELA TEXTO ---------

  //Texto da Noticia
  _textoNoticia() {
    return Padding(
        padding: EdgeInsets.all(5.0),
        child: TextField(
          onChanged: (text){
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

  _botoes() {
    return SafeArea(
        child: Row(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(5.0),
            child: RaisedButton(
                color: Colors.red,
                onPressed: () {},
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

  _texto(String texto) {
    return Padding(
        padding: EdgeInsets.all(5.0),
        child: Text(
          texto,
          style: TextStyle(fontSize: 15, color: Colors.blue),
        ));
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
            //_texto("Anexo"),
            //_anexos(),
            _texto("Escolha um ou varios destinatarios:"),
            _eixos(context),
            _botoes()
          ],
        ));
  }

  _atualizarMarkdown(texto, posicao) {
    _textoMarkdown = _textoMarkdown + texto;
    myController.setTextAndPosition(_textoMarkdown, caretPosition: 0);// myController.selection.baseOffset + texto.length- posicao);
  }

  _iconesLista() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.link),
          onPressed: () {
            _textoMarkdown = _textoMarkdown + "[]";
            myController.setTextAndPosition(_textoMarkdown,
                caretPosition: myController.selection.baseOffset);
          },
        ),
        IconButton(
          icon: Icon(Icons.format_bold),
          onPressed: () {
           myController.setTextAndPosition("This is a test",caretPosition: 5);
           // _atualizarMarkdown("*", 0);
          },
        ),
        IconButton(
          icon: Icon(Icons.format_size),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.format_list_bulleted),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.format_list_numbered),
          onPressed: () {},
        ),
        IconButton(
            icon: Icon(Icons.attach_file),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return UserFilesFirebaseList();
              }));
            })
      ],
    );
  }

  _bodyTexto(context) {
    return SafeArea(
        top: false,
        bottom: false,
        child: ListView(
          padding: EdgeInsets.all(5),
          children: <Widget>[
            _iconesLista(),
            _texto("Texto da notícia:"),
            _textoNoticia(),
          ],
        ));
  }

  // ---------- TELA PREVIEW ----------

  _bodyPreview(context) {
    return Markdown(data: myController.text);
  }

  @override
  Widget build(BuildContext context) {
    myController.setTextAndPosition(_textoMarkdown);
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            bottom: TabBar(
              tabs: [
                Tab(text: "Dados"),
                Tab(text: "Texto"),
                Tab(text: "Preview")
              ],
            ),
            title: Text('Criação e edicao de notícias'),
          ),
          body: TabBarView(
            children: [
              _bodyDados(context),
              _bodyTexto(context),
              _bodyPreview(context)
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Icon(Icons.thumb_up),
            backgroundColor: Colors.blue,
          ),
        ),
      ),
    );
  }
}
