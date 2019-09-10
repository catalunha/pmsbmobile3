import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/chat_mensagem_model.dart';
import 'package:pmsbmibile3/models/chat_model.dart';
import 'package:pmsbmibile3/pages/chat/chat_bloc.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';

class ChatPage extends StatefulWidget {
  final String chatID;
  final String modulo;
  final String titulo;
  final AuthBloc authBloc;

  ChatPage({this.authBloc, this.modulo, this.titulo, this.chatID});

  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//        child: child,
//     );
//   }
// }

// class ChatPage extends StatelessWidget {
//   final String chatID;
//   final String modulo;
//   final String titulo;
//   final AuthBloc authBloc;

//   const ChatPage({this.authBloc, this.modulo, this.titulo, this.chatID});
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Navigator.pushNamed(context, "/chat/lido",
                  arguments: widget.chatID);
            },
          )
        ],
        title: Text(
          'CHAT',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: TelaChat(
          authBloc: widget.authBloc,
          modulo: widget.modulo,
          chatID: widget.chatID,
          titulo: widget.titulo),
    );
  }
}

class TelaChat extends StatefulWidget {
  final String chatID;
  final String modulo;
  final String titulo;
  final AuthBloc authBloc;

  const TelaChat({this.modulo, this.titulo, this.authBloc, this.chatID});

  @override
  _TelaChatState createState() => _TelaChatState(this.authBloc);
}

class _TelaChatState extends State<TelaChat> {
  final textEditingController = TextEditingController();
  final ChatPageBloc bloc;
  ScrollController _scrollController = new ScrollController();

  _TelaChatState(AuthBloc authBloc)
      : bloc = ChatPageBloc(Bootstrap.instance.firestore, authBloc);

  @override
  void initState() {
    super.initState();
    bloc.eventSink(UpdateChatIDModuloTituloEvent(
        chatID: widget.chatID, modulo: widget.modulo, titulo: widget.titulo));
  }

  @override
  void dispose() {
    bloc.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              buildListaMensagens(),
              // // Sticker
              // (isShowSticker ? buildSticker() : Container()),
              // // Input content
              usuariosMarcados(),
              buildInput(context),
            ],
          ),

          // Loading
          // buildLoading()
        ],
      ),
      onWillPop: null,
    );
  }

  Widget buildInput(context) {
    return

        // Caixa de texto
        // Flexible(
        //   child: Container(
        //     child: TextField(
        //       style: TextStyle(color: Colors.black87, fontSize: 15.0),
        //       //controller: textEditingController,
        //       decoration: InputDecoration.collapsed(
        //         hintText: 'Digite aqui ...',
        //         hintStyle: TextStyle(color: Colors.black87),
        //       ),
        //       //focusNode: focusNode,
        //     ),
        //   ),
        // ),
        StreamBuilder<ChatPageState>(
            stream: bloc.stateStream,
            builder:
                (BuildContext context, AsyncSnapshot<ChatPageState> snapshot) {
              // if (!snapshot.hasData) {
              //   return Text('Sem mensagens');
              // }
              if (textEditingController.text == null ||
                  textEditingController.text.isEmpty) {
                textEditingController.text = snapshot.data?.msgToSend;
              }
              // if (snapshot.hasData) {
              return Container(
                child: Row(
                  children: <Widget>[
                    //+++ escolher os usuarios que vão receber notificacao
                    Material(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 1.0),
                        child: IconButton(
                          icon: Icon(Icons.supervised_user_circle),
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext bc) {
                                  return UsuarioListaModalSelect(bloc);
                                });
                          }, //getSticker,
                          color: Colors.black54,
                        ),
                      ),
                      color: Colors.white,
                    ),
                    //--- escolher os usuarios que vão receber notificacao
                    //+++ TextField escrever a msg
                    Flexible(
                      child: Container(
                        child: TextField(
                          onChanged: (textPlain) {
                            return bloc
                                .eventSink(UpDateMsgToSendEvent(textPlain));
                          },
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,

                          style:
                              TextStyle(color: Colors.black87, fontSize: 15.0),
                          controller: textEditingController,
                          decoration: InputDecoration.collapsed(
                            hintText: 'Digite uma mensagem ',
                            hintStyle: TextStyle(color: Colors.black26),
                          ),
                          //focusNode: focusNode,
                        ),
                      ),
                    ),
                    //--- TextField escrever a msg
                    //+++ Botao enviar mensagem
                    Material(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: textEditingController.text.isEmpty
                              ? null
                              : () {
                                  textEditingController.clear();
                                  return bloc.eventSink(SendMsgEvent());
                                },
                          color: Colors.black54,
                        ),
                      ),
                      color: Colors.white,
                    ),
                    //--- Botao enviar mensagem
                  ],
                ),
                width: double.infinity,
                height: 60.0,
                decoration: BoxDecoration(
                    border:
                        Border(top: BorderSide(color: Colors.grey, width: 0.5)),
                    color: Colors.white),
              );
            });
  }

  Widget usuariosMarcados() {
    return StreamBuilder<ChatPageState>(
      stream: bloc.stateStream,
      builder: (BuildContext context, AsyncSnapshot<ChatPageState> snapshot) {
        if (snapshot.hasError)
          return Center(
            child: Text("Erro. Informe ao administrador do aplicativo"),
          );
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data.usuario == null) {
          return Center(
            child: Text("Nenhum usuario neste chat."),
          );
        }
        if (snapshot.data.usuario.isEmpty) {
          return Center(
            child: Text("Vazio."),
          );
        }

        var usuario = Map<String, UsuarioChat>();

        usuario = snapshot.data?.usuario;
        var lista = List<Widget>();
        for (var item in usuario.entries) {
          if (item.value?.alertar != null && item.value.alertar) {
            lista.add(Center(
                child: Text('@${item.value.nome}. ',
                    style: TextStyle(color: Colors.blue))));
          }
        }

        // return ListView(
        //   children: lista,
        // );
        return Container(
          height: 30.0,
          color: Colors.white12,
          child: ListView(scrollDirection: Axis.horizontal, children: lista),
        );
      },
    );
  }

  Widget buildMessageCard(
      bool marcador, String usuario, String texto, String datahora) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.all(const Radius.circular(20.0))),
      margin: marcador
          ? EdgeInsets.fromLTRB(60.0, 6.0, 6.0, 6.0)
          : EdgeInsets.fromLTRB(6.0, 6.0, 60.0, 6.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(height: 10.0),
            !marcador
                ? Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      usuario,
                      style: TextStyle(color: Colors.blueGrey, fontSize: 14),
                    ))
                : Container(),
            !marcador ? Container(height: 5.0) : Container(),
            Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  texto,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                )),
            Container(height: 5.0),
            Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  datahora,
                  style: TextStyle(color: Colors.black26, fontSize: 13),
                )),
            Container(height: 10.0),
          ]),
      //color: Colors.black26
    );
  }

  Widget buildListaMensagens() {
    return StreamBuilder<List<ChatMensagemModel>>(
      stream: bloc.chatMensagemListStream,
      builder: (BuildContext context,
          AsyncSnapshot<List<ChatMensagemModel>> snapshot) {
        if (snapshot.hasError)
          return Center(
            child: Text("Erro. Informe ao administrador do aplicativo"),
          );
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data == null) {
          return Center(
            child: Text("Nenhum mensagem neste chat."),
          );
        }
        if (snapshot.data.isEmpty) {
          return Center(
            child: Text("Lista de mensagens vazia."),
          );
        }

        String usuarioAtual = bloc.state.usuarioModel.id;
        var lista = List<Widget>();
        print(usuarioAtual);
        for (var item in snapshot.data) {
          if (item.enviada != null) {
            lista.add(buildMessageCard(item.autor.id == usuarioAtual,
                item.autor.nome, item.texto, item.enviada.toDate().toString()));
          }
        }
        //TODO: Precisamos retirar o time e colocar algo mais inteligente.
        Timer(
            Duration(milliseconds: 100),
            () => _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent));
        return Flexible(
            child: ListView(
          controller: _scrollController,
          children: lista,
        ));
      },
    );
  }
}

/// Selecao de usuario que vao receber alerta
class UsuarioListaModalSelect extends StatefulWidget {
  final ChatPageBloc bloc;

  const UsuarioListaModalSelect(this.bloc);

  @override
  _UsuarioListaModalSelectState createState() =>
      _UsuarioListaModalSelectState(this.bloc);
}

class _UsuarioListaModalSelectState extends State<UsuarioListaModalSelect> {
  final ChatPageBloc bloc;

  _UsuarioListaModalSelectState(this.bloc);

  // Map<String, bool> valores = {
  //   'Todos': false,
  //   'Usuario 01': false,
  //   'Usuario 02': false,
  //   'Usuario 03': false,
  //   'Usuario 04': false,
  //   'Usuario 05': false,
  //   'Usuario 04': false,
  // };

  // _marcarTodosDaListaComoTrue(bool value) {

  // }

  Widget _listaUsuarios() {
    return StreamBuilder<ChatPageState>(
      stream: bloc.stateStream,
      builder: (BuildContext context, AsyncSnapshot<ChatPageState> snapshot) {
        if (snapshot.hasError)
          return Center(
            child: Text("Erro. Informe ao administrador do aplicativo"),
          );
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data.usuario == null) {
          return Center(
            child: Text("Nenhum usuario neste chat."),
          );
        }
        if (snapshot.data.usuario.isEmpty) {
          return Center(
            child: Text("Vazio."),
          );
        }

        var usuario = Map<String, UsuarioChat>();

        usuario = snapshot.data?.usuario;
        var lista = List<Widget>();
        for (var item in usuario.entries) {
          // print('usuario: ${item.key}');
          lista.add(_cardBuild(context, item.key, item.value));
        }

        return ListView(
          children: lista,
        );
      },
    );

    // return ListView(
    //   children: valores.keys.map((String key) {
    //     return CheckboxListTile(
    //       title: Text(key),
    //       value: valores[key],
    //       onChanged: (bool value) {
    //         if (key == 'Todos') {
    //           _marcarTodosDaListaComoTrue(value);
    //         } else {
    //           setState(() {
    //             valores[key] = value;
    //           });
    //         }
    //       },
    //     );
    //   }).toList(),
    // );
  }

  Widget _cardBuild(BuildContext context, String key, UsuarioChat usuario) {
    // print(usuario.nome);
    // return ListTile(
    //   title: Text(usuario.nome),
    //   leading: usuario.lido ?  Icon(Icons.playlist_add_check): Icon(Icons.not_interested),
    // );
    return CheckboxListTile(
      title: Text(usuario.nome),
      value: usuario.alertar == null ? false : usuario.alertar,
      onChanged: (bool alertar) {
        bloc.eventSink(UpDateAlertaEvent(usuarioChatID: key, alertar: alertar));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alertar os usuários",
            style: TextStyle(fontSize: 15, color: Colors.black45)),
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.blueGrey,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check_box),
            onPressed: () {
              bloc.eventSink(UpDateAlertarTodosEvent(true));
            },
          ),
          IconButton(
            icon: Icon(Icons.check_box_outline_blank),
            onPressed: () {
              bloc.eventSink(UpDateAlertarTodosEvent(false));
            },
          ),
          IconButton(
            icon: Icon(Icons.repeat),
            onPressed: () {
              bloc.eventSink(UpDateAlertarTodosEvent(null));
            },
          ),
          // RaisedButton(
          //     child: Text("Marcar todos"),
          //     textColor: Colors.blue,
          //     color: Colors.white,
          //     onPressed: () {
          //       bloc.eventSink(UpDateAlertarTodosEvent());
          //     }),
          // RaisedButton(
          //     child: Text("Salvar"),
          //     textColor: Colors.blue,
          //     color: Colors.white,
          //     onPressed: () {
          //       Navigator.pop(context);
          //     })
        ],
      ),
      body: _listaUsuarios(),
    );
  }
}
