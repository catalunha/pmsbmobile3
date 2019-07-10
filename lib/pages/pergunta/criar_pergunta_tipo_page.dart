import 'package:flutter/material.dart';

class CriarPerguntaTipoPage extends StatefulWidget {
  @override
  _CriarPerguntaTipoPageState createState() => _CriarPerguntaTipoPageState();
}

class _CriarPerguntaTipoPageState extends State<CriarPerguntaTipoPage> {
  String _eixo = "eixo exemplo";
  String _questionario = "questionarios exemplo";

  _body() {
    return Container(
        child: Column(children: <Widget>[
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
      Card(
        child: ListTile(
          title: Text("Pergunta tipo texto"),
          trailing: IconButton(icon:Icon(Icons.list, color: Colors.black), onPressed:(){
            // pergunta do tipo texto
            Navigator.pushNamed(context, "/pergunta/criar_editar");
          },)
        ),
        elevation: 15,
      ),
      Card(
        child: ListTile(
          title: Text("Pergunta tipo imagem"),
          trailing: IconButton(icon:Icon(Icons.image, color: Colors.black), onPressed:(){
            // pergunta do tipo imagem
            Navigator.pushNamed(context, "/pergunta/criar_editar");
          },)
        ),
        elevation: 15,
      ),
      Card(
        child: ListTile(
          title: Text("Pergunta tipo numero"),
          trailing: IconButton(icon:Icon(Icons.plus_one, color: Colors.black), onPressed:(){
            // pergunta do tipo numero
            Navigator.pushNamed(context, "/pergunta/criar_editar");
          },)
        ),
        elevation: 15,
      ),
      Card(
        child: ListTile(
          title: Text("Pergunta tipo coordenada"),
           trailing: IconButton(icon:Icon(Icons.room), color: Colors.black, onPressed:(){
            // pergunta do tipo coordenada
            Navigator.pushNamed(context, "/pergunta/criar_editar");
          },)
        ),
        elevation: 15,
      ),
      Card(
        child: ListTile(
          title: Text("Pergunta tipo escolha única"),
           trailing: IconButton(icon:Icon(Icons.looks_one, color: Colors.black), onPressed:(){
            // pergunta do tipo escolha única"
            Navigator.pushNamed(context, "/pergunta/criar_editar");
          },)
        ),
        elevation: 15,
      ),
      Card(
        child: ListTile(
          title: Text("Pergunta tipo escolha multipla"),
           trailing: IconButton(icon:Icon(Icons.queue, color: Colors.black), onPressed:(){
            // pergunta do tipo escolha multipla
            Navigator.pushNamed(context, "/pergunta/criar_editar");
          },)
        ),
        elevation: 15,
      ),
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text("Lista de perguntas"),
      ),
      body: _body(),
    );
  }
}
