import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';

//Aplicação 03

class PendenciasPage extends StatefulWidget {
  @override
  _PendenciasPageState createState() => _PendenciasPageState();
}

class _PendenciasPageState extends State<PendenciasPage> {
  List<String> _tipoperguntas = [
    "01 - Pergunta texto",
    "02 - Pergunta imagem",
    "03 - Pergunta numero",
    "04 - Pergunta coordenada",
    "05 - Pergunta escolha unica",
    "06 - Pergunta escolha multipla"
  ];

  String _eixo = "eixo exemplo";
  String _setor = "setor exemplo";
  String _questionario = "questionario exemplo";
  String _local = "local exemplo";

  _listaPerguntas() {
    return Builder(
        builder: (BuildContext context) => new Container(
              child: _tipoperguntas.length >= 0
                  ? new ListView.separated(
                      itemCount: _tipoperguntas.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(_tipoperguntas[index]),
                          trailing: IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () {
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

  _bodyTodos(context) {
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
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "Questionário: $_questionario",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "Local: $_local",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        Expanded(child: _listaPerguntas())
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backgroundColor: Colors.red,
      body: _bodyTodos(context),
      title: Text("Pendências"),
    );
  }
}
