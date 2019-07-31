import 'package:pmsbmibile3/models/base_model.dart';
import 'package:pmsbmibile3/models/pergunta_tipo_model.dart';

class PerguntaAplicadaModel extends PerguntaModel {
  static final String collection = "PerguntaAplicada";

  PerguntaAplicadaModel({
    String id,
    bool temPendencias: true,
    bool foiRespondida: false,
  })  : _temPendencias = temPendencias,
        _foiRespondida = foiRespondida,
        super(id: id);

  bool _temPendencias;

  set temPendencias(bool p) {
    _temPendencias = p != null ? p : true;
  }

  bool get temPendencias => _temPendencias != null ? _temPendencias : false;

  bool _foiRespondida;

  set foiRespondida(bool f) {
    _foiRespondida = f != null ? f : false;
  }

  bool get foiRespondida => _foiRespondida != null ? _foiRespondida : false;

  @override
  PerguntaAplicadaModel fromMap(Map<String, dynamic> map) {
    temPendencias = map["temPendencias"];
    foiRespondida = map["foiRespondida"];
    return super.fromMap(map);
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map["temPendencias"] = temPendencias;
    map["foiRespondida"] = foiRespondida;
    return map;
  }


}

/// Classe que representa um modelo da coleção Pergunta
class PerguntaModel extends FirestoreModel {
  static final String collection = "Pergunta";

  ///"referencia": "familia da pergunta. uid - gerado internamente pelo dart",
  String referencia;

  ///Questionario do qual esta pergunta pertence
  Questionario questionario;

  PerguntaTipo tipo;

  Map<String, Requisito> requisitos;

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
    this.referencia,
    this.questionario,
    this.tipo,
    this.requisitos,
    this.escolhas,
    this.ordem,
    this.titulo,
    this.textoMarkdown,
    this.dataCriacao,
    this.dataEdicao,
    this.observacao,
    this.texto,
    this.arquivo,
    this.coordenada,
    this.numero,
  }) : super(id);

  @override
  PerguntaModel fromMap(Map<String, dynamic> map) {
    if (map["questionario"] is Map)
      questionario = Questionario.fromMap(map['questionario']);

    if (map["tipo"] is Map) tipo = PerguntaTipo.fromMap(map['tipo']);

    requisitos = Map<String, Requisito>();
    if (map["requisitos"] is Map) {
      map["requisitos"].forEach((k, v) {
        requisitos[k] = Requisito.fromMap(v);
      });
    }

    referencia = map["referencia"];

    ordem = map['ordem'];

    titulo = map['titulo'];

    textoMarkdown = map['textoMarkdown'];

    observacao = map['observacao'];

    dataCriacao = map['dataCriacao'];

    dataEdicao = map['dataEdicao'];

    /// respostas

    ///escolhas contem as opções possiveis e a informação de quem foi marcado
    escolhas = Map<String, Escolha>();
    if (map["escolhas"] is Map) {
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
      map["requisitos"] = Map<String, dynamic>();
      requisitos.forEach((key, value) {
        if (value != null) map["requisitos"][key] = value.toMap();
      });
    }

    if (escolhas != null) {
      map["escolhas"] = Map<String, dynamic>();
      escolhas.forEach((k, v) {
        map["escolhas"][k] = v.toMap();
      });
    }

    if (referencia != null) map["referencia"] = referencia;

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

  String referencia;

  /// Referencia do questionarioAplicado
  Questionario(this.id, this.nome, {this.referencia});

  Questionario.fromMap(Map<dynamic, dynamic> map) {
    id = map["id"];
    nome = map["nome"];
    referencia = map["referencia"];
  }

  Map<dynamic, dynamic> toMap() {
    final map = Map<dynamic, dynamic>();
    if (id != null) map["id"] = id;
    if (nome != null) map["nome"] = nome;
    if (referencia != null) map["referencia"] = referencia;
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
///"referencia/escolha.id": {
///  "referencia": "PerguntaID->referencia",
///  "perguntaID": "PerguntaID",
///  "perguntaTipo": "PerguntaID->escolha || PerguntaID->texto",
///  "escolha": {
///    "id": "PerguntaID->escolha->uid->key",
///    "marcada": true
///  }
///}
class Requisito {
  String referencia;
  String perguntaID;
  String perguntaTipo;
  EscolhaRequisito escolha;

  Requisito(
      {this.referencia, this.perguntaID, this.perguntaTipo, this.escolha});

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

  EscolhaRequisito({this.id, this.marcada});

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

  Escolha({this.uid, this.key, this.ordem, this.texto, this.marcada});

  Escolha.fromMap(Map<dynamic, dynamic> map) {
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
