import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/initial_value_text_field.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/pages/aplicacao/pergunta/pergunta_texto_bloc.dart';

class PerguntaTexto extends StatefulWidget {
  final PerguntaAplicadaModel perguntaAplicada;

  const PerguntaTexto(this.perguntaAplicada, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PerguntaTextoState();
  }
}

class _PerguntaTextoState extends State<PerguntaTexto> {
  PerguntaTextoBloc bloc;

  @override
  void initState() {
    bloc = PerguntaTextoBloc(widget.perguntaAplicada);
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

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
              initialize: () {
                if (widget.perguntaAplicada.texto == null) return false;
                return widget.perguntaAplicada.texto.isNotEmpty;
              },
              value: widget.perguntaAplicada.texto,
              id: widget.perguntaAplicada.id,
              onChanged: (text) {
                bloc.dispatch(UpdateTextoRespostaPerguntaTextoBlocEvent(text));
              },
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
