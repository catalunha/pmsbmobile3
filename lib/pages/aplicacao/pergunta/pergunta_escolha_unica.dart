import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';

class PerguntaEscolhaUnica extends StatefulWidget {
  final PerguntaAplicadaModel pergunta;

  const PerguntaEscolhaUnica(this.pergunta, {Key key}) : super(key: key);

  @override
  _PerguntaEscolhaUnicaState createState() =>
      _PerguntaEscolhaUnicaState();
}

class _PerguntaEscolhaUnicaState
    extends State<PerguntaEscolhaUnica> {

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
