import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';

//Resposta 00

class RespostaHomePage extends StatefulWidget {
  @override
  _RespostaHomePageState createState() => _RespostaHomePageState();
}

class _RespostaHomePageState extends State<RespostaHomePage> {
  List<String> _respostasetores = [
    "Setor Censitário 01",
    "Setor Censitário 02",
    "Setor Censitário 03",
    "Setor Censitário 04"
  ];
  String _eixo = "eixo exemplo";

  _listaRespostas() {
    return Builder(
        builder: (BuildContext context) => new Container(
              child: _respostasetores.length >= 0
                  ? new ListView.separated(
                      itemCount: _respostasetores.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(_respostasetores[index]),
                          trailing: IconButton(
                            icon: Icon(Icons.remove_red_eye),
                            onPressed: () {
                              //abrir pagina de lista de questionarios com respostas
                              Navigator.pushNamed(
                                  context, "/resposta/questionario_resposta");
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

  Widget _body(context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "Eixo : $_eixo",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        Expanded(child: _listaRespostas())
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backgroundColor: Colors.red,
      // body: _body(context),
      body: Center(
        child: Text(
          "Em construção.",
          style: Theme.of(context).textTheme.display1,
        ),
      ),
      title: Text("Resposta dos questionários"),
    );
  }
}
