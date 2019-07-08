import 'package:flutter/material.dart';

class PerguntaHomePage extends StatefulWidget {
  @override
  _PerguntaHomePageState createState() => _PerguntaHomePageState();
}

class _PerguntaHomePageState extends State<PerguntaHomePage> {
  
  List<String> _perguntas = [
    "01 - pergunta texto",
    "02 - pergunta imagem",
    "03 - pergunta numero",
    "04 - pergunta coordenada",
    "05 - pergunta escolha unica",
    "06 - pergunta escolha multipla",
  ];

  String _eixo = "eixo exemplo";
  String _questionario = "questionarios exemplo";

  _listaProdutos() {
    return Builder(
        builder: (BuildContext context) => new Container(
              child: _perguntas.length >= 0
                  ? new ListView.builder(
                      itemCount: _perguntas.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            elevation: 10,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  title: Text(_perguntas[index]),
                                ),
                                ButtonTheme.bar(
                                  child: ButtonBar(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.arrow_downward),
                                        onPressed: () {
                                          //Mover pergunta para baixo na ordem
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.arrow_upward),
                                        onPressed: () {
                                          //Mover pergunta para cima na ordem
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          //Editar pergunta
                                         
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ));
                      })
                  : Container(),
            ));
  }

  Widget _body() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "Eixo - $_eixo",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            "Setor - $_questionario",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        Expanded(child: _listaProdutos()),
        Padding(padding: EdgeInsets.all(30))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text("Criar pergunta do tipo"),
      ),
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Adicionar um nova pergunta
          Navigator.pushNamed(context, '/pergunta/criar_pergunta');
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,

      ),
    );
  }
}
