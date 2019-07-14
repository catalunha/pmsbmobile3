import 'package:flutter/material.dart';

TextEditingController controller = new TextEditingController();

Widget perguntaTipoNumero(BuildContext context) {
  return Column(children: <Widget>[
    Padding(
        padding: EdgeInsets.all(5),
        child: Text("Resposta da pergunta:",
            style: TextStyle(color: Colors.blue))),
    Padding(
        padding: EdgeInsets.all(5.0),
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ))
  ]);
}
