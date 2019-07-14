import 'package:flutter/material.dart';

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
  final List listaOpcoes;

  const PerguntaEscolhaMultiplaWidget({Key key, @required this.listaOpcoes})
      : super(key: key);

  @override
  _PerguntaEscolhaMultiplaWidgetState createState() =>
      _PerguntaEscolhaMultiplaWidgetState();
}

class _PerguntaEscolhaMultiplaWidgetState
    extends State<PerguntaEscolhaMultiplaWidget> {
  Widget makeRadioTiles() {
    List<Widget> list = new List<Widget>();

    for (int i = 0; i < widget.listaOpcoes.length; i++) {
      list.add(new CheckboxListTile(
        value: widget.listaOpcoes[i]['checkbox'],
        onChanged: (bool value) {
          setState(() {
            widget.listaOpcoes[i]['checkbox'] = value;
          });
        },
        activeColor: Colors.green,
        controlAffinity: ListTileControlAffinity.trailing,
        // dependendo de como o valor for recebido alterar essa parte o codigo
        title: new Text(widget.listaOpcoes[i]['pergunta']),
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
      Padding(padding: EdgeInsets.all(5), child: Text("Selecione uma opcao:")),
      makeRadioTiles()
    ]));
  }
}
