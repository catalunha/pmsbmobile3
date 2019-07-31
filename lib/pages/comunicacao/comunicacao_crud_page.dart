import 'package:flutter/material.dart';
import 'package:pmsbmibile3/pages/comunicacao/comunicacao_destinatario_page.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pmsbmibile3/widgets/selecting_text_editing_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../user_files.dart';
import 'package:pmsbmibile3/pages/comunicacao/comunicacao_crud_page_bloc.dart';

//TODO: Mudar esta abordagem para authBloc de main e revisar bloc
class ComunicacaoCRUDPage extends StatefulWidget {
  @override
  _ComunicacaoCRUDPageState createState() => _ComunicacaoCRUDPageState();
}

class _ComunicacaoCRUDPageState extends State<ComunicacaoCRUDPage> {
  final bloc = ComunicacaoCRUDPageBloc();
  var result = List<Map<String, dynamic>>();

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
    return StreamBuilder<ComunicacaoCRUDPageState>(
        stream: bloc.comunicacaoCRUDPageStateStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _tituloController.text = snapshot.data.titulo;
          }
          return Padding(
              padding: EdgeInsets.all(5.0),
              child: TextField(
                controller: _tituloController,
                onChanged: (String t) =>
                    bloc.comunicacaoCRUDPageEventSink(UpdateTituloEvent(t)),
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
      // locale: const Locale('pt','BR'),
      // builder: (BuildContext context, Widget child) {
      //   return FittedBox(
      //     child: Theme(
      //       child: child,
      //       data: ThemeData(
      //         primaryColor: Colors.purple[300],
      //       ),
      //     ),
      //   );
      // }
    );
    if (selectedDate != null) {
      bloc.comunicacaoCRUDPageEventSink(
          UpdatePublicarEvent(data: selectedDate));
      setState(() {
        _date = selectedDate;
      });
      print('selectedDate: ${_date.toString()}');
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
        bloc.comunicacaoCRUDPageEventSink(
            UpdatePublicarEvent(hora: selectedTime));
        _hora = selectedTime;
      });
      print('selectedTime: ${_hora.toString()}');
    }
  }

  // _ajustarTempoAux(tempo) {
  //   if (tempo > 9) {
  //     return tempo;
  //   }
  //   return "0$tempo";
  // }

  _dataHorarioNoticia(context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // new Flexible(
          //   child: TextField(
          //     obscureText: true,
          //     enabled: false,
          //     keyboardType: TextInputType.datetime,
          //     decoration: InputDecoration(
          //         border: OutlineInputBorder(),
          //         //labelText: '${_datestring}',
          //         hintText:
          //             "${_ajustarTempoAux(_date.day)}/${_ajustarTempoAux(_date.month)}/${_date.year} ${_ajustarTempoAux(_hora.hour)}:${_ajustarTempoAux(_hora.minute)}"),
          //   ),
          // ),
          StreamBuilder<ComunicacaoCRUDPageState>(
              stream: bloc.comunicacaoCRUDPageStateStream,
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

  _botaoDeletarDocumento() {
    return SafeArea(
        child: Row(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(5.0),
            child: RaisedButton(
                // color: Colors.red,
                onPressed: () {
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) {
                        return SimpleDialog(
                          children: <Widget>[
                            SimpleDialogOption(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("CANCELAR EXCLUSÃO"),
                            ),
                            Container(
                              padding: EdgeInsets.all(20),
                            ),
                            Divider(),
                            SimpleDialogOption(
                              onPressed: () {
                                bloc.comunicacaoCRUDPageEventSink(
                                    DeleteNoticiaIDEvent());
                                Navigator.pushNamed(
                                    context, '/comunicacao/home');
                              },
                              child: Text("sim"),
                            ),
                          ],
                        );
                      });
                },
                child: Row(
                  children: <Widget>[
                    // Text('Apagar notícia', style: TextStyle(fontSize: 20)),
                    Icon(Icons.delete)
                  ],
                ))),
      ],
    ));
  }

  _destinatarios(context) {
    // List<Map<String, dynamic>> litems = [
    //   {'id': '1', 'nome': 'um'},
    //   {'id': '2', 'nome': 'dois'},
    // ];
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
              bloc.comunicacaoCRUDPageEventSink(
                  UpdateDestinatarioListEvent(destinatarioList));
            }
            // print('>>>> Retorno ${result}');
          },
        ),
        StreamBuilder<ComunicacaoCRUDPageState>(
            stream: bloc.comunicacaoCRUDPageStateStream,
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

    // return Padding(
    //   padding: EdgeInsets.all(5.0),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //     children: <Widget>[
    //       new Flexible(
    //         child: TextField(
    //           obscureText: true,
    //           enabled: false,
    //           // keyboardType: TextInputType.datetime,
    //           decoration: InputDecoration(
    //               border: OutlineInputBorder(),
    //               //labelText: '${_datestring}',
    //               hintText: ""),
    //         ),
    //       ),
    //       IconButton(
    //         icon: Icon(Icons.check_box),
    //         onPressed: () async {
    //           result = await Navigator.push(context,
    //               MaterialPageRoute(builder: (context) {
    //             return ComunicacaoDestinatariosPage();
    //           }));
    //           print('>>>> Retorno ${result}');
    //         },
    //       ),
    //       // ListView.builder(
    //       //     itemCount: result.length,
    //       //     itemBuilder: (BuildContext ctxt, int index) {
    //       //       return new Text(result[index]);
    //       //     }),
    //     ],
    //   ),
    // );
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
            _botaoDeletarDocumento()
          ],
        ));
  }

  // --------- TELA TEXTO ---------

  _textoNoticia() {
    return StreamBuilder<ComunicacaoCRUDPageState>(
        stream: bloc.comunicacaoCRUDPageStateStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            myController.text = snapshot.data.textoMarkdown;
          }
          return Padding(
              padding: EdgeInsets.all(5.0),
              child: TextField(
                onChanged: (text) {
                  bloc.comunicacaoCRUDPageEventSink(
                      UpdateTextoMarkdownEvent(text));
                  _textoMarkdown = text;
                  // print(myController.selection);
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

  // _atualizarMarkdown(texto, posicao) {
  //   String inicio =
  //       _textoMarkdown.substring(0, myController.selection.baseOffset);
  //   print("INICIO:" + inicio);
  //   String fim = _textoMarkdown.substring(
  //       myController.selection.baseOffset, _textoMarkdown.length);
  //   print("FIM:" + fim);

  //   _textoMarkdown = "$inicio$texto$fim";
  //   myController.setTextAndPosition(_textoMarkdown,
  //       caretPosition: myController.selection.baseOffset + posicao);
  // }

  // _iconesLista() {
  //   return !showFab
  //       ? Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
  //           children: <Widget>[
  //             IconButton(
  //               icon: Icon(Icons.format_bold),
  //               onPressed: () {
  //                 _atualizarMarkdown("****", 2);
  //               },
  //             ),
  //             IconButton(
  //               icon: Icon(Icons.format_size),
  //               onPressed: () {
  //                 _atualizarMarkdown("#", 1);
  //               },
  //             ),
  //             IconButton(
  //               icon: Icon(Icons.format_list_numbered),
  //               onPressed: () {
  //                 _atualizarMarkdown("- ", 2);
  //               },
  //             ),
  //             IconButton(
  //               icon: Icon(Icons.link),
  //               onPressed: () {
  //                 _atualizarMarkdown("[ clique aqui ](   )", 17);
  //               },
  //             ),
  //             IconButton(
  //                 icon: Icon(Icons.attach_file),
  //                 onPressed: () {
  //                   Navigator.push(context,
  //                       MaterialPageRoute(builder: (context) {
  //                     return UserFilesFirebaseList();
  //                   }));
  //                 })
  //           ],
  //         )
  //       : null;
  // }

  _bodyTexto(context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        new Expanded(
          child: ListView(
            // padding: EdgeInsets.all(5),
            children: <Widget>[
              // _texto("Texto da notícia:"),
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
        // new Container(
        //   color: Colors.white,
        //   padding: new EdgeInsets.all(10.0),
        //   child: _iconesLista(),
        // ),
      ],
    );
  }

  // ---------- TELA PREVIEW ----------

  _bodyPreview(context) {
    return StreamBuilder<ComunicacaoCRUDPageState>(
        stream: bloc.comunicacaoCRUDPageStateStream,
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
      bloc.comunicacaoCRUDPageEventSink(UpdateNoticiaIDEvent(noticiaId));
    }
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            // backgroundColor: Colors.red,
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
                    bloc.comunicacaoCRUDPageEventSink(
                        SaveStateToFirebaseEvent());
                  },
                  child: Icon(Icons.save),
                  backgroundColor: Colors.blue,
                )
              : null),
    );
  }
}
