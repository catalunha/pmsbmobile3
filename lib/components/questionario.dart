import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/questionario_model.dart';

class QuestionarioNome extends StatelessWidget {
  final QuestionarioModel _questionario;

  QuestionarioNome(this._questionario);

  @override
  Widget build(BuildContext context) {
    var pretext = "Questionario - ";
    if (_questionario.nome == null) return Text("$pretext ");
    return Text("$pretext ${_questionario.nome}");
  }
}
