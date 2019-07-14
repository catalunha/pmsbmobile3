import 'package:pmsbmibile3/models/base_model.dart';

class Eixo {
  String id;
  String nome;

  Eixo({this.id, this.nome});

  Eixo.fromMap(Map<dynamic, dynamic> map) {
    id = map['id'];
    nome = map['nome'];
  }

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) {
      map["id"] = id;
    }
    if (nome != null) {
      map["nome"] = nome;
    }
    return map;
  }
}

class UsuarioCriou {
  String id;
  String nome;

  UsuarioCriou({this.id, this.nome});

  UsuarioCriou.fromMap(Map<dynamic, dynamic> map) {
    id = map['id'];
    nome = map['nome'];
  }

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) {
      map["id"] = id;
    }
    if (nome != null) {
      map["nome"] = nome;
    }
    return map;
  }
}

class UsuarioEditou {
  String id;
  String nome;

  UsuarioEditou({this.id, this.nome});

  UsuarioEditou.fromMap(Map<dynamic, dynamic> map) {
    id = map['id'];
    nome = map['nome'];
  }

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) {
      map["id"] = id;
    }
    if (nome != null) {
      map["nome"] = nome;
    }
    return map;
  }
}

class QuestionarioModel extends FirestoreModel {
  static final String collection = "Questionario";

  String nome;

  dynamic criado;

  dynamic modificado;

  UsuarioCriou criou;

  UsuarioEditou editou;

  Eixo eixo;

  bool editando;

  QuestionarioModel({
    String id,
    this.nome,
    this.criado,
    this.modificado,
    this.criou,
    this.editou,
    this.eixo,
    this.editando,
  }) : super(id);

  @override
  QuestionarioModel fromMap(Map<String, dynamic> map) {
    nome = map["nome"];
    criado = map["criado"];
    modificado = map["modificado"];
    editando = map["editando"];
    if (map["criou"] != null) {
      criou = UsuarioCriou.fromMap(map["criou"]);
    }else{
      criou = UsuarioCriou();
    }
    if (map["editou"] != null) {
      editou = UsuarioEditou.fromMap(map["editou"]);
    }else{
      editou = UsuarioEditou();
    }
    if (map["eixo"] != null) {
      eixo = Eixo.fromMap(map["eixo"]);
    }else{
      eixo = Eixo();
    }
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final data = Map<String, dynamic>();
    if (nome != null) data['nome'] = nome;
    if (criado != null) data['criado'] = criado;
    if (modificado != null) data['modificado'] = modificado;
    if (criou != null) data['criou'] = criou.toMap();
    if (editou != null) data['editou'] = editou.toMap();
    if (eixo != null) data['eixo'] = eixo.toMap();
    if (editando != null) data['editando'] = editando;
    return data;
  }
}
