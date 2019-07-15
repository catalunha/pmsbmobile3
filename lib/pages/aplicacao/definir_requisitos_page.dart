import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';

// Aplicação 05

class DefinirRequisistosPage extends StatefulWidget {
  const DefinirRequisistosPage({Key key}) : super(key: key);

  @override
  _DefinirRequisistosPageState createState() => _DefinirRequisistosPageState();
}

class _DefinirRequisistosPageState extends State<DefinirRequisistosPage> {
  List<Map<String, dynamic>> perguntasquesitoescolhamultipla = [
    {'questionario': 'Questionario1 ', 'referencia': "local 01",'checkbox': false},
    {'questionario': 'Questionario1 ', 'referencia': "local 02",'checkbox': false},


  ];

  String _eixo = "eixo exemplo";
  String _setor = "setor exemplo";
  String _questionario = "questionario exemplo";
  String _local = "local exemplo";

  Widget makeRadioTiles() {
    List<Widget> list = new List<Widget>();

    for (int i = 0; i < perguntasquesitoescolhamultipla.length; i++) {
      list.add(new CheckboxListTile(
        value: perguntasquesitoescolhamultipla[i]['checkbox'],
        onChanged: (bool value) {
          setState(() {
            perguntasquesitoescolhamultipla[i]['checkbox'] = value;
          });
        },
        activeColor: Colors.green,
        controlAffinity: ListTileControlAffinity.trailing,
        // dependendo de como o valor for recebido alterar essa parte o codigo
        title: new Text(perguntasquesitoescolhamultipla[i]['questionario']),
        subtitle: new Text(perguntasquesitoescolhamultipla[i]['referencia']),
      ));
    }

    Column column = new Column(
      children: list,
    );
    return column;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        actions: <Widget>[],
        centerTitle: true,
        title: Text("Definindo requisitos"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          // retornar pras telas anteriores os setotes sensitarios que foram selecionados
          Navigator.of(context).pop();
        },
        child: Icon(Icons.thumb_up),
        backgroundColor: Colors.blue,
      ),
      body: Container(
          child: Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.all(3),
              child: Text(
                "Eixo : $_eixo",
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(3),
              child: Text(
                "Setor : $_setor",
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(3),
              child: Text(
                "Questionário : $_questionario",
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(3),
              child: Text(
                "Local : $_local",
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
        Padding(
          padding: EdgeInsets.all(3),
        ),
        Padding(
            padding: EdgeInsets.all(5), child: Text("Questionário 03 -> Pergunta 01")),
        makeRadioTiles()

      ])),
    );
  }
}
