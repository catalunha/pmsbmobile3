import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';

class PerguntaEscolhaUnicaWidget extends StatefulWidget {
  final PerguntaAplicadaModel pergunta;

  const PerguntaEscolhaUnicaWidget(this.pergunta, {Key key}) : super(key: key);

  @override
  _PerguntaEscolhaUnicaWidgetState createState() =>
      _PerguntaEscolhaUnicaWidgetState();
}

class _PerguntaEscolhaUnicaWidgetState
    extends State<PerguntaEscolhaUnicaWidget> {
  _PerguntaEscolhaUnicaWidgetState();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5),
            child: Text("Selecione uma opcao:"),
          ),
          Column(
            children: widget.pergunta.escolhas
                .map((key, escolha) {
                  return MapEntry(
                    key,
                    RadioListTile<String>(
                      value: key,
                      groupValue: "",
                      onChanged: (novovalor) {},
                      activeColor: Colors.green,
                      controlAffinity: ListTileControlAffinity.trailing,
                      // dependendo de como o valor for recebido alterar essa parte o codigo
                      title: new Text(escolha.texto),
                    ),
                  );
                })
                .values
                .toList(),
          ),
        ],
      ),
    );
  }
}
