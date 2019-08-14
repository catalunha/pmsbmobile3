import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/chat_model.dart';
import 'package:pmsbmibile3/pages/chat/chat_lido_bloc.dart';

class ChatLidoPage extends StatelessWidget {
  final ChatLidoPageBloc bloc;
  final String chatID;
  ChatLidoPage(this.chatID)
      : bloc = ChatLidoPageBloc(Bootstrap.instance.firestore) {
        print('>>> ChatLidoPage this.chatID <<< ${this.chatID}');
    bloc.eventSink(UpdateChatIDEvent(chatID:this.chatID));
  }
  void dispose() {
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Usuarios que leram este Chat"),
      ),
      body: StreamBuilder<ChatLidoPageState>(
        stream: bloc.stateStream,
        builder:
            (BuildContext context, AsyncSnapshot<ChatLidoPageState> snapshot) {
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
      ),
    );
  }

  Widget _cardBuild(BuildContext context, String key, UsuarioChat usuario) {
    print(usuario.nome);
    return ListTile(
      title: Text(usuario.nome),
      leading: usuario.lido ?  Icon(Icons.playlist_add_check): Icon(Icons.not_interested),
    );
  }
}
