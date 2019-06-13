import 'package:flutter/material.dart';
import 'package:pmsbmibile3/pages/add_edit_product.dart';
import 'package:pmsbmibile3/pages/product_visual.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<String> _produtos = [
    "Produto 001",
    "Produto 002",
    "Produto 003",
    "Produto 004"
  ];
  String _eixo = "eixo exemplo";
  String _setor = "setor exemplo";

  _listaProdutos() {
    return Builder(
        builder: (BuildContext context) => new Container(
              child: _produtos.length >= 0
                  ? new ListView.builder(
                      itemCount: _produtos.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            elevation: 10,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  title: Text(_produtos[index]),
                                ),
                                ButtonTheme.bar(
                                  child: ButtonBar(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.print),
                                        onPressed: () {
                                          // Gerar pdf do produto e imprimir
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.attach_file),
                                         onPressed: () {
                                           //Ir para a pagina visuais do produto
                                           Navigator.push(context,
                                               MaterialPageRoute(builder: (context) {
                                                 return ProductVisual();
                                               }));
                                         },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                         onPressed: () {
                                           //Ir a pagina de Adicionar ou editar Produtos
                                           Navigator.push(context,
                                               MaterialPageRoute(builder: (context) {
                                                 return AddEditProduct();
                                               }));
                                         },
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ));
                      })
                  : Container(),
            ));
  }

  Widget _body() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "Eixo - $_eixo",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            "Setor - $_setor",
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
        Expanded(child: _listaProdutos())
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Lista de produtos"),
      ),
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Adicionar um novo produto
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
