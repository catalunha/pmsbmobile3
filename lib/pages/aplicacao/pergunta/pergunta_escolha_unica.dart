import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/pages/aplicacao/pergunta/pergunta_escolha_unica_bloc.dart';

class PerguntaEscolhaUnica extends StatefulWidget {
  final PerguntaAplicadaModel perguntaAplicada;

  const PerguntaEscolhaUnica(this.perguntaAplicada, {Key key})
      : super(key: key);

  @override
  _PerguntaEscolhaUnicaState createState() => _PerguntaEscolhaUnicaState();
}

class _PerguntaEscolhaUnicaState extends State<PerguntaEscolhaUnica> {
  PerguntaEscolhaUnicaBloc bloc;

  @override
  void initState() {
    bloc = PerguntaEscolhaUnicaBloc(widget.perguntaAplicada);
    super.initState();
  }

  Widget _listaDeEscolhas() {
    return StreamBuilder<PerguntaEscolhaUnicaBlocState>(
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
        return Column(
          children: widget.perguntaAplicada.escolhas
              .map((key, escolha) {
                return MapEntry(
                  key,
                  RadioListTile<String>(
                    value: key,
                    groupValue: snapshot.data.escolhaID,
                    onChanged: (id) {
                      bloc.dispatch(
                          MudarEscolhaPerguntaEscolhaUnicaBlocEvent(id));
                    },
                    activeColor: Colors.green,
                    controlAffinity: ListTileControlAffinity.trailing,
                    title: new Text(escolha.texto),
                  ),
                );
              })
              .values
              .toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5),
            child: Text("Selecione uma opcao:"),
          ),
          _listaDeEscolhas(),
        ],
      ),
    );
  }
}
