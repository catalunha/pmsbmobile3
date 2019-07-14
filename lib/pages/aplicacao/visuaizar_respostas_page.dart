import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';

// Aplicação 04

class VisualizarRespModelTemp {
  String titulo;
  String texto;
  String resposta;

  VisualizarRespModelTemp(
    this.titulo,
    this.texto,
    this.resposta,
  );
}

class VisualizarRespostasPage extends StatefulWidget {
  @override
  _VisualizarRespostasPageState createState() =>
      _VisualizarRespostasPageState();
}

class _VisualizarRespostasPageState extends State<VisualizarRespostasPage> {
  String _eixo = "eixo exemplo";
  String _setor = "setor censitário";
  String _questionario = "questionario exemplo";
  String _local = "local exemplo";

  VisualizarRespModelTemp visualizarRespModelTemp =
      new VisualizarRespModelTemp("", "", "resposta conforme tipo");

  _body(BuildContext context) {
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
        Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            "Local : $_local",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        cardResposta(visualizarRespModelTemp),
      ],
    );
  }

  Card cardResposta(visualizarRespModelTemp) {
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
                    Text(
                        "* Título da pergunta: ${visualizarRespModelTemp.titulo} "),
                    Text(
                        "* Texto da pergunta: ${visualizarRespModelTemp.texto}"),
                    Text("* Resposta: ${visualizarRespModelTemp.resposta}"),
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
    return DefaultScaffold(
      backgroundColor: Colors.red,
      body: _body(context),
      title: Text("Visualizando Respostas"),
    );
  }
}
