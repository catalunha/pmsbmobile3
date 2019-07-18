import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pmsbmibile3/pages/pergunta/editar_apagar_pergunta_page_bloc.dart';
import 'package:pmsbmibile3/widgets/selecting_text_editing_controller.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:provider/provider.dart';
import 'package:pmsbmibile3/components/eixo.dart';
import 'package:pmsbmibile3/models/pergunta_tipo_model.dart';

import '../user_files.dart';

_texto(String texto) {
  return Padding(
    padding: EdgeInsets.all(5.0),
    child: Text(
      texto,
      style: TextStyle(fontSize: 15, color: Colors.blue),
    ),
  );
}

class EditarApagarPerguntaPage extends StatefulWidget {
  @override
  _EditarApagarPerguntaPageState createState() =>
      _EditarApagarPerguntaPageState();
}

class _EditarApagarPerguntaPageState extends State<EditarApagarPerguntaPage> {
  final bloc = EditarApagarPerguntaBloc(Bootstrap.instance.firestore);
  String _questionario = "Setor exemplo";

  var myController = new SelectingTextEditingController();
  String _textoMarkdown = "  ";
  bool showFab;


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  Widget _preambulo() {
    return Column(
      children: <Widget>[
        Center(child: EixoAtualUsuario()),
        _textoTopo("Questionario - $_questionario"),
        _textoTopo("Pergunta - pergunta"),
      ],
    );
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
    return StreamBuilder<EditarApagarPerguntaBlocState>(
        stream: bloc.state,
        builder: (context, snapshot) {
          if (myController.text == null) {
            myController.text = snapshot.data?.instance?.textoMarkdown;
          }
          return Padding(
              padding: EdgeInsets.all(5.0),
              child: TextField(
                onChanged: (text) {
                  _textoMarkdown = text;
                  print(myController.selection);
                  bloc.dispatch(
                      UpdateTextoMarkdownPerguntaEditarApagarPerguntaBlocEvent(
                          text));
                },
                controller: myController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ));
        });
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
              _preambulo(),
              Padding(padding: EdgeInsets.all(10)),
              _texto("Tipo da pergunta:"),
              PerguntaTipoInput(),
              _texto("Titulo da pergunta:"),
              TituloInputField(bloc),
              _texto("Texto da pergunta:"),
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

  _bodyDados() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(padding: EdgeInsets.all(10)),
          _preambulo(),
          Padding(padding: EdgeInsets.all(10)),
          Card(
              child: ListTile(
            title: Text('Selecione perguntas ou escolha requisito:'),
            trailing: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  // SELECIONAR ESCOLHA OU PERGUNTA QUESITO
                  Navigator.pushNamed(
                      context, "/pergunta/selecionar_requisito");
                }),
          )),
          Padding(padding: EdgeInsets.all(10)),
          StreamBuilder<EditarApagarPerguntaBlocState>(
            stream: bloc.state,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Container();
              if (snapshot.data.tipoEnum != PerguntaTipoEnum.EscolhaUnica &&
                  snapshot.data.tipoEnum != PerguntaTipoEnum.EscolhaMultipla) {
                return Container();
              }
              return Card(
                  child: ListTile(
                title: Text('Defina as escolhas:'),
                trailing: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      // SELECIONAR ESCOLHA
                      Navigator.pushNamed(
                          context, "/pergunta/criar_ordenar_escolha");
                    }),
              ));
            },
          ),
          Padding(padding: EdgeInsets.all(10)),
          _botaoDeletarPergunta()
        ]);
  }

  _bodyPreview() {
    return StreamBuilder<EditarApagarPerguntaBlocState>(
        stream: bloc.state,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("ERROR");
          }
          if (!snapshot.hasData) {
            return Text("SEM DADOS");
          }
          return Markdown(data: snapshot.data.textoMarkdown);
        });
  }

  @override
  Widget build(BuildContext context) {
    myController.setTextAndPosition(_textoMarkdown);

    showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;

    final map = Map<String, String>();
    final id = ModalRoute.of(context).settings.arguments;

    bloc.dispatch(UpdateQuestionarioEditarApagarPerguntaBlocEvent(id));

    bloc.dispatch(UpdateIDEditarApagarPerguntaBlocEvent(id));

    return Provider<EditarApagarPerguntaBloc>.value(
      value: bloc,
      child: DefaultTabController(
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
                Tab(text: "Dados"),
                Tab(text: "Preview"),
              ],
            ),
            title: Text("Editar apagar pergunta"),
          ),
          body: TabBarView(
            children: [_bodyTexto(context), _bodyDados(), _bodyPreview()],
          ),
          floatingActionButton: StreamBuilder<EditarApagarPerguntaBlocState>(
            stream: bloc.state,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text("SEM DADOS");
              }
              return FloatingActionButton(
                onPressed: !snapshot.data.isValid
                    ? null
                    : () {
                        bloc.dispatch(SaveEditarApagarPerguntaBlocEvent());
                        Navigator.of(context).pop();
                      },
                child: Icon(Icons.thumb_up),
                backgroundColor:
                    !snapshot.data.isValid ? Colors.grey : Colors.blue,
              );
            },
          ),
        ),
      ),
    );
  }
}

class PerguntaTipoInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<EditarApagarPerguntaBloc>(context);

    return StreamBuilder<EditarApagarPerguntaBlocState>(
        stream: bloc.state,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("ERROR");
          }
          if (!snapshot.hasData) {
            return _texto("SEM DADOS");
          }
          return Container(
            child: Column(
              children: <Widget>[
                if (!snapshot.data.isBaund)
                  Wrap(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.list, color: Colors.black),
                        onPressed: () {
                          // pergunta do tipo texto
                          bloc.dispatch(
                              UpdateTipoPerguntaEditarApagarPerguntaBlocEvent(
                                  PerguntaTipoEnum.Texto));
                        },
                      ),
                      IconButton(
                        icon:
                            Icon(Icons.insert_drive_file, color: Colors.black),
                        onPressed: () {
                          // pergunta do tipo arquivo
                          bloc.dispatch(
                              UpdateTipoPerguntaEditarApagarPerguntaBlocEvent(
                                  PerguntaTipoEnum.Arquivo));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.image, color: Colors.black),
                        onPressed: () {
                          // pergunta do tipo imagem
                          bloc.dispatch(
                              UpdateTipoPerguntaEditarApagarPerguntaBlocEvent(
                                  PerguntaTipoEnum.Imagem));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.plus_one, color: Colors.black),
                        onPressed: () {
                          // pergunta do tipo numero
                          bloc.dispatch(
                              UpdateTipoPerguntaEditarApagarPerguntaBlocEvent(
                                  PerguntaTipoEnum.Numero));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.room),
                        color: Colors.black,
                        onPressed: () {
                          // pergunta do tipo coordenada
                          bloc.dispatch(
                              UpdateTipoPerguntaEditarApagarPerguntaBlocEvent(
                                  PerguntaTipoEnum.Coordenada));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.looks_one, color: Colors.black),
                        onPressed: () {
                          // pergunta do tipo escolha única"
                          bloc.dispatch(
                              UpdateTipoPerguntaEditarApagarPerguntaBlocEvent(
                                  PerguntaTipoEnum.EscolhaUnica));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.queue, color: Colors.black),
                        onPressed: () {
                          // pergunta do tipo escolha multipla
                          bloc.dispatch(
                              UpdateTipoPerguntaEditarApagarPerguntaBlocEvent(
                                  PerguntaTipoEnum.EscolhaMultipla));
                        },
                      ),
                    ],
                  ),
                _texto(snapshot.data.tipo.nome),
              ],
            ),
          );
        });
  }
}

class TituloInputField extends StatefulWidget {
  final EditarApagarPerguntaBloc bloc;

  TituloInputField(this.bloc);

  @override
  State<StatefulWidget> createState() {
    return TituloInputFieldState();
  }
}

class TituloInputFieldState extends State<TituloInputField> {
  final _controller = TextEditingController();
  bool initialValue = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: StreamBuilder<EditarApagarPerguntaBlocState>(
        stream: widget.bloc.state,
        builder: (context, snapshot) {
          if (initialValue &&
              snapshot.hasData &&
              snapshot.data.titulo != null) {
            initialValue = false;
            _controller.text = snapshot.data?.titulo;
          }
          return TextField(
            controller: _controller,
            onChanged: (text) {
              widget.bloc.dispatch(
                  UpdateTituloPerguntaEditarApagarPerguntaBlocEvent(text));
            },
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          );
        },
      ),
    );
  }
}
