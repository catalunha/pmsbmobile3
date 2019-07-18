import 'package:pmsbmibile3/models/base_model.dart';

class Questionario {
  String id;
  String nome;

  Questionario.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    nome = map["nome"];
  }

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) map["id"] = id;
    if (nome != null) map["nome"] = nome;
    return map;
  }
}

class PerguntaTipo {
  String id;
  String nome;

  PerguntaTipo.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    nome = map["nome"];
  }

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) map["id"] = id;
    if (nome != null) map["nome"] = nome;
    return map;
  }
}

class Requisito {
  String uid;
  String questionarioID;
  String perguntaID;
  String escolhaID;

  Requisito.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    questionarioID = map["questionarioID"];
    perguntaID = map["perguntaID"];
    escolhaID = map["escolhaID"];
  }

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (uid != null) map["uid"] = uid;
    if (questionarioID != null) map["questionarioID"] = questionarioID;
    if (perguntaID != null) map["perguntaID"] = perguntaID;
    if (escolhaID != null) map["escolhaID"] = escolhaID;
    return map;
  }
}

class Escolha {
  String uid;
  int ordem;
  String nome;

  Escolha.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    nome = map["nome"];
    ordem = map["ordem"];
  }

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (uid != null) map["uid"] = uid;
    if (ordem != null) map["ordem"] = ordem;
    if (nome != null) map["nome"] = nome;
    return map;
  }
}

class PerguntaModel extends FirestoreModel {
  static final String collection = "Pergunta";

  Questionario questionario;
  PerguntaTipo tipo;
  List<Requisito> requisitos;
  List<Escolha> escolhas;

  int ordem;
  String titulo;
  String textoMarkdown;

  DateTime dataCriacao;
  DateTime dataEdicao;

  PerguntaModel({
    String id,
    this.questionario,
    this.tipo,
    this.requisitos,
    this.escolhas,
    this.ordem,
    this.titulo,
    this.textoMarkdown,
    this.dataCriacao,
    this.dataEdicao,
  }) : super(id);

  @override
  PerguntaModel fromMap(Map<String, dynamic> map) {
    if (map["questionario"] is Map)
      questionario = Questionario.fromMap(map['questionario']);
    if (map["tipo"] is Map) tipo = PerguntaTipo.fromMap(map['tipo']);
    if (map["requisitos"] is List) {
      requisitos = List<Requisito>();
      for (int index = 0; index < map["requisitos"].length; index++)
        requisitos.add(Requisito.fromMap(map['requisitos']));
    }
    if (map["escolhas"] is List) {
      escolhas = List<Escolha>();
      for (int index = 0; index < map["escolhas"].length; index++)
        escolhas.add(Escolha.fromMap(map['escolhas']));
    }

    ordem = map['ordem'];
    titulo = map['titulo'];
    textoMarkdown = map['textoMarkdown'];

    dataCriacao = map['dataCriacao'];
    dataEdicao = map['dataEdicao'];

    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if(questionario != null) map["questionario"] = questionario.toMap();
    if(tipo != null) map["tipo"] = tipo.toMap();
    //TODO: list de maps
    if(requisitos != null) map["requisitos"] = requisitos;
    if(escolhas != null) map["escolhas"] = escolhas;

    if(ordem != null) map["ordem"] = ordem;
    if(titulo != null) map["titulo"] = titulo;
    if(textoMarkdown != null) map["textoMarkdown"] = textoMarkdown;
    if(dataCriacao != null) map["dataCriacao"] = dataCriacao;
    if(dataEdicao != null) map["dataEdicao"] = dataEdicao;
    return map;
  }
}
