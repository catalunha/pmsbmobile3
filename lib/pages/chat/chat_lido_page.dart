import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatLidoPage extends StatefulWidget {
  ChatLidoPage({Key key}) : super(key: key);

  _ChatLidoPageState createState() => _ChatLidoPageState();
}

class _ChatLidoPageState extends State<ChatLidoPage> {
  Map<String, bool> usuarios = {
    'Usuario 01': false,
    'Usuario 02': true,
    'Usuario 03': false,
    'Usuario 04': false,
    'Usuario 05': true,
    'Usuario 04': true,
  };

  Widget _listaUsuarios() {
    return ListView(
      children: usuarios.keys.map((String key) {
        return new ListTile(
          trailing: Icon(usuarios[key]?Icons.check:Icons.not_interested),
          leading: Icon(Icons.person_pin, size: 30,),
          title: new Text(key),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat lidos"),
        automaticallyImplyLeading: true,
      ),
      body: _listaUsuarios(),
    );
  }
}
