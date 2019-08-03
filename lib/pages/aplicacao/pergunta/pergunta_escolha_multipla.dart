import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';

class PerguntaEscolhaMultipla extends StatefulWidget {
  const PerguntaEscolhaMultipla(
    this.pergunta, {
    Key key,
  }) : super(key: key);

  final PerguntaAplicadaModel pergunta;

  @override
  _PerguntaEscolhaMultiplaState createState() =>
      _PerguntaEscolhaMultiplaState();
}

class _PerguntaEscolhaMultiplaState extends State<PerguntaEscolhaMultipla> {
  Widget makeRadioTiles() {
    final map = widget.pergunta.escolhas.map(
      (k, v) {
        return MapEntry(
            k,
            MultiplaEscolhaTile(v, onChanged: (value) {
              //bloc.dispatch(); //marcar na resposta
            }));
      },
    );
    return Column(
      children: map.values.toList(),
    );
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

class MultiplaEscolhaTile extends StatelessWidget {
  final Escolha escolha;
  final void Function(bool) onChanged;

  const MultiplaEscolhaTile(
    this.escolha, {
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: escolha.marcada,
      onChanged: onChanged,
      activeColor: Colors.green,
      controlAffinity: ListTileControlAffinity.trailing,
      title: new Text(escolha.texto),
    );
  }
}
