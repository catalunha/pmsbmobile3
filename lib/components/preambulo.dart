import 'package:flutter/material.dart';

class Preambulo extends StatelessWidget {
  final String usuario;
  final String eixo;
  final String questionario;
  final String setor;
  final String pergunta;
  final String local;

  const Preambulo({
    Key key,
    this.usuario,
    this.eixo,
    this.questionario,
    this.setor,
    this.pergunta,
    this.local,
  })  : assert(usuario is String),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (usuario != null) PreambuloTexto(usuario),
        if (eixo != null) PreambuloTexto(eixo),
        if (setor != null) PreambuloTexto(setor),
        if (questionario != null) PreambuloTexto(questionario),
        if (local != null) PreambuloTexto(local),
        if (pergunta != null) PreambuloTexto(pergunta),
      ],
    );
  }
}

class PreambuloTexto extends StatelessWidget {
  final String text;

  const PreambuloTexto(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      child: Text(
        text,
        style: TextStyle(color: Colors.blueAccent),
      ),
    );
  }
}
