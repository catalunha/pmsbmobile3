import 'package:flutter/material.dart';
import 'package:pmsbmibile3/components/preambulo.dart';
import 'package:pmsbmibile3/pages/pergunta/editar_apagar_pergunta_page_bloc.dart';
import 'package:pmsbmibile3/widgets/selecting_text_editing_controller.dart';
import 'package:pmsbmibile3/bootstrap.dart';
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
  final String questionarioID;
  final String perguntaID;

  EditarApagarPerguntaPage({this.questionarioID, this.perguntaID});

  @override
  _EditarApagarPerguntaPageState createState() =>
      _EditarApagarPerguntaPageState();
}

class _EditarApagarPerguntaPageState extends State<EditarApagarPerguntaPage> {
  final bloc = EditarApagarPerguntaBloc(Bootstrap.instance.firestore);
  final myController = SelectingTextEditingController();
  bool initialMarkdown = true;

  @override
  void initState() {
    super.initState();
    bloc.dispatch(
        UpdateQuestionarioEditarApagarPerguntaBlocEvent(widget.questionarioID));
    bloc.dispatch(UpdateIDEditarApagarPerguntaBlocEvent(widget.perguntaID));
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }


  Widget _pergunta() {
    return StreamBuilder<EditarApagarPerguntaBlocState>(
      stream: bloc.state,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("ERROR");
        }
        if (!snapshot.hasData) {
          return Text("SEM DADOS");
        }
        if (snapshot.data.instance != null) {
          return _textoTopo("Pergunta: ${snapshot.data.instance.titulo}");
        } else {
          return _textoTopo("Pergunta: criando");
        }
      },
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

  // _botaoDeletarPergunta() {
  //   return SafeArea(
  //       child: Row(
  //     children: <Widget>[
  //       Padding(
  //           padding: EdgeInsets.all(5.0),
  //           child: RaisedButton(
  //               color: Colors.red,
  //               onPressed: () {
  //                 bloc.dispatch(DeletarEditarApagarPerguntaBlocEvent());
  //                 Navigator.pop(context, "pergunta deletada");
  //               },
  //               child: Row(
  //                 children: <Widget>[
  //                   Text('Apagar', style: TextStyle(fontSize: 20)),
  //                   Icon(Icons.delete)
  //                 ],
  //               ))),
  //     ],
  //   ));
  // }

  _textoMarkdownField() {
    return StreamBuilder<EditarApagarPerguntaBlocState>(
        stream: bloc.state,
        builder: (context, snapshot) {
          if (initialMarkdown && snapshot.hasData && snapshot.data.isBaund) {
            initialMarkdown = false;
            myController.text = snapshot.data?.instance?.textoMarkdown;
          }
          return Padding(
              padding: EdgeInsets.all(5.0),
              child: TextField(
                onChanged: (text) {
                  // print(myController.selection);
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
        myController.text.substring(0, myController.selection.baseOffset);
    // print("INICIO:" + inicio);
    String fim = myController.text
        .substring(myController.selection.baseOffset, myController.text.length);
    // print("FIM:" + fim);

    myController.text = "$inicio$texto$fim";
    myController.setTextAndPosition(myController.text,
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
              Preambulo(
                eixo: true,
                setor: true,
                questionarioID: widget.questionarioID,
              ),
              _pergunta(),
              Padding(padding: EdgeInsets.all(10)),
              _texto("Tipo da pergunta:"),
              PerguntaTipoInput(bloc),
              // Card(
              //     child: ListTile(
              //   title: Text('Selecione perguntas ou escolha requisito:'),
              //   trailing: IconButton(
              //       icon: Icon(Icons.search),
              //       onPressed: () {
              //         // SELECIONAR ESCOLHA OU PERGUNTA QUESITO
              //         Navigator.pushNamed(
              //             context, "/pergunta/selecionar_requisito",
              //             arguments: bloc);
              //       }),
              // )),
              Padding(padding: EdgeInsets.all(10)),
              StreamBuilder<EditarApagarPerguntaBlocState>(
                stream: bloc.state,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  if (snapshot.data.tipoEnum != PerguntaTipoEnum.EscolhaUnica &&
                      snapshot.data.tipoEnum !=
                          PerguntaTipoEnum.EscolhaMultipla) {
                    return Container();
                  }
                  return Card(
                      child: ListTile(
                    title: Text('Defina as escolhas:'),
                    trailing: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () async {
                          // SELECIONAR ESCOLHA
                          bloc.dispatch(SaveEditarApagarPerguntaBlocEvent());
                          if (snapshot.data.isValid) {
                            Navigator.pushNamed(
                                context, "/pergunta/escolha_list",
                                arguments: snapshot.data.instance.id);
                          }
                        }),
                  ));
                },
              ),
              _texto("Titulo da pergunta:"),
              TituloInputField(bloc),
              _texto("Texto da pergunta:"),
              _textoMarkdownField(),
              Padding(padding: EdgeInsets.all(10)),
              // _botaoDeletarPergunta(),
              _DeleteDocumentOrField(bloc),
              Container(
              padding: EdgeInsets.only(top: 80),
            ),
            ],
          ),
        ),
        Visibility(
          child: new Container(
            color: Colors.white,
            padding: new EdgeInsets.all(10.0),
            child: _iconesLista(),
          ),
          visible: !(MediaQuery.of(context).viewInsets.bottom == 0.0),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    myController.setTextAndPosition(myController.text);

    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Editar apagar pergunta"),
      ),
      body: _bodyTexto(context),
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
            child: Icon(Icons.cloud_upload),
            backgroundColor: !snapshot.data.isValid ? Colors.grey : Colors.blue,
          );
        },
      ),
    );
  }
}

class PerguntaTipoInput extends StatelessWidget {
  final EditarApagarPerguntaBloc bloc;
  PerguntaTipoInput(this.bloc);

  @override
  Widget build(BuildContext context) {
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

class _DeleteDocumentOrField extends StatefulWidget {
  final EditarApagarPerguntaBloc bloc;

  _DeleteDocumentOrField(this.bloc);
  @override
  _DeleteDocumentOrFieldState createState() {
    return _DeleteDocumentOrFieldState(bloc);
  }
}

class _DeleteDocumentOrFieldState extends State<_DeleteDocumentOrField> {
  final _textFieldController = TextEditingController();
  final EditarApagarPerguntaBloc bloc;
  _DeleteDocumentOrFieldState(this.bloc);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EditarApagarPerguntaBlocState>(
      stream: bloc.state,
      builder: (BuildContext context,
          AsyncSnapshot<EditarApagarPerguntaBlocState> snapshot) {
        return Row(
          children: <Widget>[
            Divider(),
            Text('Para apagar digite CONCORDO e click:  '),
            Container(
              child: Flexible(
                child: TextField(
                  controller: _textFieldController,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                //Ir para a pagina visuais do produto
                if (_textFieldController.text == 'CONCORDO') {
                  bloc.dispatch(DeletarEditarApagarPerguntaBlocEvent());
                  Navigator.of(context).pop();
                }
              },
            )
          ],
        );
      },
    );
  }
}
