import 'package:flutter/material.dart';

class ProdutoChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
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
    String usuario = "Usuario";
    return Container(
      height: 30.0,
      color: Colors.white12,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Center(
              child: Text('@$usuario', style: TextStyle(color: Colors.blue))),
          Container(width: 3.0),
          Center(
              child: Text('@$usuario', style: TextStyle(color: Colors.blue))),
          Container(width: 3.0),
          Center(
              child: Text('@$usuario', style: TextStyle(color: Colors.blue))),
          Container(width: 3.0),
          Center(
              child: Text('@$usuario', style: TextStyle(color: Colors.blue))),
          Container(width: 3.0),
          Center(
              child: Text('@$usuario', style: TextStyle(color: Colors.blue))),
          Container(width: 3.0),
          Center(
              child: Text('@$usuario', style: TextStyle(color: Colors.blue))),
          Container(width: 3.0),
          Center(
              child: Text('@$usuario', style: TextStyle(color: Colors.blue))),
          Container(width: 3.0),
          Center(
              child: Text('@$usuario', style: TextStyle(color: Colors.blue))),
          Container(width: 3.0),
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
    )
        //           padding: EdgeInsets.all(10.0),
        //           itemBuilder: (context, index) => buildItem(index, snapshot.data.documents[index]),
        //           itemCount: snapshot.data.documents.length,
        //           reverse: true,
        //           controller: listScrollController,
        //         );
        //Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.red)))
        // : StreamBuilder(
        //     stream: Firestore.instance
        //         .collection('messages')
        //         .document(groupChatId)
        //         .collection(groupChatId)
        //         .orderBy('timestamp', descending: true)
        //         .limit(20)
        //         .snapshots(),
        //     builder: (context, snapshot) {
        //       if (!snapshot.hasData) {
        //         return Center(
        //             child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)));
        //       } else {
        //         listMessage = snapshot.data.documents;
        //         return ListView.builder(
        //           padding: EdgeInsets.all(10.0),
        //           itemBuilder: (context, index) => buildItem(index, snapshot.data.documents[index]),
        //           itemCount: snapshot.data.documents.length,
        //           reverse: true,
        //           controller: listScrollController,
        //         );
        //       }
        //     },
        //   ),
        );
  }
}

class UsuarioListaModalSelect extends StatefulWidget {
  @override
  _UsuarioListaModalSelectState createState() =>
      _UsuarioListaModalSelectState();
}

class _UsuarioListaModalSelectState extends State<UsuarioListaModalSelect> {
  List<Map<dynamic, dynamic>> valores = [
    {"nome": "Todos", "valor": false},
    {"nome": "Usuario 01", "valor": false},
    {"nome": "Usuario 02", "valor": false},
    {"nome": "Usuario 03", "valor": false},
    {"nome": "Usuario 04", "valor": false},
    {"nome": "Usuario 01", "valor": false},
    {"nome": "Usuario 02", "valor": false},
    {"nome": "Usuario 03", "valor": false},
    {"nome": "Usuario 04", "valor": false}
  ];

  listOpcoesUsarios() {
    var i;
    Set<Widget> lista = new Set<Widget>();

    for (i = 0; i < valores.length; i++) {
      lista.add(CheckboxListTile(
        title: Text(valores[i]['nome']),
        value: false,
        onChanged: (boolValue) {
          setState(() {
            valores[i]['valor'] = boolValue;
          });
        },
      ));
    }

    return lista.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new ListView(children: listOpcoesUsarios()),
    );
  }
}
