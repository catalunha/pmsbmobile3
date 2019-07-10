import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/pages/produto/product_list.dart';

//PRODUTO 00

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<String> _setores = ["Setor 001", "Setor 002", "Setor 003", "Setor 004"];
  String _eixo = "eixo exemplo";

  _listaSetores() {
    return Builder(
      builder: (BuildContext context) => new Container(
            child: _setores.length >= 0
                ? new ListView.separated(
                    itemCount: _setores.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(_setores[index]),
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
        Expanded(child: _listaSetores())
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backgroundColor: Colors.red,
      body: _body(context),
      title: Text("Produto em edição"),
    );
    /**

     */
  }
}
