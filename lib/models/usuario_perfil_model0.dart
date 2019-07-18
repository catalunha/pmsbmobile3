// import 'package:validators/validators.dart';
import 'package:pmsbmibile3/models/base_model.dart';

class UsuarioPerfil extends FirestoreModel {
  static final String collection = "UsuarioPerfil";

  String usuarioID;
  PerfilID perfilID;
  String conteudo;

  UsuarioPerfil({String id, this.usuarioID, this.perfilID, this.conteudo}) : super(id);

  @override
  UsuarioPerfil fromMap(Map<String, dynamic> map) {
    if (map.containsKey('usuarioID')) usuarioID = map['usuarioID'];
    if (map.containsKey('perfilID')) {
      perfilID = map['perfilID'] != null ? new PerfilID.fromMap(map['perfilID']) : null;
    }
    if (map.containsKey('conteudo')) conteudo = map['conteudo'];
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (usuarioID != null) data['usuarioID'] = this.usuarioID;
    if (this.perfilID != null) {
      data['perfilID'] = this.perfilID.toMap();
    }
    if (conteudo != null) data['conteudo'] = this.conteudo;
    return data;
  }
}

class PerfilID {
  String id;
  String nome;
  String contentType;

  PerfilID({this.id, this.nome, this.contentType});

  PerfilID.fromMap(Map<dynamic, dynamic> map) {
    if (map.containsKey('id')) id = map['id'];
    if (map.containsKey('nome')) nome = map['nome'];
    if (map.containsKey('contentType')) contentType = map['contentType'];
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (id != null) data['id'] = this.id;
    if (nome != null) data['nome'] = this.nome;
    if (contentType != null) data['contentType'] = this.contentType;
    return data;
  }
}