import 'package:flutter/material.dart';

List<Map<String, dynamic>> perguntasquesitoescolhaunica = [
  {'pergunta': 'Pergunta texto ', 'checkbox': true},
  {'pergunta': 'Pergunta unica / sim', 'checkbox': false},
  {'pergunta': 'Pergunta unicao / Nâo', 'checkbox': false},
  {'pergunta': 'Pergunta texto ', 'checkbox': true},
  {'pergunta': 'Pergunta unica / sim', 'checkbox': false},
  {'pergunta': 'Pergunta unicao / Nâo', 'checkbox': false}
];

class PerguntaEscolhaUnicaWidget extends StatefulWidget {
  final int valor;
  final List listaOpcoes;

  const PerguntaEscolhaUnicaWidget(
      {Key key, @required this.listaOpcoes = null, this.valor = 0})
      : super(key: key);

  @override
  _PerguntaEscolhaUnicaWidgetState createState() =>
      _PerguntaEscolhaUnicaWidgetState(valor);
}

class _PerguntaEscolhaUnicaWidgetState
    extends State<PerguntaEscolhaUnicaWidget> {
  int valor;

  _PerguntaEscolhaUnicaWidgetState(this.valor);

  void _setvalue2(int value) => setState(() => {valor = value});

  Widget makeRadioTiles() {
    List<Widget> list = new List<Widget>();

    for (int i = 0; i < widget.listaOpcoes.length; i++) {
      list.add(new RadioListTile(
        value: i,
        groupValue: valor,
        onChanged: _setvalue2,
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

/**
 * for (var i = 0; i < widget.listaOpcoes.length; i++)
        RadioListTile(
          groupValue: _value2,
          onChanged: _setvalue2,
          value: widget.listaOpcoes[i]['checkbox'],
          title: new Text('${widget.listaOpcoes[i]['pergunta']}'),
          controlAffinity: ListTileControlAffinity.trailing,
        ),
 */
