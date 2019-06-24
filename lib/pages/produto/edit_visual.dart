import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pmsbmibile3/pages/user_files.dart';
import 'package:pmsbmibile3/widgets/selecting_text_editing_controller.dart';

class EditVisual extends StatefulWidget {
  @override
  _EditVisualState createState() => _EditVisualState();
}

class _EditVisualState extends State<EditVisual> {
  String _eixo = "eixo exemplo";
  String _setor = "Setor exemplo";
  String _produto = "produto exemplo";

  bool _incorporareditado = true;

  List<Map<String, dynamic>> _observacoes = [
    {
      'mensagem': 'olá teste bla bla \n teste\n - oi\n - oi',
      'usuario': 'usuario-01',
      'data': DateTime(2019)
    },
    {
      'mensagem': 'olá teste bla bla \n teste\n - oi\n - oi',
      'usuario': 'usuario-02',
      'data': DateTime(2019)
    },
    {
      'mensagem': 'olá teste bla bla \n teste\n-oi\n-oi',
      'usuario': 'usuario-01',
      'data': DateTime(2019)
    },
    {
      'mensagem': 'olá teste bla bla \n teste\n-oi\n-oi',
      'usuario': 'usuario-02',
      'data': DateTime(2019)
    },
  ];

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
                  // DELETAR ESTE VISUAL
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
              _texto("Titulo do visual:"),
              _tituloProduto(),
              Row(
                children: <Widget>[
                  _texto("Selecione rascunho para anexar:"),
                  IconButton(
                    icon: Icon(Icons.attach_file),
                    onPressed: () {
                      //SELECIONAR IMAGEM
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return UserFilesFirebaseList();
                      }));
                    },
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  _texto("Selecione editado para anexar:"),
                  IconButton(
                    icon: Icon(Icons.attach_file),
                    onPressed: () {
                      //SELECIONAR IMAGEM
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return UserFilesFirebaseList();
                      }));
                    },
                  )
                ],
              ),
              Row(children: <Widget>[
                _texto("Incorporar editado ?"),
                Switch(
                  value: _incorporareditado,
                  onChanged: (value) {
                    setState(() {
                      // ALTERA SE VAI OU NAO SER INCORPORADO O EDITADO
                      _incorporareditado = value;
                    });
                  },
                ),
              ]),
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

  _bodyObservacao() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(5),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
              ),
              _texto("Texto da observação:"),
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

  _bodyHistorico() {
    return Builder(
        builder: (BuildContext context) => new Container(
              child: _observacoes.length >= 0
                  ? new ListView.builder(
                      itemCount: _observacoes.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 10,
                          child: ListTile(
                            title: Container(
                              height: 100,
                              child: Markdown(
                                  data: _observacoes[index]['mensagem']),
                              color: Colors.white12,
                            ), //Text('${_observacoes[index][]'),
                            subtitle: Text(
                                "${_observacoes[index]['data']} - ${_observacoes[index]['usuario']}"),
                          ),
                        );
                      })
                  : Container(),
            ));
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
                  backgroundColor: Colors.red,
                  leading: new IconButton(
                    icon: new Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  bottom: TabBar(
                    tabs: [
                      Tab(text: "Dados"),
                      Tab(text: "Observações"),
                      Tab(text: "Historico"),
                    ],
                  ),
                  title: Text("Editar visual - Imagem"),
                ),
                body: TabBarView(
                  children: [
                    _bodyDados(context),
                    _bodyObservacao(),
                    _bodyHistorico()
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
