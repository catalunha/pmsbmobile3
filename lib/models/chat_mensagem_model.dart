import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/base_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';

class ChatMensagemModel extends FirestoreModel {
  static final String collection = "ChatMensagem";
  UsuarioID autor;
  String texto;
  DateTime enviada;

  ChatMensagemModel({String id, this.autor, this.texto, this.enviada})
      : super(id);

  @override
  ChatMensagemModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('enviada')) enviada = DateTime.fromMillisecondsSinceEpoch(
        map['enviada'].millisecondsSinceEpoch);
    if (map.containsKey('texto')) texto = map['texto'];
    if (map.containsKey('autor')) {
      autor = map['autor'] != null ? new UsuarioID.fromMap(map['autor']) : null;
    }
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (texto != null) data['texto'] = this.texto;
        data['enviada'] = Bootstrap.instance.fieldValue.serverTimestamp();
    if (this.autor != null) {
      data['autor'] = this.autor.toMap();
    }
    return data;
  }

}
