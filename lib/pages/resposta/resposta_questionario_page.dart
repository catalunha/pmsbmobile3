import 'package:flutter/material.dart';

//Resposta 02

class RespostaQuestionarioPage extends StatefulWidget {
  @override
  _RespostaQuestionarioPageState createState() => _RespostaQuestionarioPageState();
}

class _RespostaQuestionarioPageState extends State<RespostaQuestionarioPage> {

  List<String> _respostaquestionario = [];


  String _eixo = "eixo exemplo";
  String _setor = "setor exemplo";
  String _questionario = "questionario exemplo";


  _body() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text("Respostas"),
      ),
      body: _body(),
    );
  }
}
