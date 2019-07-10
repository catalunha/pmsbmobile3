import 'package:validators/validators.dart';
import 'package:pmsbmibile3/models/base_model.dart';

class UsuarioPerfil extends FirestoreModel {
  static final String collection = "UsuarioPerfil";

  String usuario;
  Perfil perfil;
  String conteudo;

  UsuarioPerfil({String id, this.usuario, this.perfil, this.conteudo}) : super(id);

  @override
  UsuarioPerfil fromMap(Map<String, dynamic> map) {
    if (map.containsKey('usuario')) usuario = map['usuario'];
    if (map.containsKey('perfil')) {
      perfil = map['perfil'] != null ? new Perfil.fromMap(map['perfil']) : null;
    }
    if (map.containsKey('conteudo')) conteudo = map['conteudo'];
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (usuario != null) data['usuario'] = this.usuario;
    if (this.perfil != null) {
      data['perfil'] = this.perfil.toMap();
    }
    if (conteudo != null) data['conteudo'] = this.conteudo;
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'UsuarioPerfilID: $usuario';
  }
}

class Perfil {
  String perfilID;
  String nome;
  String tipo;

  Perfil({this.perfilID, this.nome, this.tipo});

  Perfil.fromMap(Map<String, dynamic> map) {
    if (map.containsKey('perfilID')) perfilID = map['perfilID'];
    if (map.containsKey('nome')) nome = map['nome'];
    if (map.containsKey('tipo')) tipo = map['tipo'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (perfilID != null) data['perfilID'] = this.perfilID;
    if (nome != null) data['nome'] = this.nome;
    if (tipo != null) data['tipo'] = this.tipo;
    return data;
  }
}
