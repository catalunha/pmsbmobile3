import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/initial_value_text_field.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/pages/aplicacao/pergunta/pergunta_numero_bloc.dart';

class PerguntaNumero extends StatefulWidget {
  final PerguntaAplicadaModel perguntaAplicada;

  const PerguntaNumero(this.perguntaAplicada, {Key key}) : super(key: key);

  @override
  _PerguntaNumeroState createState() {
    return _PerguntaNumeroState();
  }
}

class _PerguntaNumeroState extends State<PerguntaNumero> {
  PerguntaNumeroBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = PerguntaNumeroBloc(widget.perguntaAplicada);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

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
          id: widget.perguntaAplicada.id,
          initialize: () {
            if (widget.perguntaAplicada.numero == null) return false;
            return true;
          },
          value: widget.perguntaAplicada.numero.toString(),
          onChanged: (text) {
            bloc.dispatch(UpdateNumeroRespostaPerguntaNumeroBlocEvent(text));
          },
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
