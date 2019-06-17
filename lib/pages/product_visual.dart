import 'package:flutter/material.dart';
import 'package:pmsbmibile3/pages/edit_visual.dart';
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

  var tabindex;

  var myController = new SelectingTextEditingController();
  String _textoMarkdown = "  ";
  bool showFab;

  List<Map<String, dynamic>> _visuais = [
    {'nome': 'imagem-01', 'tipo': 'imagem'},
    {'nome': 'imagem-02', 'tipo': 'imagem'},
    {'nome': 'grafico-01', 'tipo': 'grafico'},
    {'nome': 'grafico-02', 'tipo': 'grafico'},
    {'nome': 'tabela-01', 'tipo': 'tabela'},
    {'nome': 'tabela-02', 'tipo': 'tabela'},
    {'nome': 'mapa-01', 'tipo': 'mapa'},
    {'nome': 'mapa-02', 'tipo': 'mapa'},
    {'nome': 'imagem-03', 'tipo': 'imagem'},
  ];

  _imagem(String link) {
    return Image.network(
      link,
      //width: 300,
      //height: 400,
      //fit: BoxFit.scaleDown,
    );
  }

  SizedBox _imagemRow(linkracunho, linkeditado) {
    return SizedBox(
      height: 80,
      child: PageView(
        children: <Widget>[
          _imagem(linkracunho),
          _imagem(linkeditado),
        ],
      ),
    );
  }

  _textoTopo(text) {
    return Center(
      child: Text(
        "$text",
        style: TextStyle(fontSize: 16, color: Colors.blue),
      ),
    );
  }

  _listaVisuais(String tipo) {
    print(tipo);
    return Builder(
        builder: (BuildContext context) => new Container(
              child: _visuais.length >= 0
                  ? new ListView.builder(
                      itemCount: _visuais.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _visuais[index]['tipo'] == tipo
                            ? Card(
                                elevation: 10,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      title: Text(_visuais[index]['nome']),
                                    ),
                                    _imagemRow(
                                        'http://man.hubwiz.com/docset/Ionic.docset/Contents/Resources/Documents/ionicframework.com/img/docs/symbols/docs-components-symbol%402x.png',
                                        'http://man.hubwiz.com/docset/Ionic.docset/Contents/Resources/Documents/ionicframework.com/img/docs/symbols/docs-ionicons-symbol%402x.png'),
                                    ButtonTheme.bar(
                                      child: ButtonBar(
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(Icons.assignment),
                                            onPressed: () {
                                              // O ultimo a editar automaticamente o app
                                              // atualiza seu icone, equipe do
                                              // diagramador ou equipe do projeto.
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.check),
                                            onPressed: () {
                                              // Indica que a img a ser incorporada é a diagramada
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {
                                              //IR PRA PAGINA DE EDITAR VISUAL
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return EditVisual();
                                              }));
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ))
                            : Container();
                      })
                  : Container(),
            ));
  }

  _bodyTexto(context, tipo) {
    return Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.all(10)),
        _textoTopo("Eixo : $_eixo"),
        _textoTopo("Setor - $_setor"),
        _textoTopo("Produto - $_produto"),
        Padding(padding: EdgeInsets.all(10)),
        Expanded(child: _listaVisuais(tipo)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
      length: 4,
      child: Scaffold(
          appBar: AppBar(
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            bottom: TabBar(
              tabs: [
                Tab(text: "Imagens"),
                Tab(text: "Graficos"),
                Tab(text: "Tabelas"),
                Tab(text: "Mapas")
              ],
            ),
            title: Text('Visuais do produto'),
          ),
          body: TabBarView(
            children: [
              _bodyTexto(context, 'imagem'),
              _bodyTexto(context, 'tabela'),
              _bodyTexto(context, 'grafico'),
              _bodyTexto(context, 'mapa'),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => {
                  // ADICIONAR NOVO VISUAL DE ACORDO COM A TAB QUE ESTA SELECIONADA - IMAGENS, GRAFICOS ...
                },
            child: Icon(Icons.add),
            backgroundColor: Colors.blue,
          )),
    ));
  }
}
