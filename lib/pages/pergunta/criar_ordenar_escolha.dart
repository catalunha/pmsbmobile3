import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class CriarOrdenarEscolha extends StatefulWidget {
  @override
  _CriarOrdenarEscolhaState createState() => _CriarOrdenarEscolhaState();
}

class _CriarOrdenarEscolhaState extends State<CriarOrdenarEscolha> {
  String _eixo = "eixo exemplo";
  String _questionario = "Setor exemplo";
  String _pergunta = "produto exemplo";
  List<String> _perguntaescolha = ['Sim', 'Não'];

  _textoTopo(text) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, color: Colors.blue),
      ),
    );
  }

  _listarPerguntaEscolha() {
    return ListView.builder(
        itemCount: _perguntaescolha.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 10,
            child: Row(
              children: <Widget>[
                Expanded(
                    flex: 3,
                    child: ListTile(
                      leading: Icon(Icons.info),
                      title: Text(_perguntaescolha[index]),
                    )),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.arrow_downward),
                          onPressed: () {
                            // Mover pra baixo na ordem
                          }),
                      IconButton(
                          icon: Icon(Icons.arrow_upward),
                          onPressed: () {
                            // Mover pra cima na ordem
                          }),
                      IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Editar uma nova escolha
                            Navigator.pushNamed(
                                context, "/pergunta/editar_apagar_escolha");
                          }),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  _body() {
    return Container(
        alignment: Alignment(0.0, 0.0),
        child: Column(children: <Widget>[
          _textoTopo("Eixo: $_eixo"),
          _textoTopo("Questionario: $_questionario"),
          _textoTopo("Pergunta: $_pergunta"),
          Padding(padding: EdgeInsets.all(10)),
          Expanded(child: _listarPerguntaEscolha())
        ]));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          automaticallyImplyLeading: true,
          title: Text('Criar ordenar escolha'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Adicionar uma nova escolha
            Navigator.pushNamed(context, "/pergunta/editar_apagar_escolha");
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
        body: _body());
  }
}
