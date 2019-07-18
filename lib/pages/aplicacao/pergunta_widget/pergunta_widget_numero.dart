import 'package:flutter/material.dart';


class PerguntaTipoNumeroWidget extends StatefulWidget {
  @override
  _PerguntaTipoNumeroWidgetState createState() => _PerguntaTipoNumeroWidgetState();
}

class _PerguntaTipoNumeroWidgetState extends State<PerguntaTipoNumeroWidget> {
 TextEditingController controller = new TextEditingController();

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
            controller: controller,
            keyboardType: TextInputType.number,
            maxLines: null,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ))
    ]));
  }
}