import 'package:flutter/material.dart';

class PerguntaTipoTextoWidget extends StatefulWidget {

  @override
  _PerguntaTipoTextoWidgetState createState() => _PerguntaTipoTextoWidgetState();
}

class _PerguntaTipoTextoWidgetState extends State<PerguntaTipoTextoWidget> {
  TextEditingController respostaTextoController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
        Padding(
            padding: EdgeInsets.all(5),
            child: Text("Resposta da pergunta:",
                style: TextStyle(color: Colors.blue))),
        Padding(
            padding: EdgeInsets.all(5.0),
            child: TextField(
              controller: respostaTextoController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ))
      ]),
    );
  }
}
