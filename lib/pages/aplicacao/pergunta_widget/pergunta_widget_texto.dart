import 'package:flutter/material.dart';

TextEditingController respostaTextoController = new TextEditingController();

Widget perguntaTipoTexto(BuildContext context) {
  return Column(children: <Widget>[
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
  ]);
}
