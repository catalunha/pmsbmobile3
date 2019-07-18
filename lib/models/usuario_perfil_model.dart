import 'package:pmsbmibile3/models/base_model.dart';

class UsuarioPerfilModel extends FirestoreModel {
  static final String collection = "UsuarioPerfil";
  UsuarioID usuarioID;
  PerfilID perfilID;
  String textPlain;
  UsuarioArquivoID usuarioArquivoID;

  UsuarioPerfilModel(
      {String id,
      this.usuarioID,
      this.perfilID,
      this.textPlain,
      this.usuarioArquivoID})
      : super(id);

  @override
  UsuarioPerfilModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('usuarioID')) {
      usuarioID = map['usuarioID'] != null
          ? new UsuarioID.fromMap(map['usuarioID'])
          : null;
    }
    if (map.containsKey('perfilID')) {
      perfilID = map['perfilID'] != null
          ? new PerfilID.fromMap(map['perfilID'])
          : null;
    }
    if (map.containsKey('textPlain')) textPlain = map['textPlain'];
    if (map.containsKey('usuarioArquivoID')) {
      usuarioArquivoID = map['usuarioArquivoID'] != null
          ? new UsuarioArquivoID.fromMap(map['usuarioArquivoID'])
          : null;
    }
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.usuarioID != null) {
      data['usuarioID'] = this.usuarioID.toMap();
    }
    if (this.perfilID != null) {
      data['perfilID'] = this.perfilID.toMap();
    }
    if (textPlain != null) data['textPlain'] = this.textPlain;
    if (this.usuarioArquivoID != null) {
      data['usuarioArquivoID'] = this.usuarioArquivoID.toMap();
    }
    return data;
  }
}

class UsuarioID {
  String id;
  String nome;

  UsuarioID({this.id, this.nome});

  UsuarioID.fromMap(Map<dynamic, dynamic> map) {
    if (map.containsKey('id')) id = map['id'];
    if (map.containsKey('nome')) nome = map['nome'];
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (id != null) data['id'] = this.id;
    if (nome != null) data['nome'] = this.nome;
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

class UsuarioArquivoID {
  String id;
  String url;

  UsuarioArquivoID({this.id, this.url});

  UsuarioArquivoID.fromMap(Map<dynamic, dynamic> map) {
    if (map.containsKey('id')) id = map['id'];
    if (map.containsKey('url')) url = map['url'];
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (id != null) data['id'] = this.id;
    if (url != null) data['url'] = this.url;
    return data;
  }
}
