import 'package:flutter/material.dart';

class MomentoAplicacaoPage extends StatefulWidget {
  @override
  _MomentoAplicacaoPageState createState() => _MomentoAplicacaoPageState();
}

class _MomentoAplicacaoPageState extends State<MomentoAplicacaoPage> {
  List<String> _requisitos = [
    "#questionario - #local",
    "#questionario - #local",
    "#questionario - #local",
  ];

  String _eixo = "eixo exemplo";
  String _questionario = "questionarios exemplo";
  String _local = "local exemplo";
  String _setor = "setor exemplo";

  _botaoDeletar() {
    return SafeArea(
        child: Row(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(5.0),
            child: RaisedButton(
                color: Colors.red,
                onPressed: () {
                  // Deletar essa aplicacao de questionario
                },
                child: Row(
                  children: <Widget>[
                    Text('Apagar', style: TextStyle(fontSize: 20)),
                    Icon(Icons.delete)
                  ],
                ))),
      ],
    ));
  }

  _referenciaTexto() {
    return Padding(
        padding: EdgeInsets.all(5.0),
        child: TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ));
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
        Card(
            elevation: 10,
            child: ListTile(
              trailing: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    //selecionar o questionario
                  }),
              title: Text("Escolha um questionario: "),
              subtitle:
                  Text("  $_questionario", style: TextStyle(fontSize: 18)),
            )),
        Padding(
            padding: EdgeInsets.all(5),
            child: Text("Referencia: Local/Pessoa/Momento na aplicação:",
                style: TextStyle(color: Colors.blue, fontSize: 15))),
        _referenciaTexto(),
        Card(
            elevation: 10,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    trailing: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          //selecionar requisitos
                        }),
                    title: Text("Lista de requisitos:"),
                  ),
                  for (var requisito in _requisitos)
                    Padding(
                        padding: EdgeInsets.only(left: 10, top: 5),
                        child: Text(requisito, style: TextStyle(fontSize: 15)))
                ])),
        _botaoDeletar()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text("Local/Pessoa/Momento de aplicação"),
      ),
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //salvar e voltar
          Navigator.pop(context);
        },
        child: Icon(Icons.thumb_up),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
