import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pmsbmibile3/pages/user_files.dart';
import 'package:pmsbmibile3/widgets/selecting_text_editing_controller.dart';

class AddEditProduct extends StatefulWidget {
  @override
  _AddEditProductState createState() => _AddEditProductState();
}

class _AddEditProductState extends State<AddEditProduct> {
  String _eixo = "eixo exemplo";
  String _setor = "Setor exemplo";
  String _produto = "produto exemplo";

  var myController = new SelectingTextEditingController();
  String _textoMarkdown = "  ";
  bool showFab;

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

  _iconesLista() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.format_bold),
          onPressed: () {
            _atualizarMarkdown("****", 2);
          },
        ),
        IconButton(
          icon: Icon(Icons.format_size),
          onPressed: () {
            _atualizarMarkdown("#", 1);
          },
        ),
        IconButton(
          icon: Icon(Icons.format_list_numbered),
          onPressed: () {
            _atualizarMarkdown("- ", 2);
          },
        ),
        IconButton(
          icon: Icon(Icons.link),
          onPressed: () {
            _atualizarMarkdown("[ clique aqui ](  )", 17);
          },
        ),
        IconButton(
            icon: Icon(Icons.image),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return UserFilesFirebaseList();
              }));
            })
      ],
    );
  }

  _botaoDeletarProduto() {
    return SafeArea(
        child: Row(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(5.0),
            child: RaisedButton(
                color: Colors.red,
                onPressed: () {
                  // DELETAR ESTE PRODUTO
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

  _textoMarkdownField() {
    return Padding(
        padding: EdgeInsets.all(5.0),
        child: TextField(
          onChanged: (text) {
            _textoMarkdown = text;
            print(myController.selection);
          },
          controller: myController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ));
  }

  _atualizarMarkdown(texto, posicao) {
    String inicio =
        _textoMarkdown.substring(0, myController.selection.baseOffset);
    print("INICIO:" + inicio);
    String fim = _textoMarkdown.substring(
        myController.selection.baseOffset, _textoMarkdown.length);
    print("FIM:" + fim);

    _textoMarkdown = "$inicio$texto$fim";
    myController.setTextAndPosition(_textoMarkdown,
        caretPosition: myController.selection.baseOffset + posicao);
  }

  _textoTopo(text) {
    return Center(
      child: Text(
        "$text",
        style: TextStyle(fontSize: 16, color: Colors.blue),
      ),
    );
  }

  _bodyDados(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(5),
            children: <Widget>[
              _textoTopo(
                "Eixo : $_eixo",
              ),
              _textoTopo("Setor - $_setor"),
              _textoTopo("Produto - $_produto"),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              _texto("Titulo do produto:"),
              _tituloProduto(),
              _botaoDeletarProduto()
            ],
          ),
        ),
        Visibility(
          child: new Container(
            color: Colors.white,
            padding: new EdgeInsets.all(10.0),
            child: _iconesLista(),
          ),
          visible: !showFab,
        )
      ],
    );
  }

  _bodyTexto() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(5),
            children: <Widget>[
              _textoTopo("Eixo: $_eixo"),
              _textoTopo("Setor: $_setor"),
              _textoTopo("Produto: $_produto"),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              _texto("Texto da notícia:"),
              _textoMarkdownField(),
            ],
          ),
        ),
        Visibility(
          child: new Container(
            color: Colors.white,
            padding: new EdgeInsets.all(10.0),
            child: _iconesLista(),
          ),
          visible: !showFab,
        )
      ],
    );
  }

  _bodyPreview(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(5),
            children: <Widget>[
              _textoTopo("Eixo: $_eixo"),
              _textoTopo("Setor: $_setor"),
              _textoTopo("Produto: $_produto"),
              Padding(
                padding: EdgeInsets.all(10),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            child: Markdown(data: myController.text),
          ),
        ),
        Visibility(
          child: new Container(
            color: Colors.white,
            padding: new EdgeInsets.all(10.0),
            child: _iconesLista(),
          ),
          visible: !showFab,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    myController.setTextAndPosition(_textoMarkdown);

    return MaterialApp(
        home: DefaultTabController(
            length: 3,
            child: Scaffold(
                appBar: AppBar(
                  leading: new IconButton(
                    icon: new Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  bottom: TabBar(
                    tabs: [
                      Tab(text: "Dados"),
                      Tab(text: "Texto"),
                      Tab(text: "Preview"),
                    ],
                  ),
                  title: Text("Adicionar ou editar produto"),
                ),
                body: TabBarView(
                  children: [
                    _bodyDados(context),
                    _bodyTexto(),
                    _bodyPreview(context)
                  ],
                ),
                floatingActionButton: Visibility(
                    visible: showFab,
                    child: FloatingActionButton(
                      onPressed: () {
                        // SALVAR TUDO E VOLTAR A TELA ANTERIOR
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.thumb_up),
                      backgroundColor: Colors.blue,
                    )))));
  }
}
