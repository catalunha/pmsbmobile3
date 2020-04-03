import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/components/default_scaffold.dart';
import 'package:pmsbmibile3/models/produto_funasa_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:pmsbmibile3/pages/painel/painel_crud_bloc.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:pmsbmibile3/style/pmsb_colors.dart';
import 'package:pmsbmibile3/style/pmsb_styles.dart';

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
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      backToRootPage: false,
      title: Text('Editar item do painel'),
      floatingActionButton: StreamBuilder<PainelCrudBlocState>(
          stream: bloc.stateStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            return FloatingActionButton(
              onPressed: snapshot.data.isDataValid
                  ? () {
                      bloc.eventSink(SaveEvent());
                      Navigator.pop(context);
                    }
                  : null,
              child: Icon(Icons.check),
              backgroundColor: snapshot.data.isDataValid
                  ? PmsbColors.cor_destaque
                  : Colors.grey,
            );
          }),
      body: StreamBuilder<PainelCrudBlocState>(
        stream: bloc.stateStream,
        builder: (BuildContext context,
            AsyncSnapshot<PainelCrudBlocState> snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          if (snapshot.hasData) {
            return ListView(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      'Nome do item:',
                      style: TextStyle(fontSize: 15, color: Colors.blue),
                    )),
                Padding(padding: EdgeInsets.all(5.0), child: PainelNome(bloc)),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "Tipo do item:",
                    style: TextStyle(fontSize: 15, color: Colors.blue),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: PainelTipo(bloc),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "Escolha quem responderá este item:",
                    style: TextStyle(fontSize: 15, color: Colors.blue),
                  ),
                ),
                _destinatarios(context),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "Escolha a que produto esta associado este item:",
                    style: TextStyle(fontSize: 15, color: Colors.blue),
                  ),
                ),
                _produto(context),
                Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      "Escolha o eixo a que esta ligado este item:",
                      style: TextStyle(fontSize: 15, color: Colors.blue),
                    )),
                _eixo(context),
                Divider(),
                ListTile(
                  title: Text("Apagar"),
                  trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _apagarAplicacao(context, bloc);
                      }),
                ),
                // Padding(
                //   padding: EdgeInsets.all(5.0),
                //   child: _DeleteDocumentOrField(bloc),
                // ),
                Padding(padding: EdgeInsets.only(top: 100)),
              ],
            );
          }
          return Text('Dados incompletos...');
        },
      ),
    );
  }

  _destinatarios(context) {
    return StreamBuilder<PainelCrudBlocState>(
        stream: bloc.stateStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('Sem produtos');
          }
          Widget texto;
          if (snapshot.data.usuarioQVaiResponder == null) {
            texto = Text('Destinatário não selecionado');
          } else {
            texto = Text('${snapshot.data?.usuarioQVaiResponder?.nome}');
          }
          return ListTile(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext bc) {
                    return UsuarioListaModalSelect(bloc);
                  });
            },
            title: texto,
            leading: Icon(Icons.person),
            trailing: Icon(Icons.edit),
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
            texto = Text('${snapshot.data?.produtoFunasa?.nome}');
          }
          return ListTile(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext bc) {
                  return ProdutoFunasaListaModalSelect(bloc);
                },
              );
            },
            title: texto,
            leading: Icon(Icons.format_line_spacing),
            trailing: Icon(Icons.edit),
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
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext bc) {
                  return EixoListaModalSelect(bloc);
                });
          },
          title: texto,
          leading: Icon(Icons.card_travel),
          trailing: Icon(Icons.edit),
        );
      },
    );
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
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            rowTipoItem(
              'Texto',
              Icons.text_fields,
              Radio(
                value: 'texto',
                groupValue: snapshot.data?.tipo,
                onChanged: (radioValue) {
                  bloc.eventSink(UpdateTipoEvent(radioValue));
                },
              ),
            ),
            rowTipoItem(
              'Número',
              Icons.looks_one,
              Radio(
                value: 'numero',
                groupValue: snapshot.data?.tipo,
                onChanged: (radioValue) {
                  bloc.eventSink(UpdateTipoEvent(radioValue));
                },
              ),
            ),
            rowTipoItem(
              'Url imagem',
              Icons.image,
              Radio(
                value: 'urlimagem',
                groupValue: snapshot.data?.tipo,
                onChanged: (radioValue) {
                  bloc.eventSink(UpdateTipoEvent(radioValue));
                },
              ),
            ),
            rowTipoItem(
              "Url arquivo",
              Icons.attach_file,
              Radio(
                value: 'urlarquivo',
                groupValue: snapshot.data?.tipo,
                onChanged: (radioValue) {
                  bloc.eventSink(UpdateTipoEvent(radioValue));
                },
              ),
            ),
            rowTipoItem(
              "Booleano",
              Icons.thumbs_up_down,
              Radio(
                value: 'booleano',
                groupValue: snapshot.data?.tipo,
                onChanged: (radioValue) {
                  bloc.eventSink(UpdateTipoEvent(radioValue));
                },
              ),
            )
          ],
        );
      },
    );
  }

  rowTipoItem(String valor, IconData icon, Radio radio) {
    return Row(
      children: <Widget>[
        // Flexible(
        //   flex: 2,
        //   child: Container(),
        // ),
        Flexible(
          flex: 3,
          child: radio,
        ),
        SizedBox(
          width: 15,
        ),
        Flexible(
          flex: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(valor, style: PmsbStyles.textoPrimario),
              Icon(icon)
            ],
          ),
        ),
        Flexible(
          flex: 2,
          child: Container(),
        ),
      ],
    );
  }
}

// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceAround,
//   children: <Widget>[
//     Radio(
//       value: 'texto',
//       groupValue: snapshot.data?.tipo,
//       onChanged: (radioValue) {
//         bloc.eventSink(UpdateTipoEvent(radioValue));
//       },
//     ),
//     Text(
//       "Texto",
//       style: PmsbStyles.textoPrimario,
//     ),
//     Icon(Icons.text_fields),
//   ],
// ),
// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceAround,
//   children: <Widget>[
//     Radio(
//       value: 'numero',
//       groupValue: snapshot.data?.tipo,
//       onChanged: (radioValue) {
//         bloc.eventSink(UpdateTipoEvent(radioValue));
//       },
//     ),
//     Text(
//       "Número",
//       style: PmsbStyles.textoPrimario,
//     ),
//     Icon(Icons.looks_one),
//   ],
// ),
// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceAround,
//   children: <Widget>[
//     Radio(
//       value: 'urlimagem',
//       groupValue: snapshot.data?.tipo,
//       onChanged: (radioValue) {
//         bloc.eventSink(UpdateTipoEvent(radioValue));
//       },
//     ),
//     Text(
//       "Url imagem",
//       style: PmsbStyles.textoPrimario,
//     ),
//     Icon(
//       Icons.image,
//     )
//   ],
// ),
// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceAround,
//   children: <Widget>[
//     Radio(
//       value: 'urlarquivo',
//       groupValue: snapshot.data?.tipo,
//       onChanged: (radioValue) {
//         bloc.eventSink(UpdateTipoEvent(radioValue));
//       },
//     ),
//     Text(
//       "Url arquivo",
//       style: PmsbStyles.textoPrimario,
//     ),
//     Icon(
//       Icons.attach_file,
//     )
//   ],
// ),
// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceAround,
//   children: <Widget>[
//     Radio(
//       value: 'booleano',
//       groupValue: snapshot.data?.tipo,
//       onChanged: (radioValue) {
//         bloc.eventSink(UpdateTipoEvent(radioValue));
//       },
//     ),
//     Text(
//       "Booleano",
//       style: PmsbStyles.textoPrimario,
//     ),
//     Icon(
//       Icons.thumbs_up_down,
//     ),
//   ],
// )

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

        var lista = List<Widget>();
        for (var usuario in snapshot.data.usuarioList) {
          lista.add(_cardBuild(context, usuario));
        }

        return Container(
          color: PmsbColors.fundo,
          child: ListView(
            children: lista,
          ),
        );
      },
    );
  }

  Widget _cardBuild(BuildContext context, UsuarioModel usuario) {
    return ListTile(
      title: Text('${usuario.nome}'),
      subtitle: Text('Eixo: ${usuario.eixoID?.nome}'),
      trailing: GestureDetector(
        onTap: () {
          bloc.eventSink(SelectDestinatarioIDEvent(usuario));
          Navigator.pop(context);
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              //begin: Alignment.topLeft,
              // end: Alignment.bottomRight,
              colors: <Color>[
                Color(0xFF02AAB0),
                Color(0xFF00CDAC),
                Color(0xFF02AAB0),
              ],
            ),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Container(
            constraints: BoxConstraints(maxWidth: 100.0, minHeight: 50.0),
            alignment: Alignment.center,
            child: Text(
              "Selecionar",
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      // leading: IconButton(
      //   icon: Icon(Icons.check),
      //   onPressed: () {

      //   },
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PmsbColors.navbar,
        bottomOpacity: 0.0,
        elevation: 0.0,
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

        var lista = List<Widget>();
        for (var eixo in snapshot.data.eixoList) {
          lista.add(_cardBuild(context, eixo));
        }

        return Container(
          color: PmsbColors.fundo,
          child: ListView(
            children: lista,
          ),
        );
      },
    );
  }

  Widget _cardBuild(BuildContext context, EixoID eixo) {
    return ListTile(
      title: Text('${eixo.nome}'),
      trailing: GestureDetector(
        onTap: () {
          bloc.eventSink(SelectEixoIDEvent(eixo));
          Navigator.pop(context);
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              //begin: Alignment.topLeft,
              // end: Alignment.bottomRight,
              colors: <Color>[
                Color(0xFF02AAB0),
                Color(0xFF00CDAC),
                Color(0xFF02AAB0),
              ],
            ),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Container(
            constraints: BoxConstraints(maxWidth: 100.0, minHeight: 50.0),
            alignment: Alignment.center,
            child: Text(
              "Selecionar",
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      // leading: IconButton(
      //   icon: Icon(Icons.check),
      //   onPressed: () {
      //     bloc.eventSink(SelectEixoIDEvent(eixo));
      //     Navigator.pop(context);
      //   },
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PmsbColors.navbar,
        bottomOpacity: 0.0,
        elevation: 0.0,
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

        var lista = List<Widget>();
        for (var produto in snapshot.data.produtoFunasaList) {
          lista.add(_cardBuild(context, produto));
        }

        return Container(
          color: PmsbColors.fundo,
          child: ListView(
            children: lista,
          ),
        );
      },
    );
  }

  Widget _cardBuild(BuildContext context, ProdutoFunasaModel produto) {
    return ListTile(
      title: Text('${produto.descricao}'),
      subtitle: Text('${produto.nome}'),
      trailing: GestureDetector(
        onTap: () {
          bloc.eventSink(SelectProdutoFunasaIDEvent(produto));
          Navigator.pop(context);
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              //begin: Alignment.topLeft,
              // end: Alignment.bottomRight,
              colors: <Color>[
                Color(0xFF02AAB0),
                Color(0xFF00CDAC),
                Color(0xFF02AAB0),
              ],
            ),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Container(
            constraints: BoxConstraints(maxWidth: 100.0, minHeight: 50.0),
            alignment: Alignment.center,
            child: Text(
              "Selecionar",
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      // leading: Text('${produto.id}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PmsbColors.navbar,
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: Text("Escolha um produto"),
      ),
      body: _listaProdutos(),
    );
  }
}

void _apagarAplicacao(context, PainelCrudBloc bloc) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(child: _DeleteDocumentOrField(bloc));
      });
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
        return Container(
          height: 250,
          color: PmsbColors.fundo,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                Text(
                  'Para apagar, digite CONCORDO na caixa de texto abaixo e confirme:  ',
                  style: PmsbStyles.textoPrimario,
                ),
                Container(
                  child: Flexible(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Digite aqui",
                        hintStyle: TextStyle(
                            color: Colors.white38, fontStyle: FontStyle.italic),
                      ),
                      controller: _textFieldController,
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    // Botao de cancelar delete
                    // GestureDetector(
                    //  onTap: () {
                    //return;
                    // },
                    Container(
                      height: 50.0,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xffEB3349),
                                Color(0xffF45C43),
                                Color(0xffEB3349)
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 150.0, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: Text(
                              "Cancelar",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Botao de confirmar delete
                    GestureDetector(
                      onTap: () {
                        if (_textFieldController.text == 'CONCORDO') {
                          bloc.eventSink(DeleteDocumentEvent());
                          Navigator.of(context).pop();
                        }
                      },
                      child: Container(
                        height: 50.0,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xff1D976C),
                                  Color(0xff1D976C),
                                  Color(0xff93F9B9)
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Container(
                              constraints: BoxConstraints(
                                  maxWidth: 150.0, minHeight: 50.0),
                              alignment: Alignment.center,
                              child: Text(
                                "Confirmar",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),

                // IconButton(
                //   icon: Icon(Icons.delete),
                //   onPressed: () {
                //     //Ir para a pagina visuais do produto
                //     if (_textFieldController.text == 'CONCORDO') {
                //       bloc.dispatch(DeleteMomentoAplicacaoPageBlocEvent());
                //       Navigator.of(context).pop();
                //     }
                //   },
                // )
              ],
            ),
          ),
        );

        // return Row(
        //   children: <Widget>[
        //     Divider(),
        //     Text('Para apagar digite CONCORDO e click:  '),
        //     Container(
        //       child: Flexible(
        //         child: TextField(
        //           controller: _textFieldController,
        //         ),
        //       ),
        //     ),
        //     IconButton(
        //       icon: Icon(Icons.delete),
        //       onPressed: () {
        //         if (_textFieldController.text == 'CONCORDO') {
        //           bloc.eventSink(DeleteDocumentEvent());
        //           Navigator.of(context).pop();
        //         }
        //       },
        //     )
        //   ],
        // );
      },
    );
  }
}
