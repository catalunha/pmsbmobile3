import 'package:pmsbmibile3/models/base_model.dart';

class PerguntaAplicadaModel extends PerguntaModel {
  static final String collection = "PerguntaAplicada";
}

/// Classe que representa um modelo da coleção Pergunta
class PerguntaModel extends FirestoreModel {
  static final String collection = "Pergunta";

  ///"referencia": "familia da pergunta. uid - gerado internamente pelo dart",
  String referencia;

  ///    "anterior": "PerguntaID || null. para navegação apenas",
  String anterior;

  ///    "posterior": "PerguntaID || null. para navegação apenas",
  String posterior;

  ///Questionario do qual esta pergunta pertence
  Questionario questionario;

  PerguntaTipo tipo;

  List<Requisito> requisitos;

  /// Mapa contendo escolhas
  Map<String, Escolha> escolhas;

  int ordem;

  String titulo;

  String textoMarkdown;

  /// [observacao] é um campo disponivel para informações adicionais durante
  /// a aplicação da pergunta
  String observacao;

  dynamic dataCriacao;

  dynamic dataEdicao;

  ///Atributos que armazenam as respostos da aplicação das perguntas

  ///No caso de pergunta do tipo Texto a resposta é armazenada no atributo
  ///[texto]
  String texto;

  ///No caso de pergunta do tipo Numero a resposta é armazenada no atributo
  ///[numero]
  num numero;

  ///No caso de pergunta do tipo Arquivo ou Imagem a resposta é armazenada no atributo
  ///[arquivo]
  List<String> arquivo;

  ///No caso de pergunta do tipo Coordenada a resposta é armazenada no atributo
  ///[coordenada]
  List<Coordenada> coordenada;

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

    referencia = map["referencia"];

    anterior = map["anterior"];

    posterior = map["posterior"];

    ordem = map['ordem'];

    titulo = map['titulo'];

    textoMarkdown = map['textoMarkdown'];

    observacao = map['observacao'];

    dataCriacao = map['dataCriacao'];

    dataEdicao = map['dataEdicao'];

    /// respostas

    ///escolhas contem as opções possiveis e a informação de quem foi marcado
    if (map["escolhas"] is Map) {
      escolhas = Map<String, Escolha>();
      map["escolhas"].forEach((k, v) {
        escolhas[k] = Escolha.fromMap(v);
      });
    }

    texto = map["texto"];

    numero = map["numero"];

    arquivo = map["arquivo"];

    if (map["coordenada"] is List) {
      coordenada = List<Coordenada>();
      map["coordenada"].forEach((e) {
        coordenada.add(Coordenada.fromMap(e));
      });
    }

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
      map["escolhas"] = Map<String, Map<String, dynamic>>();
      escolhas.forEach((k, v) {
        map["escolhas"][k] = v.toMap();
      });
    }

    if (ordem != null) map["ordem"] = ordem;

    if (titulo != null) map["titulo"] = titulo;

    if (textoMarkdown != null) map["textoMarkdown"] = textoMarkdown;

    if (dataCriacao != null) map["dataCriacao"] = dataCriacao;

    if (dataEdicao != null) map["dataEdicao"] = dataEdicao;

    //respostas
    if (texto != null) map["texto"] = texto;

    if (numero != null) map["numero"] = numero;

    if (arquivo != null) map["arquivo"] = arquivo;

    if (coordenada != null) {
      map["coordenada"] = List<Map<String, dynamic>>();
      coordenada.forEach((e) {
        map["coordenada"].add(e.toMap());
      });
    }

    return map;
  }
}

class Questionario {
  /// [id] do documento que permite acesso ao questionario que a pergunta
  /// pertence
  String id;

  /// Nome do Questionario para que não seja necessario buscar em outra coleção
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

class Coordenada {
  Coordenada({this.latitude, this.longitude});

  num latitude;
  num longitude;

  Coordenada.fromMap(Map<dynamic, dynamic> map) {
    latitude = map["latitude"];
    longitude = map["longitude"];
  }

  Map<String, dynamic> toMap() {
    return {
      if (latitude != null) "latitude": latitude,
      if (longitude != null) "longitude": longitude,
    };
  }
}

/// Requisito
///{
///  "referencia": "PerguntaID->referencia",
///  "perguntaID": "PerguntaID",
///  "perguntaTipo": "PerguntaID->escolha || PerguntaID->texto",
///  "escolha": {
///    "id": "PerguntaID->escolha->uid->key",
///    "marcada": true
///  }
///}
///
class Requisito {
  String referencia;
  String perguntaID;
  String perguntaTipo;
  EscolhaRequisito escolha;

  Requisito.fromMap(Map<dynamic, dynamic> map) {
    referencia = map["referencia"];
    perguntaID = map["perguntaID"];
    perguntaTipo = map["perguntaTipo"];
    if (map["escolha"] != null && map["escolha"] is Map)
      escolha = EscolhaRequisito.fromMap(map["escolha"]);
  }

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (referencia != null) map["referencia"] = referencia;
    if (perguntaID != null) map["perguntaID"] = perguntaID;
    if (perguntaTipo != null) map["perguntaTipo"] = perguntaTipo;
    if (escolha != null && escolha is EscolhaRequisito)
      map["escolha"] = escolha.toMap();
    return map;
  }
}

/// EscolhaRequisito
///{
///  "id": "PerguntaID->escolha->uid->key",
///  "marcada": true
///}
///
class EscolhaRequisito {
  String id;
  bool marcada;

  EscolhaRequisito.fromMap(Map<dynamic, dynamic> map) {
    id = map["id"];
    marcada = map["marcada"];
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) "id": id,
      if (marcada != null) "marcada": marcada,
    };
  }
}

/// Escolha
/// Modelo que representa um possivel escolha na pergunta dos tipos UnicaEscolha
/// e MultiplaEscolha
///"uid": {
///  "key": true,
///  "ordem": 0,
///  "texto": "texto-valor",
///  "marcada": true
///}
///
class Escolha {
  String uid;
  bool key;
  int ordem;
  String texto;
  bool marcada;

  Escolha.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    key = map["key"];
    ordem = map["ordem"];
    texto = map["texto"];
    marcada = map["marcada"];
  }

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (uid != null) map["uid"] = uid;
    if (key != null) map["key"] = key;
    if (ordem != null) map["ordem"] = ordem;
    if (texto != null) map["texto"] = texto;
    if (marcada != null) map["marcada"] = marcada;
    return map;
  }
}
