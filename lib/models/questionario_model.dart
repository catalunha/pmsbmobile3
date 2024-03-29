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

class UsuarioQuestionario {
  String id;
  String nome;

  UsuarioQuestionario({this.id, this.nome});

  UsuarioQuestionario.fromMap(Map<dynamic, dynamic> map) {
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

  UsuarioQuestionario criou;

  UsuarioQuestionario editou;

  Eixo eixo;

  bool editando;

  int ultimaOrdem;

  int ordem;

  QuestionarioModel({
    String id,
    this.nome,
    this.criado,
    this.modificado,
    this.criou,
    this.editou,
    this.eixo,
    this.editando,
    this.ordem,
    this.ultimaOrdem,
  }) : super(id);

  @override
  QuestionarioModel fromMap(Map<String, dynamic> map) {
    nome = map["nome"];
    if (map.containsKey('criado'))
      criado = DateTime.fromMillisecondsSinceEpoch(
          map['criado'].millisecondsSinceEpoch);
    if (map.containsKey('modificado'))
      modificado = DateTime.fromMillisecondsSinceEpoch(
          map['modificado'].millisecondsSinceEpoch);

    editando = map["editando"];
    ordem = map["ordem"];
    ultimaOrdem = map["ultimaOrdem"];

    if (map["criou"] != null) {
      criou = UsuarioQuestionario.fromMap(map["criou"]);
    } else {
      criou = UsuarioQuestionario();
    }

    if (map["editou"] != null) {
      editou = UsuarioQuestionario.fromMap(map["editou"]);
    } else {
      editou = UsuarioQuestionario();
    }

    if (map["eixo"] != null) {
      eixo = Eixo.fromMap(map["eixo"]);
    } else {
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
    if (ordem != null) data['ordem'] = ordem;
    if (ultimaOrdem != null) data['ultimaOrdem'] = ultimaOrdem;
    return data;
  }
}

class QuestionarioAplicadoModel extends QuestionarioModel {
  static String collection = "QuestionarioAplicado";
  String referencia;
  Map<String, String> referencias;
  dynamic aplicado;
  UsuarioQuestionario aplicador;
  SetorCensitario setorCensitarioID;

  QuestionarioAplicadoModel({
    String id,
    this.referencia,
    this.referencias,
    this.aplicado,
    this.aplicador,
    this.setorCensitarioID,
    String nome,
    dynamic criado,
    dynamic modificado,
    UsuarioQuestionario criou,
    UsuarioQuestionario editou,
    Eixo eixo,
    bool editando,
    int ultimaOrdem,
  }) : super(
          id: id,
          nome: nome,
          criado: criado,
          modificado: modificado,
          criou: criou,
          editou: editou,
          eixo: eixo,
          editando: editando,
          ultimaOrdem: ultimaOrdem,
        );

  @override
  QuestionarioAplicadoModel fromMap(Map<String, dynamic> map) {
    referencia = map["referencia"];
    referencias = Map<String, String>();
    if (map["referencias"] != null) {
      final refs = map["referencias"] as Map<dynamic, dynamic>;
      for (var ref in refs.entries) {
        referencias[ref.key] = ref.value;
      }
    }

    if (map.containsKey('aplicado'))
      aplicado = DateTime.fromMillisecondsSinceEpoch(
          map['aplicado'].millisecondsSinceEpoch);

    if (map["aplicador"] != null) {
      aplicador = UsuarioQuestionario.fromMap(map["aplicador"]);
    } else {
      aplicador = UsuarioQuestionario();
    }

    if (map["setorCensitarioID"] != null) {
      setorCensitarioID = SetorCensitario.fromMap(map["setorCensitarioID"]);
    } else {
      setorCensitarioID = SetorCensitario();
    }
    return super.fromMap(map);
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    if (aplicado != null) map["aplicado"] = aplicado;
    if (referencia != null) map["referencia"] = referencia;
    if (aplicador != null) {
      map["aplicador"] = aplicador.toMap();
    }
    if (setorCensitarioID != null) {
      map["setorCensitarioID"] = setorCensitarioID.toMap();
    }
    if (referencias != null) map["referencias"] = referencias;
    return map;
  }
}

class SetorCensitario {
  String id;
  String nome;

  SetorCensitario({this.id, this.nome});

  SetorCensitario.fromMap(Map<dynamic, dynamic> map) {
    id = map["id"];
    nome = map["nome"];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nome": nome,
    };
  }
}
