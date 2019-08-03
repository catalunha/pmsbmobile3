import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/pages/aplicacao/pergunta/pergunta_escolha_multipla_bloc.dart';

class PerguntaEscolhaMultipla extends StatefulWidget {
  const PerguntaEscolhaMultipla(
    this.perguntaAplicada, {
    Key key,
  }) : super(key: key);

  final PerguntaAplicadaModel perguntaAplicada;

  @override
  _PerguntaEscolhaMultiplaState createState() =>
      _PerguntaEscolhaMultiplaState();
}

class _PerguntaEscolhaMultiplaState extends State<PerguntaEscolhaMultipla> {
  PerguntaEscolhaMultiplaBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = PerguntaEscolhaMultiplaBloc(widget.perguntaAplicada);
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  Widget makeRadioTiles() {
    return StreamBuilder<PerguntaEscolhaMultiplaBlocState>(
      stream: bloc.state,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("ERROR"),
          );
        }
        if (!snapshot.hasData) {
          return Center(
            child: Text("CARREGANDO"),
          );
        }

        final map = widget.perguntaAplicada.escolhas.map(
          (id, escolha) {
            return MapEntry(
              id,
              MultiplaEscolhaTile(
                escolha,
                onChanged: (value) {
                  bloc.dispatch(
                      AlternarEstadoEscolhaPerguntaEscolhaMultiplaBlocEvent(
                          id));
                },
              ),
            );
          },
        );
        return Column(
          children: map.values.toList(),
        );
      },
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
