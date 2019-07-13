import 'package:flutter/material.dart';

class AdicionarEditarQuestionarioPage extends StatefulWidget {
  @override
  _AdicionarEditarQuestionarioPageState createState() =>
      _AdicionarEditarQuestionarioPageState();
}

class _AdicionarEditarQuestionarioPageState
    extends State<AdicionarEditarQuestionarioPage> {
  String _eixo = "eixo exemplo";
  String _questionario = "Setor exemplo";

  _textoTopo(text) {
    return Center(
      child: Text(
        "$text",
        style: TextStyle(fontSize: 16, color: Colors.blue),
      ),
    );
  }

  _body(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(padding: EdgeInsets.all(5.0)),
        _textoTopo("Eixo: $_eixo"),
        _textoTopo("Setor: $_questionario"),
        Padding(padding: EdgeInsets.all(5.0)),
        Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(
              "Titulo do questionario:",
              style: TextStyle(fontSize: 15, color: Colors.blue),
            )),
        Padding(
            padding: EdgeInsets.all(5.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            )),
        SafeArea(
            child: Row(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(5.0),
                child: RaisedButton(
                    color: Colors.red,
                    onPressed: () {
                      // Deletar este questionario
                    },
                    child: Row(
                      children: <Widget>[
                        Text('Apagar', style: TextStyle(fontSize: 20)),
                        Icon(Icons.delete)
                      ],
                    ))),
          ],
        ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.red,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text("Adicionar ou editar questionario")),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.thumb_up),
          onPressed: () {
            // salvar e voltar
            Navigator.pop(context);
          },
        ),
        body: _body(context));
  }
}
