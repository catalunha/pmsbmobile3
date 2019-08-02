import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/initial_value_text_field.dart';

class PerguntaTipoNumeroWidget extends StatelessWidget {
  final void Function(String) onChanged;
  final void Function() initialize;
  final String perguntaAplicadaID;
  final String initialValue;

  const PerguntaTipoNumeroWidget({
    Key key,
    this.onChanged,
    this.initialize,
    this.perguntaAplicadaID,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: <Widget>[
      Padding(
        padding: EdgeInsets.all(5),
        child: Text(
          "Resposta da pergunta:",
          style: TextStyle(color: Colors.blue),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(5.0),
        child: InitialValueTextField(
          initialize: initialize,
          value: initialValue,
          id: perguntaAplicadaID,
          onChanged: onChanged,
          keyboardType: TextInputType.number,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      )
    ]));
  }
}
