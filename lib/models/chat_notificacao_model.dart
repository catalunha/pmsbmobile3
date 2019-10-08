import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/base_model.dart';

class ChatNotificacaoModel extends FirestoreModel {
  static final String collection = "ChatNotificacao";
  String titulo;
  String texto;
  List<dynamic> usuario;
  DateTime enviada;

  ChatNotificacaoModel({String id, this.titulo, this.texto, this.usuario, this.enviada})
      : super(id);

  @override
  ChatNotificacaoModel fromMap(Map<String, dynamic> map) {
    // if (map.containsKey('enviada')) enviada = map['enviada'].toDate();
    if (map.containsKey('enviada')) enviada = DateTime.fromMillisecondsSinceEpoch(
        map['enviada'].millisecondsSinceEpoch);
    if (map.containsKey('titulo')) titulo = map['titulo'];
    if (map.containsKey('texto')) texto = map['texto'];
    if (map.containsKey('usuario')) usuario = map['usuario'];

    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (titulo != null) data['titulo'] = this.titulo;
    if (texto != null) data['texto'] = this.texto;
    if (enviada != null) data['enviada'] = this.enviada.toUtc();
    if (usuario != null) data['usuario'] = this.usuario;
    return data;
  }

  Map<String, dynamic> toMapFirestore() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (titulo != null) data['titulo'] = this.titulo;
    if (texto != null) data['texto'] = this.texto;
    data['enviada'] = Bootstrap.instance.fieldValue.serverTimestamp();
    if (usuario != null) data['usuario'] = this.usuario;
    return data;
  }

}
