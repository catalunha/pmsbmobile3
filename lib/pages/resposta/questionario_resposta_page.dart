import 'package:flutter/material.dart';

//Resposta 01

class QuestionarioRespostaPage extends StatefulWidget {
  @override
  _QuestionarioRespostaPageState createState() =>
      _QuestionarioRespostaPageState();
}

class _QuestionarioRespostaPageState extends State<QuestionarioRespostaPage> {
  List<String> _questionariosresposta = ["Questionário de resposta 01",
  "Questionário de resposta 02",
  "Questionário de resposta 03",
  "Questionário de resposta 04"];

  String _eixo = "eixo exemplo";
  String _setor = "setor exemplo";

  _listaQuestionarioResposta() {
    return Builder(
        builder: (BuildContext context) => new Container(
              child: _questionariosresposta.length >= 0
                  ? new ListView.separated(
                      itemCount: _questionariosresposta.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(_questionariosresposta[index]),
                          trailing: IconButton(
                            icon: Icon(Icons.remove_red_eye),
                            onPressed: () {
                              //abrir pagina que lista resposta de um questionário
                              Navigator.pushNamed(
                                  context, "/resposta/resposta_questionario");
                            },
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          new Divider(),
                    )
                  : new Container(),
            ));
  }

  _bodyTodos() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "Eixo : $_eixo",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "Eixo : $_setor",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        Expanded(child: _listaQuestionarioResposta())
      ],
    );
  }

  _bodyArvore() {
    return Container(
      child: Center(
        child: Text(
          "Em construção",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: "Todos"),
              Tab(text: "Arvore"),
            ],
          ),
          title: Text('Questionários com reposta'),
        ),
        body: TabBarView(
          children: [
            _bodyTodos(),
            _bodyArvore(),
          ],
        ),
      ),
    );
  }
}
