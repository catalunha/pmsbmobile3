import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';

class AplicacaoHomePage extends StatefulWidget {
  @override
  _AplicacaoHomePageState createState() => _AplicacaoHomePageState();
}

class _AplicacaoHomePageState extends State<AplicacaoHomePage> {
  List<String> _questionarioaplicado = [
    "Questionário 01",
    "Questionário 02",
    "Questionário 03",
    "Questionário 04"
  ];

  String _eixo = "eixo exemplo";
  String _setor = "setor exemplo";

  _cardText(String text) {
    return Padding(
        padding: EdgeInsets.only(top: 10, left: 5),
        child: Text(
          text,
          style: TextStyle(fontSize: 15),
        ));
  }

  _cardQuestionarioAplicado(index) {
    return Card(
        elevation: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _cardText("Questionario: ${_questionarioaplicado[index]}"),
            _cardText("Local: #local_exemplo"),
            _cardText("Requisitos: #questionario01 => #local"),
            ButtonTheme.bar(
              child: ButtonBar(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.record_voice_over),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, "/aplicacao/aplicando_pergunta");
                      //Navigator.pushNamed(context,'/aplicacao/definir_requisitos');
                      //'/aplicacao/pendencias'
                      //'/aplicacao/visualizar_respostas'
                      //'/aplicacao/definir_requisitos'
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.person_add),
                    onPressed: () {
                      Navigator.pushNamed(context, "/aplicacao/pendencias");
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Abrir questionário
                      Navigator.pushNamed(
                          context, "/aplicacao/momento_aplicacao");
                    },
                  ),
                ],
              ),
            )
          ],
        ));
  }

  _listaQuestionarioAplicado() {
    return Builder(
        builder: (BuildContext context) => new Container(
              child: _questionarioaplicado.length >= 0
                  ? new ListView.separated(
                      itemCount: _questionarioaplicado.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _cardQuestionarioAplicado(index);
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
            "Setor censitário: $_setor",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        Expanded(child: _listaQuestionarioAplicado())
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
      child: DefaultScaffold(
        backgroundColor: Colors.red,
        bottom: TabBar(
          tabs: [
            Tab(text: "Todos"),
            Tab(text: "Arvore"),
          ],
        ),
        title: Text('Aplicando questionario'),
        body: TabBarView(
          children: [
            _bodyTodos(),
            _bodyArvore(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            // Adicionar novo questionario aplicado
            Navigator.pushNamed(context, "/aplicacao/momento_aplicacao");
          },
        ),
      ),
    );
  }
}
