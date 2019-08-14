import 'package:pmsbmibile3/models/base_model.dart';

class ChatModel extends FirestoreModel {
  static final String collection = "Chat";
  static final String subcollectionMensagem = "ChatMensagem";
  static final String subcollectionNotificacao = "ChatNotificacao";
  Map<String, UsuarioChat> usuario;
  ChatModel({String id, this.usuario}) : super(id);

  @override
  ChatModel fromMap(Map<String, dynamic> map) {
    if (map["usuario"] is Map) {
      usuario = Map<String, UsuarioChat>();
      map["usuario"].forEach((k, v) {
        usuario[k] = UsuarioChat.fromMap(v);
      });
    }
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (usuario != null) {
      Map<String, dynamic> dataFromField = Map<String, dynamic>();
      this.usuario.forEach((k, v) {
        dataFromField[k] = v.toMap();
      });
      data['usuario'] = dataFromField;
    }
    return data;
  }
}

class UsuarioChat {
  String usuarioID;
  bool alertar;
  bool id;
  String nome;
  bool lido;

  UsuarioChat({this.usuarioID, this.id, this.nome, this.lido});

  UsuarioChat.fromMap(Map<dynamic, dynamic> map) {
    if (map.containsKey('usuarioID')) usuarioID = map['usuarioID'];
    if (map.containsKey('alertar')) alertar = map['alertar'];
    if (map.containsKey('id')) id = map['id'];
    if (map.containsKey('nome')) nome = map['nome'];
    if (map.containsKey('lido')) lido = map['lido'];
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (usuarioID != null) data['usuarioID'] = this.usuarioID;
    if (alertar != null) data['alertar'] = this.alertar;
    if (id != null) data['id'] = this.id;
    if (nome != null) data['nome'] = this.nome;
    if (lido != null) data['lido'] = this.lido;
    return data;
  }
}
