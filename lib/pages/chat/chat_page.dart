import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Navigator.pushNamed(context, "/chat/lista_chat_visualizada");
            },
          )
        ],
        title: new Text(
          'CHAT',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: TelaChat(),
    );
  }
}

class TelaChat extends StatefulWidget {
  @override
  _TelaChatState createState() => _TelaChatState();
}

class _TelaChatState extends State<TelaChat> {
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
    return Container(
      child: Row(
        children: <Widget>[
          //escolher os usuarios que vão receber notificacao
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.supervised_user_circle),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext bc) {
                        return UsuarioListaModalSelect();
                      });
                }, //getSticker,
                color: Colors.black54,
              ),
            ),
            color: Colors.white,
          ),

          // Caixa de texto
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: Colors.black87, fontSize: 15.0),
                //controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Digite aqui ...',
                  hintStyle: TextStyle(color: Colors.black87),
                ),
                //focusNode: focusNode,
              ),
            ),
          ),

          // Botao enviar mensagem
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed:
                    null, //() => onSendMessage(textEditingController.text, 0),
                color: Colors.black54,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border:
              new Border(top: new BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
    );
  }

  Widget usuariosMarcados() {
    String usuario = "Usuario_Nome";
    return Container(
      height: 30.0,
      color: Colors.white12,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Center(
              child: Text('@$usuario', style: TextStyle(color: Colors.blue))),
          Container(width: 4.0),
          Center(
              child: Text('@$usuario', style: TextStyle(color: Colors.blue))),
          Container(width: 4.0),
          Center(
              child: Text('@$usuario', style: TextStyle(color: Colors.blue))),
          Container(width: 4.0),
          Center(
              child: Text('@$usuario', style: TextStyle(color: Colors.blue))),
          Container(width: 4.0),
          Center(
              child: Text('@$usuario', style: TextStyle(color: Colors.blue))),
          Container(width: 4.0),
          Center(
              child: Text('@$usuario', style: TextStyle(color: Colors.blue))),
          Container(width: 4.0),
          Center(
              child: Text('@$usuario', style: TextStyle(color: Colors.blue))),
          Container(width: 4.0),
          Center(
              child: Text('@$usuario', style: TextStyle(color: Colors.blue))),
          Container(width: 4.0),
          Center(
              child: Text('@$usuario', style: TextStyle(color: Colors.blue))),
        ],
      ),
    );
  }

  Widget buildMessageCard(bool marcador) {
    return Container(
      decoration: new BoxDecoration(
          color: Colors.black12,
          borderRadius: new BorderRadius.all(const Radius.circular(20.0))),
      margin: marcador
          ? new EdgeInsets.fromLTRB(60.0, 6.0, 6.0, 6.0)
          : new EdgeInsets.fromLTRB(6.0, 6.0, 60.0, 6.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(height: 10.0),
            !marcador
                ? Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      "Nome Usuario",
                      style: TextStyle(color: Colors.blueGrey, fontSize: 14),
                    ))
                : Container(),
            !marcador ? Container(height: 5.0) : Container(),
            Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  "Olá message test, bla bla bla ... um dois tres ... teste teste teste",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                )),
            Container(height: 5.0),
            Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  "05 de julho as 19:00 horas",
                  style: TextStyle(color: Colors.black26, fontSize: 13),
                )),
            Container(height: 10.0),
          ]),
      //color: Colors.black26
    );
  }

  Widget buildListaMensagens() {
    return Flexible(
        child: ListView(
      children: <Widget>[
        buildMessageCard(true),
        buildMessageCard(false),
        buildMessageCard(true),
        buildMessageCard(true),
        buildMessageCard(false),
        buildMessageCard(true),
      ],
    ));
  }
}

/// Selecao de usuario que vao receber alerta
class UsuarioListaModalSelect extends StatefulWidget {
  @override
  _UsuarioListaModalSelectState createState() =>
      _UsuarioListaModalSelectState();
}

class _UsuarioListaModalSelectState extends State<UsuarioListaModalSelect> {
  Map<String, bool> valores = {
    'Todos': false,
    'Usuario 01': false,
    'Usuario 02': false,
    'Usuario 03': false,
    'Usuario 04': false,
    'Usuario 05': false,
    'Usuario 04': false,
  };

  _marcarTodosDaListaComoTrue(bool value) {
    setState(() {
      valores.keys.forEach((String key) {
        valores[key] = value;
      });
    });
  }

  Widget _listaUsuarios() {
    return ListView(
      children: valores.keys.map((String key) {
        return new CheckboxListTile(
          title: new Text(key),
          value: valores[key],
          onChanged: (bool value) {
            if (key == 'Todos') {
              _marcarTodosDaListaComoTrue(value);
            } else {
              setState(() {
                valores[key] = value;
              });
            }
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alertar os usuários",
            style: TextStyle(fontSize: 15, color: Colors.black45)),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        actions: <Widget>[
          RaisedButton(
              child: Text("Salvar"),
              textColor: Colors.blue,
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
      body: _listaUsuarios(),
    );
  }
}
