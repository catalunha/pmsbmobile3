import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';

class QuestionarioHomePage extends StatelessWidget {
  List<String> _questionarios = [
    "RS 01 - questionarios 001",
    "RS 01 - questionarios 002",
    "RS 01 - questionarios 003",
    "RS 01 - questionarios 004",
    "RS 01 - questionarios 005",
    "RS 01 - questionarios 006",
    "RS 01 - questionarios 007",
    "RS 01 - questionarios 008"
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
                      return Card(
                          elevation: 10,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                title: Text(_questionarios[index]),
                              ),
                              ButtonTheme.bar(
                                child: ButtonBar(
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.list),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        // Editar questionario da lista
                                        Navigator.pushNamed(context,
                                            '/questionario/adicionar_editar');
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ));
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
    return Container(
        child: Center(
            child: Text("Em construção", style: TextStyle(fontSize: 18))));
  }

  _bodyTodos(context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 15, bottom: 15),
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
              Navigator.pushNamed(context, '/questionario/adicionar_editar');
            },
          ),
        ));
  }
}
