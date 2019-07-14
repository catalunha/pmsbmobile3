import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/pages/aplicacao/pergunta_widget/pergunta_widget.dart';
import 'package:pmsbmibile3/pages/aplicacao/pergunta_widget/pergunta_widget_escolha_unica.dart';
import 'package:pmsbmibile3/pages/aplicacao/pergunta_widget/pergunta_wigdet_coordenada.dart';
import 'package:pmsbmibile3/pages/aplicacao/pergunta_widget/pergunta_wigdet_imagem.dart';

class AplicacaoPerguntaPage extends StatefulWidget {
  @override
  _AplicacaoPerguntaPageState createState() => _AplicacaoPerguntaPageState();
}

class _AplicacaoPerguntaPageState extends State<AplicacaoPerguntaPage> {
  
  List<String> _listaPergunta = [
    "texto",
    "imagem",
    "arquivo",
    "numero",
    "coordenada",
    "escolha unica",
    "escolha multipla"
  ];

  var _indice = 0;

  var _aplicadorpergunta = PerguntaWigdetCoordenada();

  String _eixo = "eixo exemplo";
  String _questionario = "questionarios exemplo";
  String _local = "local exemplo";
  String _setor = "setor exemplo";

  _botoes() {
    return Row(
      children: <Widget>[
        Expanded(
            flex: 2,
            child: Padding(
                padding: EdgeInsets.all(5),
                child: RaisedButton(
                    color: Colors.green,
                    onPressed: () {
                      // Pular pra proxima pergunta
                      print("VALOR ${_aplicadorpergunta}");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text('Pular', style: TextStyle(fontSize: 20)),
                        Icon(Icons.undo, textDirection: TextDirection.rtl)
                      ],
                    )))),
        Expanded(
            flex: 2,
            child: Padding(
                padding: EdgeInsets.all(5),
                child: RaisedButton(
                    color: Colors.blue,
                    onPressed: () {
                      // Responder a pergunta
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text('Salvar', style: TextStyle(fontSize: 20)),
                        Icon(Icons.thumb_up)
                      ],
                    )))),
      ],
    );
  }

  _listaDadosSuperior() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: Text(
            "Eixo - $_eixo",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: Text(
            "Setor - $_setor",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: Text(
            "Questionario - $_questionario",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Text(
            "Local - $_local",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        )
      ],
    );
  }

  Widget _body() {
    return ListView(
      children: <Widget>[
        _listaDadosSuperior(),
        Divider(height: 50, indent: 5, color: Colors.black54),
        Padding(
            padding: EdgeInsets.all(5),
            child: ListTile(
                title: Text("Titulo da pergunta:"),
                subtitle: Text(
                    "texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta - "))),
        Divider(color: Colors.black54),
        _aplicadorpergunta,
        Padding(padding: EdgeInsets.all(5)),
        _botoes()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text("Aplicando pergunta"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.location_on),
            onPressed: () {
              // ---
            },
          )
        ],
      ),
      body: _body(),
    );
  }
}
