import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pmsbmibile3/widgets/selecting_text_editing_controller.dart';

import '../user_files.dart';

class EditarApagarPerguntaPage extends StatefulWidget {
  @override
  _EditarApagarPerguntaPageState createState() =>
      _EditarApagarPerguntaPageState();
}

class _EditarApagarPerguntaPageState extends State<EditarApagarPerguntaPage> {
  String _eixo = "eixo exemplo";
  String _questionario = "Setor exemplo";
  String _pergunta = "produto exemplo";

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

  _botaoDeletarPergunta() {
    return SafeArea(
        child: Row(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(5.0),
            child: RaisedButton(
                color: Colors.red,
                onPressed: () {
                  // DELETAR ESTA PERGUNTA
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

  _bodyTexto(context) {
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
              _textoTopo("Questionario - $_questionario"),
              _textoTopo("Pergunta - $_pergunta"),
              Padding(padding: EdgeInsets.all(10)),
              _texto("Titulo da pergunta:"),
              _tituloProduto(),
              _texto("Texto da pergunta:"),
              _textoMarkdownField()
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

  _bodyPreview() {
    return Markdown(data: myController.text);
  }

  _bodyDados() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(padding: EdgeInsets.all(10)),
          _textoTopo("Eixo : $_eixo"),
          _textoTopo("Questionario - $_questionario"),
          _textoTopo("Pergunta - $_pergunta"),
          Padding(padding: EdgeInsets.all(10)),
          Card(
              child: ListTile(
            title: Text('Selecione perguntas ou escolha requisito:'),
            trailing: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  // SELECIONAR ESCOLHA OU PERGUNTA QUESITO
                  Navigator.pushNamed(context, "/pergunta/selecionar_requisito");
                }),
          )),
          Padding(padding: EdgeInsets.all(10)),
          Card(
              child: ListTile(
            title: Text('Defina as escolhas:'),
            trailing: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  // SELECIONAR ESCOLHA
                }),
          )),
          Padding(padding: EdgeInsets.all(10)),
          _botaoDeletarPergunta()
        ]);
  }

  @override
  Widget build(BuildContext context) {
    showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    myController.setTextAndPosition(_textoMarkdown);

    return DefaultTabController(
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
                  Tab(text: "Texto"),
                  Tab(text: "Preview"),
                  Tab(text: "Dados"),
                ],
              ),
              title: Text("Editar apagar pergunta"),
            ),
            body: TabBarView(
              children: [_bodyTexto(context), _bodyPreview(), _bodyDados()],
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
                ))));
  }
}
