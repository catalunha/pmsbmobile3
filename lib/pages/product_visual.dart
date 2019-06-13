import 'package:flutter/material.dart';
import 'package:pmsbmibile3/pages/user_files.dart';
import 'package:pmsbmibile3/widgets/selecting_text_editing_controller.dart';

import 'add_edit_product.dart';

class ProductVisual extends StatefulWidget {
  @override
  _ProductVisualState createState() => _ProductVisualState();
}

class _ProductVisualState extends State<ProductVisual> {
  String _eixo = "eixo exemplo";
  String _setor = "Setor exemplo";
  String _produto = "produto exemplo";

  var myController = new SelectingTextEditingController();
  String _textoMarkdown = "  ";
  bool showFab;

  List<String> _visuais = [
    "Produto 001",
    "Produto 002",
    "Produto 003",
    "Produto 004"
  ];

  _tituloProduto() {
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

  _texto(String texto) {
    return Padding(
        padding: EdgeInsets.all(5.0),
        child: Text(
          texto,
          style: TextStyle(fontSize: 15, color: Colors.blue),
        ));
  }

  _textoTopo(text) {
    return Center(
      child: Text(
        "$text",
        style: TextStyle(fontSize: 16, color: Colors.blue),
      ),
    );
  }

  _listaVisuais() {
    return Builder(
        builder: (BuildContext context) => new Container(
              child: _visuais.length >= 0
                  ? new ListView.builder(
                      itemCount: _visuais.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            elevation: 10,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  title: Text(_visuais[index]),
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
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return ProductVisual();
                                          }));
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.edit), 
                                        onPressed: () {
                                          //Ir a pagina de Adicionar ou editar Produtos
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
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

  _bodyTexto(context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        new Expanded(
          child: ListView(
            padding: EdgeInsets.all(5),
            children: <Widget>[
              _textoTopo("Eixo : $_eixo"),
              _textoTopo("Setor - $_setor"),
              _textoTopo("Produto - $_produto"),
            ],
          ),
        ),
        _listaVisuais()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Visuais do produto"),
        ),
        body: _bodyTexto(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // ADICIONAR NOVO VISUAL
          },
          child: Icon(Icons.thumb_up),
          backgroundColor: Colors.blue,
        ));
  }
}
