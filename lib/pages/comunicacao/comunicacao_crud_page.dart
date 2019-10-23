import 'package:flutter/material.dart';
import 'package:pmsbmibile3/pages/comunicacao/comunicacao_destinatario_page.dart';
import 'package:pmsbmibile3/naosuportato/flutter_markdown.dart'
    if (dart.library.io) 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pmsbmibile3/widgets/selecting_text_editing_controller.dart';
import 'package:pmsbmibile3/naosuportato/url_launcher.dart'
    if (dart.library.io) 'package:url_launcher/url_launcher.dart';

import 'package:pmsbmibile3/pages/comunicacao/comunicacao_crud_page_bloc.dart';

//TODO: Mudar esta abordagem para authBloc de main e revisar bloc
class ComunicacaoCRUDPage extends StatefulWidget {
  @override
  _ComunicacaoCRUDPageState createState() => _ComunicacaoCRUDPageState();
}

class _ComunicacaoCRUDPageState extends State<ComunicacaoCRUDPage> {
  final bloc = ComunicacaoCRUDPageBloc();
  var result = List<Map<String, dynamic>>();

  bool showFab;
  DateTime _date = new DateTime.now();
  TimeOfDay _hora = new TimeOfDay.now();
  String _textoMarkdown = "  ";
  var myController = new SelectingTextEditingController();
  final _tituloController = TextEditingController();

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
    return StreamBuilder<ComunicacaoCRUDPageState>(
        stream: bloc.stateStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _tituloController.text = snapshot.data.titulo;
          }
          return Padding(
              padding: EdgeInsets.all(5.0),
              child: TextField(
                controller: _tituloController,
                onChanged: (String t) => bloc.eventSink(UpdateTituloEvent(t)),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ));
        });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime selectedDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2019),
      lastDate: DateTime(2022),
    );
    if (selectedDate != null) {
      bloc.eventSink(UpdatePublicarEvent(data: selectedDate));
      setState(() {
        _date = selectedDate;
      });
    }
  }

  Future<Null> _selectHorario(BuildContext context) async {
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
        bloc.eventSink(UpdatePublicarEvent(hora: selectedTime));
        _hora = selectedTime;
      });
    }
  }

  _dataHorarioNoticia(context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          StreamBuilder<ComunicacaoCRUDPageState>(
              stream: bloc.stateStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.publicar != null) {
                    _date = DateTime(
                        snapshot.data.publicar.year,
                        snapshot.data.publicar.month,
                        snapshot.data.publicar.day);
                    _hora = TimeOfDay.fromDateTime(snapshot.data.publicar);
                    return Text(snapshot.data.publicar.toString());
                  }
                } else {
                  return Text('...');
                }
              }),
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

  _destinatarios(context) {
    return Column(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.check_box),
          onPressed: () async {
            var destinatarioList = await Navigator.push(context,
                MaterialPageRoute(builder: (context) {
              return ComunicacaoDestinatariosPage();
            }));
            if (destinatarioList != null) {
              bloc.eventSink(UpdateDestinatarioListEvent(destinatarioList));
            }
          },
        ),
        StreamBuilder<ComunicacaoCRUDPageState>(
            stream: bloc.stateStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text('Sem destinatarios');
              }
              if (snapshot.data.destinatarioListMap == null) {
                return Text('destinatarios vazia');
              } else {
                return Column(
                    children: snapshot.data.destinatarioListMap
                        .map((item) => Text('${item['nome']}'))
                        .toList());
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
            _texto("Titulo da notícia:"),
            _tituloNoticia(),
            _texto("Data / Hora para publicação:"),
            _dataHorarioNoticia(context),
            _texto("Escolha o(s) destinatário(s):"),
            _destinatarios(context),
            Divider(),
            _DeleteDocumentOrField(bloc),
          ],
        ));
  }

  // --------- TELA TEXTO ---------

  _textoNoticia() {
    return StreamBuilder<ComunicacaoCRUDPageState>(
        stream: bloc.stateStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            myController.text = snapshot.data.textoMarkdown;
          }
          return Padding(
              padding: EdgeInsets.all(5.0),
              child: TextField(
                onChanged: (text) {
                  bloc.eventSink(UpdateTextoMarkdownEvent(text));
                  _textoMarkdown = text;
                },
                controller: myController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ));
        });
  }

  _bodyTexto(context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        new Expanded(
          child: ListView(
            children: <Widget>[
              ListTile(
                  title: _texto("Texto da notícia: (Use marcação markdown)"),
                  trailing: IconButton(
                    icon: Icon(Icons.location_on),
                    onPressed: () {
                      launch("https://daringfireball.net/projects/markdown/");
                    },
                  )),
              _textoNoticia(),
            ],
          ),
        ),
      ],
    );
  }

  // ---------- TELA PREVIEW ----------

  _bodyPreview(context) {
    return StreamBuilder<ComunicacaoCRUDPageState>(
        stream: bloc.stateStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            myController.text = snapshot.data.textoMarkdown;
          }
          return Markdown(data: myController.text);
        });
  }

  // ---------- TELA BUILD ----------

  @override
  Widget build(BuildContext context) {
    showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    myController.setTextAndPosition(_textoMarkdown);

    //TODO: isso talvez não seja aqui
    var noticiaId = ModalRoute.of(context).settings.arguments;
    if (noticiaId != null) {
      bloc.eventSink(UpdateNoticiaIDEvent(noticiaId));
    }
    return DefaultTabController(
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
                    Navigator.of(context).pop();
                    bloc.eventSink(SaveStateToFirebaseEvent());
                  },
                  child: Icon(Icons.save),
                  backgroundColor: Colors.blue,
                )
              : null),
    );
  }
}

class _DeleteDocumentOrField extends StatefulWidget {
  final ComunicacaoCRUDPageBloc bloc;

  _DeleteDocumentOrField(this.bloc);

  @override
  _DeleteDocumentOrFieldState createState() {
    return _DeleteDocumentOrFieldState(bloc);
  }
}

class _DeleteDocumentOrFieldState extends State<_DeleteDocumentOrField> {
  final _textFieldController = TextEditingController();
  final ComunicacaoCRUDPageBloc bloc;

  _DeleteDocumentOrFieldState(this.bloc);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ComunicacaoCRUDPageState>(
      stream: bloc.stateStream,
      builder: (BuildContext context,
          AsyncSnapshot<ComunicacaoCRUDPageState> snapshot) {
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
                  bloc.eventSink(DeleteNoticiaIDEvent());
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
