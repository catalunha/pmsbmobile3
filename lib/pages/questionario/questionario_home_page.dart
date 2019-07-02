import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';

class QuestionarioHomePage extends StatelessWidget {
  List<String> _questionarios = [
    "questionarios 001",
    "questionarios 002",
    "questionarios 003",
    "questionarios 004",
    "questionarios 005",
    "questionarios 006",
    "questionarios 007",
    "questionarios 008"
  ];

  String _eixo = "#eixo_exemplo";

  // widget de listagem

  _listaQuestionarios() {
    return Builder(
      builder: (BuildContext context) => new Container(
            child: _questionarios.length >= 0
                ? new ListView.separated(
                    itemCount: _questionarios.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(_questionarios[index]),
                        trailing: IconButton(
                          icon: Icon(Icons.remove_red_eye),
                          onPressed: () {
                            //abrir pagina de lista de produtos
                            Navigator.pushNamed(context, '/produto/lista');
                          },
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        new Divider(),
                  )
                : new Container(),
          ),
    );
  }

  // estrutura de body's

  _bodyPastas(context) {
    return Container(child: Center(child: Text("Em construção",style: TextStyle(fontSize: 18))));
  }

  _bodyTodos(context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "Eixo - $_eixo",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        Expanded(child: _listaQuestionarios())
      ],
    );
  }

  _body(context) {
    return TabBarView(
      children: [
        _bodyTodos(context),
        _bodyPastas(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: DefaultScaffold(
          bottom: TabBar(
            tabs: [
              Tab(text: "Todos"),
              Tab(text: "Pastas"),
            ],
          ),
          title: Text('Questionarios'),
          body: _body(context),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              // Adicionar novo questionario a lista
            },
          ),
        ));
  }
}
