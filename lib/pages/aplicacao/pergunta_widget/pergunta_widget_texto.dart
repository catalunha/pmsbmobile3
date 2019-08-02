import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/initial_value_text_field.dart';

class PerguntaTipoTextoWidget extends StatelessWidget {

  final void Function(String) updateText;
  final bool Function() initialize;
  final String initialValue;
  final String perguntaAplicadaID;

  const PerguntaTipoTextoWidget({
    Key key,
    this.perguntaAplicadaID,
    this.updateText,
    this.initialize,
    this.initialValue,
  })  : assert(initialize != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(5),
              child: Text("Resposta da pergunta:",
                  style: TextStyle(color: Colors.blue))),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: InitialValueTextField(
              initialize: initialize,
              value: initialValue,
              id: perguntaAplicadaID,
              onChanged: updateText,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
