import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';

List<Map<String, dynamic>> perguntasquesitoescolhamultipla = [
  {'pergunta': 'Opcao ', 'checkbox': false},
  {'pergunta': 'Opcao ', 'checkbox': false},
  {'pergunta': 'Opcao ', 'checkbox': false},
  {'pergunta': 'Opcao ', 'checkbox': false},
  {'pergunta': 'Opcao ', 'checkbox': false},
  {'pergunta': 'Opcao ', 'checkbox': false},
  {'pergunta': 'Opcao ', 'checkbox': false},
];

class PerguntaEscolhaMultiplaWidget extends StatefulWidget {
  const PerguntaEscolhaMultiplaWidget(this.pergunta,{Key key, @required this.entrada,})
      : super(key: key);
  final List entrada;
  final PerguntaAplicadaModel pergunta;

  @override
  _PerguntaEscolhaMultiplaWidgetState createState() =>
      _PerguntaEscolhaMultiplaWidgetState();
}

class _PerguntaEscolhaMultiplaWidgetState
    extends State<PerguntaEscolhaMultiplaWidget> {
  Widget makeRadioTiles() {
    List<Widget> list = new List<Widget>();

    for (int i = 0; i < widget.entrada.length; i++) {
      list.add(new CheckboxListTile(
        value: widget.entrada[i]['checkbox'],
        onChanged: (bool value) {
          setState(() {
            widget.entrada[i]['checkbox'] = value;
          });
        },
        activeColor: Colors.green,
        controlAffinity: ListTileControlAffinity.trailing,
        // dependendo de como o valor for recebido alterar essa parte o codigo
        title: new Text(widget.entrada[i]['pergunta']),
      ));
    }

    Column column = new Column(
      children: list,
    );
    return column;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: <Widget>[
      Padding(padding: EdgeInsets.all(5), child: Text("Selecione as opçoes:")),
      makeRadioTiles()
    ]));
  }
}
