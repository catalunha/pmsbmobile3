import 'package:flutter/material.dart';

//Resposta 02

class RespostaModelTemp {
  String local;
  String titulo;
  String texto;
  String datahora;
  String respondido;
  String localdaresposta;
  String resposta;

  RespostaModelTemp(
    this.local,
    this.titulo,
    this.texto,
    this.datahora,
    this.respondido,
    this.localdaresposta,
    this.resposta,
  );
}

class RespostaQuestionarioPage extends StatefulWidget {
  @override
  _RespostaQuestionarioPageState createState() =>
      _RespostaQuestionarioPageState();
}

class _RespostaQuestionarioPageState extends State<RespostaQuestionarioPage> {
  String _eixo = "eixo exemplo";
  String _setor = "setor exemplo";
  String _questionario = "questionario exemplo";

  RespostaModelTemp respostaModelTemp = new RespostaModelTemp(
      "Cidade/Joao/Viagem1",
      "Pergunta1",
      "Texto1",
      "Data/Hora",
      "Respondido",
      "LocaldaResposta",
      "Resposta");

  _body() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            "Eixo : $_eixo",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            "Setor : $_setor",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            "Questionário : $_questionario",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        cardResposta(respostaModelTemp),
      ],
    );
  }

  Card cardResposta(respostaModelTemp) {
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 7,
              child: Container(
                padding: EdgeInsets.only(left: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("* Local/Pessoa/Momento: ${respostaModelTemp.local} "),
                    Text("* Titulo: ${respostaModelTemp.titulo}"),
                    Text("* Texto: ${respostaModelTemp.texto}"),
                    Text("* Data/Hora: ${respostaModelTemp.datahora}"),
                    Text("* Respondido: ${respostaModelTemp.respondido}"),
                    Text(
                        "* Local da resposta: ${respostaModelTemp.localdaresposta}"),
                    Text("* Resposta: ${respostaModelTemp.resposta}"),
//                      itens.forEach((i)=>Text(i)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text("Perguntas e Respostas"),
      ),
      body: _body(),
    );
  }
}
