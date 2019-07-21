import 'package:pmsbmibile3/models/base_model.dart';


class PerguntaModel extends FirestoreModel {
  static final String collection = "Pergunta";


//  "Pergunta": {
//    "referencia": "uid",
//    "anterior": "PerguntaID->referencia || null",
//    "posterior": "PerguntaID->referencia || null",
  String referencia;
  String anterior;
  String posterior;

  Questionario questionario;
  PerguntaTipo tipo;
  List<Requisito> requisitos;
  List<Escolha> escolhas;

  int ordem;
  String titulo;
  String textoMarkdown;

  dynamic dataCriacao;
  dynamic dataEdicao;

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
  }): super(id);

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
    if (questionario != null) map["questionario"] = questionario.toMap();
    if (tipo != null) map["tipo"] = tipo.toMap();

    if (requisitos != null) {
      map["requisitos"] = List<Map<String, dynamic>>();
      for (int index = 0; index < requisitos.length; index++) {
        map["requisitos"].add(requisitos[index].toMap());
      }
    }

    if (escolhas != null) {
      map["escolhas"] = List<Map<String, dynamic>>();
      for (int index = 0; index < escolhas.length; index++) {
        map["escolhas"].add(escolhas[index].toMap());
      }
    }

    if (ordem != null) map["ordem"] = ordem;
    if (titulo != null) map["titulo"] = titulo;
    if (textoMarkdown != null) map["textoMarkdown"] = textoMarkdown;
    if (dataCriacao != null) map["dataCriacao"] = dataCriacao;
    if (dataEdicao != null) map["dataEdicao"] = dataEdicao;
    return map;
  }
}

class Questionario {
  String id;
  String nome;

  Questionario(this.id, this.nome);

  Questionario.fromMap(Map<dynamic, dynamic> map) {
    id = map["id"];
    nome = map["nome"];
  }

  Map<dynamic, dynamic> toMap() {
    final map = Map<dynamic, dynamic>();
    if (id != null) map["id"] = id;
    if (nome != null) map["nome"] = nome;
    return map;
  }
}


class PerguntaTipo {
  String id;
  String nome;

  PerguntaTipo(this.id, this.nome);

  PerguntaTipo.fromMap(Map<dynamic, dynamic> map) {
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

class Texto{
  String valor;
  String observacao;
}

class Numero{
  num valor;
  String observacao;
}

class RespostasArquivo{
  List<String> arquivoID;
  String observacao;
}

class RespostasImagem{
  List<String> imagemID;
  String observacao;
}

class RespostasCoordenada{
  List<Coordenada> coordenadas;
  String observacao;
}

class Coordenada{
  Coordenada({this.lat, this.long});
  num lat;
  num long;
}


///
class Requisito {
  bool key;
  String id;
  String ligado; // o que é isso? "ligado": "requisito.uid.id",
  String perguntaID;
  String escolhaID;
  bool marca;

  Requisito.fromMap(Map<dynamic, dynamic> map) {
    perguntaID = map["perguntaID"];
    escolhaID = map["escolhaID"];
  }

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (perguntaID != null) map["perguntaID"] = perguntaID;
    if (escolhaID != null) map["escolhaID"] = escolhaID;
    return map;
  }
}

class Escolha {
  String uid;
  bool key = true;
  int ordem;
  String texto;
  bool marcada = false;

  Escolha.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    texto = map["texto"];
    ordem = map["ordem"];
  }

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (uid != null) map["uid"] = uid;
    if (ordem != null) map["ordem"] = ordem;
    if (texto != null) map["texto"] = texto;
    return map;
  }
}