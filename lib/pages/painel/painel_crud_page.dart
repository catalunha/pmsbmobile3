import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/produto_funasa_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:pmsbmibile3/pages/painel/painel_crud_bloc.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';

class PainelCrudPage extends StatefulWidget {
  final String painelId;
  final AuthBloc authBloc;

  const PainelCrudPage(
    this.authBloc,
    this.painelId,
  );

  _PainelCrudPageState createState() => _PainelCrudPageState(this.authBloc);
}

class _PainelCrudPageState extends State<PainelCrudPage> {
  PainelCrudBloc bloc;
  _PainelCrudPageState(AuthBloc authBloc)
      : bloc = PainelCrudBloc(Bootstrap.instance.firestore, authBloc);
  @override
  void initState() {
    super.initState();
    bloc.eventSink(GetPainelEvent(painelId: widget.painelId));
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Editar item do painel'),
        ),
        floatingActionButton: StreamBuilder<PainelCrudBlocState>(
            stream: bloc.stateStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Container();
              return FloatingActionButton(
                onPressed: snapshot.data.isDataValid
                    ? () {
                        //salvar e voltar
                        bloc.eventSink(SaveEvent());
                        Navigator.pop(context);
                      }
                    : null,
                child: Icon(Icons.cloud_upload),
                backgroundColor:
                    snapshot.data.isDataValid ? Colors.blue : Colors.grey,
              );
            }),
        body: StreamBuilder<PainelCrudBlocState>(
            stream: bloc.stateStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              if (snapshot.hasData) {
                // if (snapshot.data.isDataValid) {
                return ListView(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Nome do item',
                          style: TextStyle(fontSize: 15, color: Colors.blue),
                        )),
                    Padding(
                        padding: EdgeInsets.all(5.0), child: PainelNome(bloc)),
                    Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          "Tipo do item:",
                          style: TextStyle(fontSize: 15, color: Colors.blue),
                        )),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: PainelTipo(bloc),
                    ),
                    Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          "Escolha quem responderá este item:",
                          style: TextStyle(fontSize: 15, color: Colors.blue),
                        )),
                    _destinatarios(context),
                    Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          "Escolha a que produto esta associado este item:",
                          style: TextStyle(fontSize: 15, color: Colors.blue),
                        )),
                    _produto(context),
                    Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          "Escolha o eixo a que esta ligado este item:",
                          style: TextStyle(fontSize: 15, color: Colors.blue),
                        )),
                    _eixo(context),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: _DeleteDocumentOrField(bloc),
                    ),
                    Padding(padding: EdgeInsets.only(top: 100)),
                  ],
                );
                // } else {
                //   return Text('Dados inválidos...');
                // }
              }
            }));
  }

  _destinatarios(context) {
    return StreamBuilder<PainelCrudBlocState>(
        stream: bloc.stateStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('Sem produtos');
          }
          Widget texto;
          if (snapshot.data.usuarioID == null) {
            texto = Text('Destinatário não selecionado');
          } else {
            texto = Text('${snapshot.data?.usuarioQVaiResponder?.nome}');
          }
          return ListTile(
            title: texto,
            leading: IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext bc) {
                      return UsuarioListaModalSelect(bloc);
                    });
              },
            ),
          );
        });
  }

  _produto(context) {
    return StreamBuilder<PainelCrudBlocState>(
        stream: bloc.stateStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('Sem produtos');
          }
          Widget texto;
          if (snapshot.data.produtoFunasa == null) {
            texto = Text('Produto não selecionado');
          } else {
            texto = Text(
                '${snapshot.data?.produtoFunasa?.nome}');
          }
          return ListTile(
            title: texto,
            leading: IconButton(
              icon: Icon(Icons.format_line_spacing),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext bc) {
                      return ProdutoFunasaListaModalSelect(bloc);
                    });
              },
            ),
          );
        });
  }

  _eixo(context) {
    return StreamBuilder<PainelCrudBlocState>(
        stream: bloc.stateStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('Sem produtos');
          }
          Widget texto;
          if (snapshot.data.eixo == null) {
            texto = Text('Eixo não selecionado');
          } else {
            texto = Text('${snapshot.data?.eixo?.nome}');
          }
          return ListTile(
            title: texto,
            leading: IconButton(
              icon: Icon(Icons.card_travel),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext bc) {
                      return EixoListaModalSelect(bloc);
                    });
              },
            ),
          );
        });
  }

}

class PainelNome extends StatefulWidget {
  final PainelCrudBloc bloc;
  PainelNome(this.bloc);
  @override
  PainelNomeState createState() {
    return PainelNomeState(bloc);
  }
}

class PainelNomeState extends State<PainelNome> {
  final _textFieldController = TextEditingController();
  final PainelCrudBloc bloc;
  PainelNomeState(this.bloc);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PainelCrudBlocState>(
      stream: bloc.stateStream,
      builder:
          (BuildContext context, AsyncSnapshot<PainelCrudBlocState> snapshot) {
        if (_textFieldController.text.isEmpty) {
          _textFieldController.text = snapshot.data?.nome;
        }
        return TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          controller: _textFieldController,
          onChanged: (text) {
            bloc.eventSink(UpdateNomeEvent(text));
          },
        );
      },
    );
  }
}

class PainelTipo extends StatefulWidget {
  final PainelCrudBloc bloc;
  PainelTipo(this.bloc);
  @override
  PainelTipoState createState() {
    return PainelTipoState(bloc);
  }
}

class PainelTipoState extends State<PainelTipo> {
  final PainelCrudBloc bloc;
  PainelTipoState(this.bloc);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PainelCrudBlocState>(
      stream: bloc.stateStream,
      builder:
          (BuildContext context, AsyncSnapshot<PainelCrudBlocState> snapshot) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Radio(
                      value: 'texto',
                      groupValue: snapshot.data?.tipo,
                      onChanged: (radioValue) {
                        bloc.eventSink(UpdateTipoEvent(radioValue));
                      },
                    ),
                    Icon(Icons.text_fields),
                  ]),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Radio(
                      value: 'numero',
                      groupValue: snapshot.data?.tipo,
                      onChanged: (radioValue) {
                        bloc.eventSink(UpdateTipoEvent(radioValue));
                      },
                    ),
                    Icon(Icons.looks_one),
                  ]),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Radio(
                      value: 'urlimagem',
                      groupValue: snapshot.data?.tipo,
                      onChanged: (radioValue) {
                        bloc.eventSink(UpdateTipoEvent(radioValue));
                      },
                    ),
                    Icon(
                      Icons.image,
                    )
                  ]),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Radio(
                      value: 'urlarquivo',
                      groupValue: snapshot.data?.tipo,
                      onChanged: (radioValue) {
                        bloc.eventSink(UpdateTipoEvent(radioValue));
                      },
                    ),
                    Icon(
                      Icons.attach_file,
                    )
                  ]),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Radio(
                      value: 'booleano',
                      groupValue: snapshot.data?.tipo,
                      onChanged: (radioValue) {
                        bloc.eventSink(UpdateTipoEvent(radioValue));
                      },
                    ),
                    Icon(
                      Icons.thumbs_up_down,
                    )
                  ])
            ]);

        // Column(
        // return Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: <Widget>[
        //       RadioListTile(
        //         title: Text(
        //           'Um texto simples',
        //         ),
        //         value: 'texto',
        //         groupValue: snapshot.data?.tipo,
        //         onChanged: (radioValue) {
        //           bloc.eventSink(UpdateTipoEvent(radioValue));
        //         },
        //       ),
        //       RadioListTile(
        //         title: Text(
        //           'Um número',
        //         ),
        //         value: 'numero',
        //         groupValue: snapshot.data?.tipo,
        //         onChanged: (radioValue) {
        //           bloc.eventSink(UpdateTipoEvent(radioValue));
        //         },
        //       ),
        //       RadioListTile(
        //         title: Text(
        //           'Um link para uma imagem',
        //         ),
        //         value: 'urlimagem',
        //         groupValue: snapshot.data?.tipo,
        //         onChanged: (radioValue) {
        //           bloc.eventSink(UpdateTipoEvent(radioValue));
        //         },
        //       ),
        //       RadioListTile(
        //         title: Text(
        //           'Um link para um arquivo',
        //         ),
        //         value: 'urlarquivo',
        //         groupValue: snapshot.data?.tipo,
        //         onChanged: (radioValue) {
        //           bloc.eventSink(UpdateTipoEvent(radioValue));
        //         },
        //       ),
        //       RadioListTile(
        //         title: Text(
        //           'Marcar Sim ou Não',
        //         ),
        //         value: 'booleano',
        //         groupValue: snapshot.data?.tipo,
        //         onChanged: (radioValue) {
        //           bloc.eventSink(UpdateTipoEvent(radioValue));
        //         },
        //       ),
        //     ]);
      },
    );
  }
}

/// Selecao de usuario que vao receber alerta
class UsuarioListaModalSelect extends StatefulWidget {
  final PainelCrudBloc bloc;

  const UsuarioListaModalSelect(this.bloc);

  @override
  _UsuarioListaModalSelectState createState() =>
      _UsuarioListaModalSelectState(this.bloc);
}

class _UsuarioListaModalSelectState extends State<UsuarioListaModalSelect> {
  final PainelCrudBloc bloc;

  _UsuarioListaModalSelectState(this.bloc);

  Widget _listaUsuarios() {
    return StreamBuilder<PainelCrudBlocState>(
      stream: bloc.stateStream,
      builder:
          (BuildContext context, AsyncSnapshot<PainelCrudBlocState> snapshot) {
        if (snapshot.hasError)
          return Center(
            child: Text("Erro. Informe ao administrador do aplicativo"),
          );
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data.usuarioList == null) {
          return Center(
            child: Text("Nenhum usuario neste chat."),
          );
        }
        if (snapshot.data.usuarioList.isEmpty) {
          return Center(
            child: Text("Vazio."),
          );
        }

        // var usuario = Map<String, UsuarioModel>();

        // usuario = snapshot.data?.usuarioList;
        var lista = List<Widget>();
        for (var usuario in snapshot.data.usuarioList) {
          // print('usuario: ${item.key}');
          lista.add(_cardBuild(context, usuario));
        }

        return ListView(
          children: lista,
        );
      },
    );
  }

  Widget _cardBuild(BuildContext context, UsuarioModel usuario) {
    return ListTile(
      title: Text('${usuario.nome}'),
      subtitle: Text('Eixo: ${usuario.eixoID?.nome}'),
      leading: IconButton(
        icon: Icon(Icons.check),
        onPressed: () {
          bloc.eventSink(SelectDestinatarioIDEvent(usuario));
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Escolha um destinatário"),
      ),
      body: _listaUsuarios(),
    );
  }
}

/// Selecao de eixo
class EixoListaModalSelect extends StatefulWidget {
  final PainelCrudBloc bloc;

  const EixoListaModalSelect(this.bloc);

  @override
  _EixoListaModalSelectState createState() =>
      _EixoListaModalSelectState(this.bloc);
}

class _EixoListaModalSelectState extends State<EixoListaModalSelect> {
  final PainelCrudBloc bloc;

  _EixoListaModalSelectState(this.bloc);

  Widget _listaEixos() {
    return StreamBuilder<PainelCrudBlocState>(
      stream: bloc.stateStream,
      builder:
          (BuildContext context, AsyncSnapshot<PainelCrudBlocState> snapshot) {
        if (snapshot.hasError)
          return Center(
            child: Text("Erro. Informe ao administrador do aplicativo"),
          );
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data.eixoList == null) {
          return Center(
            child: Text("Nenhum usuario neste chat."),
          );
        }
        if (snapshot.data.eixoList.isEmpty) {
          return Center(
            child: Text("Vazio."),
          );
        }

        // var usuario = Map<String, UsuarioModel>();

        // usuario = snapshot.data?.usuarioList;
        var lista = List<Widget>();
        for (var eixo in snapshot.data.eixoList) {
          // print('usuario: ${item.key}');
          lista.add(_cardBuild(context, eixo));
        }

        return ListView(
          children: lista,
        );
      },
    );
  }

  Widget _cardBuild(BuildContext context, EixoID eixo) {
    return ListTile(
      title: Text('${eixo.nome}'),
      // subtitle: Text('Eixo: ${usuario.eixoID?.nome}'),
      leading: IconButton(
        icon: Icon(Icons.check),
        onPressed: () {
          bloc.eventSink(SelectEixoIDEvent(eixo));
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Escolha um eixo"),
      ),
      body: _listaEixos(),
    );
  }
}

/// Selecao de produto
class ProdutoFunasaListaModalSelect extends StatefulWidget {
  final PainelCrudBloc bloc;

  const ProdutoFunasaListaModalSelect(this.bloc);

  @override
  _ProdutoFunasaListaModalSelectState createState() =>
      _ProdutoFunasaListaModalSelectState(this.bloc);
}

class _ProdutoFunasaListaModalSelectState
    extends State<ProdutoFunasaListaModalSelect> {
  final PainelCrudBloc bloc;

  _ProdutoFunasaListaModalSelectState(this.bloc);

  Widget _listaProdutos() {
    return StreamBuilder<PainelCrudBlocState>(
      stream: bloc.stateStream,
      builder:
          (BuildContext context, AsyncSnapshot<PainelCrudBlocState> snapshot) {
        if (snapshot.hasError)
          return Center(
            child: Text("Erro. Informe ao administrador do aplicativo"),
          );
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data.produtoFunasaList == null) {
          return Center(
            child: Text("Nenhum usuario neste chat."),
          );
        }
        if (snapshot.data.produtoFunasaList.isEmpty) {
          return Center(
            child: Text("Vazio."),
          );
        }

        // var usuario = Map<String, UsuarioModel>();

        // usuario = snapshot.data?.usuarioList;
        var lista = List<Widget>();
        for (var produto in snapshot.data.produtoFunasaList) {
          // print('usuario: ${item.key}');
          lista.add(_cardBuild(context, produto));
        }

        return ListView(
          children: lista,
        );
      },
    );
  }

  Widget _cardBuild(BuildContext context, ProdutoFunasaModel produto) {
    return ListTile(
      title: Text('${produto.id}. ${produto.descricao}'),
      subtitle: Text('${produto.nome}'),
      leading: IconButton(
        icon: Icon(Icons.check),
        onPressed: () {
          bloc.eventSink(SelectProdutoFunasaIDEvent(produto));
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Escolha um produto"),
      ),
      body: _listaProdutos(),
    );
  }
}

class _DeleteDocumentOrField extends StatefulWidget {
  final PainelCrudBloc bloc;
  _DeleteDocumentOrField(this.bloc);
  @override
  _DeleteDocumentOrFieldState createState() {
    return _DeleteDocumentOrFieldState(bloc);
  }
}

class _DeleteDocumentOrFieldState extends State<_DeleteDocumentOrField> {
  final _textFieldController = TextEditingController();
  final PainelCrudBloc bloc;
  _DeleteDocumentOrFieldState(this.bloc);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PainelCrudBlocState>(
      stream: bloc.stateStream,
      builder:
          (BuildContext context, AsyncSnapshot<PainelCrudBlocState> snapshot) {
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
                if (_textFieldController.text == 'CONCORDO') {
                  bloc.eventSink(DeleteDocumentEvent());
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
