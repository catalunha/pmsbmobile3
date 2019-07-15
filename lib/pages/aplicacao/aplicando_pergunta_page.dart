import 'package:flutter/material.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/pages/aplicacao/pergunta_widget/pergunta_widget.dart';

class AplicacaoPerguntaPage extends StatefulWidget {
  @override
  _AplicacaoPerguntaPageState createState() => _AplicacaoPerguntaPageState();
}

class _AplicacaoPerguntaPageState extends State<AplicacaoPerguntaPage> {
  List<Map<String, dynamic>> _listaPergunta = [
    {
      "tipo": "escolha_unica",
      'parametros': perguntasquesitoescolhaunica,
      'titulo': "Pergunta escolha unica",
      "texto":
          "texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta"
    },
    {
      "tipo": "escolha_multipla",
      'parametros': perguntasquesitoescolhaunica,
      'titulo': "Pergunta escolha_multipla",
      "texto":
          "texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta"
    },
    {
      "tipo": "imagem",
      'parametros': null,
      'titulo': "Pergunta imagem",
      "texto":
          "texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta"
    },
    {
      "tipo": "arquivo",
      'parametros': null,
      'titulo': "Pergunta arquivo",
      "texto":
          "texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta"
    },
    {
      "tipo": "texto",
      'parametros': null,
      'titulo': "Pergunta texto",
      "texto":
          "texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta"
    },
    {
      "tipo": "numero",
      'parametros': null,
      'titulo': "Pergunta numero",
      "texto":
          "texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta"
    },
    {
      "tipo": "coordenada",
      'parametros': null,
      'titulo': "Pergunta coordenada",
      "texto":
          "texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta - texto da pergunta"
    }
  ];

  MapaPerguntasWidget mapaTipoPergunta = MapaPerguntasWidget();

  var _indice = 0;

  var perguntaref;
  var _aplicadorpergunta;

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
                      setState(() {
                        if (_indice + 1 >= _listaPergunta.length) {
                          _indice = 0;
                        } else {
                          _indice = _indice + 1;
                        }
                      });
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
          padding: EdgeInsets.only(top: 2),
          child: Text(
            "Eixo - $_eixo",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 2),
          child: Text(
            "Setor - $_setor",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 2),
          child: Text(
            "Questionario - $_questionario",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 2, bottom: 5),
          child: Text(
            "Local - $_local",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        )
      ],
    );
  }

  Widget _body() {
    perguntaref = _listaPergunta[_indice]['tipo'];
    _aplicadorpergunta = mapaTipoPergunta.getWigetPergunta(tipo: perguntaref, entrada: _listaPergunta[_indice]['parametros']);
    
    return ListView(
      children: <Widget>[
        _listaDadosSuperior(),
        Divider(height: 50, indent: 5, color: Colors.black54),
        Padding(
            padding: EdgeInsets.all(5),
            child: ListTile(
                title: Text(_listaPergunta[_indice]['titulo']),
                subtitle: Text(_listaPergunta[_indice]['texto']))),
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
