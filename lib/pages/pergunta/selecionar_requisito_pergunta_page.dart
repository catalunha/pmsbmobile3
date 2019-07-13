import 'package:flutter/material.dart';

class SelecionarQuequisitoPerguntaPage extends StatefulWidget {
  @override
  _SelecionarQuequisitoPerguntaPageState createState() =>
      _SelecionarQuequisitoPerguntaPageState();
}

class _SelecionarQuequisitoPerguntaPageState
    extends State<SelecionarQuequisitoPerguntaPage> {
  //List<bool> inputs = [false, false, false];
  //List<String> _perguntasquesito = ["Area 01", "Area 02", "Area 03"];

  List<Map<String, dynamic>> _perguntasquesito = [
    {'pergunta': 'Pergunta texto ', 'checkbox': true},
    {'pergunta': 'Pergunta unica / sim', 'checkbox': false},
    {'pergunta': 'Pergunta unicao / Nâo', 'checkbox': false}
  ];

  @override
  void initState() {
    // TODO: implement initState
    setState(() {});
  }

  void _itemChange(bool val, int index) {
    setState(() {
      _perguntasquesito[index]['checkbox'] = val;
    });
  }

  _body() {
    return ListView.builder(
        itemCount: _perguntasquesito.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              //padding: new EdgeInsets.all(10.0),
              child: CheckboxListTile(
                  value: _perguntasquesito[index]['checkbox'],
                  title: new Text('${_perguntasquesito[index]['pergunta']}'),
                  controlAffinity: ListTileControlAffinity.trailing,
                  onChanged: (bool val) {
                    _itemChange(val, index);
                  }));
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          automaticallyImplyLeading: true,
          title: Text('Selecionar Requisitos'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.thumb_up),
          backgroundColor: Colors.blue,
        ),
        body: _body());
  }
}
