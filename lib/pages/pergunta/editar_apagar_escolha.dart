import 'package:flutter/material.dart';

class EditarApagarEscolhaPage extends StatefulWidget {
  @override
  _EditarApagarEscolhaPageState createState() =>
      _EditarApagarEscolhaPageState();
}

class _EditarApagarEscolhaPageState extends State<EditarApagarEscolhaPage> {
  String _eixo = "eixo exemplo";

  _botaoDeletar() {
    return SafeArea(
        child: Row(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(5.0),
            child: RaisedButton(
                color: Colors.red,
                onPressed: () {
                  // DELETAR ESTA PERGUNTA
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

  _areaTexto() {
    return Padding(
        padding: EdgeInsets.all(5.0),
        child: TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ));
  }

  _textoTopo(text) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, color: Colors.blue),
      ),
    );
  }

  _body() {
    return Container(
        child: Column(children: <Widget>[
      _textoTopo("Eixo: $_eixo"),
      _textoTopo("RS 01 - Questionarios de ..."),
      _textoTopo("Pergunta tipo escolha unica"),
      _textoTopo("Edição das escolhas"),
      Padding(padding: EdgeInsets.all(5)),
      Divider(color: Colors.black, height: 5),
      Padding(
          padding: EdgeInsets.all(5.0),
          child: Text(
            "Titulo da escolha:",
            style: TextStyle(fontSize: 15, color: Colors.blue),
          )),
      _areaTexto(),
      _botaoDeletar()
    ]));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          automaticallyImplyLeading: true,
          title: Text('Editar ou apagar escolha'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Salvar nova escolha
            Navigator.pop(context);
          },
          child: Icon(Icons.thumb_up),
          backgroundColor: Colors.blue,
        ),
        body: _body());
  }
}
