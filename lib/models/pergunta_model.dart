import 'package:pmsbmibile3/models/base_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';
import 'package:pmsbmibile3/models/pergunta_tipo_model.dart';

class PerguntaAplicadaArquivo {
  final bool key = true;
  String nome;
  String uploadID;
  String url;
  String localPath;

  PerguntaAplicadaArquivo({this.uploadID, this.url, this.localPath, this.nome});

  PerguntaAplicadaArquivo.fromMap(Map<dynamic, dynamic> map) {
    nome = map["nome"];
    uploadID = map["uploadID"];
    url = map["url"];
    localPath = map["localPath"];
  }

  Map<dynamic, dynamic> toMap() {
    return {
      "nome": nome,
      "key": key,
      "url": url,
      "localPath": localPath,
      "uploadID": uploadID,
    };
  }
}

class PerguntaAplicadaModel extends PerguntaModel {
  static final String collection = "PerguntaAplicada";

  PerguntaAplicadaModel({
    String id,
    bool temPendencias: true,
    bool foiRespondida: false,
    this.observacao,
    this.numero,
    this.texto,
    Map<String, PerguntaAplicadaArquivo> arquivo,
    List<Coordenada> coordenada,
  })  : _arquivo = arquivo,
        _coordenada = coordenada,
        _temPendencias = temPendencias,
        _foiRespondida = foiRespondida,
        super(id: id);

  bool _temPendencias;

  /// [observacao] é um campo disponivel para informações adicionais durante
  /// a aplicação da pergunta
  String observacao;

  ///Atributos que armazenam as respostos da aplicação das perguntas

  ///No caso de pergunta do tipo Texto a resposta é armazenada no atributo
  ///[texto]
  String texto;

  ///No caso de pergunta do tipo Numero a resposta é armazenada no atributo
  ///[numero]
  num numero;

  ///No caso de pergunta do tipo Arquivo ou Imagem a resposta é armazenada no atributo
  ///[arquivo]
  Map<String, PerguntaAplicadaArquivo> _arquivo;

  Map<String, PerguntaAplicadaArquivo> get arquivo {
    if (_arquivo == null) _arquivo = Map<String, PerguntaAplicadaArquivo>();
    return _arquivo;
  }

  set arquivo(Map<String, PerguntaAplicadaArquivo> arquivos) {
    _arquivo = arquivos;
  }

  ///No caso de pergunta do tipo Coordenada a resposta é armazenada no atributo
  ///[coordenada]
  List<Coordenada> _coordenada;

  set coordenada(List<Coordenada> coordenada) => _coordenada = coordenada;

  List<Coordenada> get coordenada {
    if (_coordenada == null) _coordenada = List<Coordenada>();
    return _coordenada;
  }

  set temPendencias(bool p) {
    _temPendencias = p != null ? p : true;
  }

  bool get temPendencias => _temPendencias != null ? _temPendencias : false;

  bool _foiRespondida;

  set foiRespondida(bool f) {
    _foiRespondida = f != null ? f : false;
  }

  bool get temRespostaValida {
    final tipoEnum = PerguntaTipoModel.ENUM[tipo.id];
    switch (tipoEnum) {
      case PerguntaTipoEnum.Texto:
        return texto != null && texto.isNotEmpty;
      case PerguntaTipoEnum.Imagem:
        return arquivo != null && arquivo.length > 0;
      case PerguntaTipoEnum.Arquivo:
        return arquivo != null && arquivo.length > 0;
      case PerguntaTipoEnum.Numero:
        return numero != null;
      case PerguntaTipoEnum.Coordenada:
        return coordenada != null && coordenada.length > 0;
      case PerguntaTipoEnum.EscolhaUnica:
      case PerguntaTipoEnum.EscolhaMultipla:
        for (var escolha in escolhas.values) {
          if (escolha.marcada) return true;
        }
        return false;
    }
  }

  bool get foiRespondida => _foiRespondida != null ? _foiRespondida : false;

  bool get foiPulada {
    if (foiRespondida) return true;
    return temRespostaValida;
  }

  bool get temRequisitos {
    return requisitos.length > 0;
  }

  bool get referenciasRequitosDefinidas {
    if (!temRequisitos) return false;
    for (var requisito in requisitos.values) {
      if (requisito.perguntaID == null) return false;
    }
    return true;
  }

  @override
  PerguntaAplicadaModel fromMap(Map<String, dynamic> map) {
    temPendencias = map["temPendencias"];
    foiRespondida = map["foiRespondida"];
    observacao = map['observacao'];
    texto = map["texto"];
    numero = map["numero"];

    if (map["arquivo"] is Map) {
      arquivo = Map<String, PerguntaAplicadaArquivo>();
      for (var item in map["arquivo"].entries) {
        arquivo[item.key] = PerguntaAplicadaArquivo.fromMap(item.value);
      }
    }
    if (map["coordenada"] is List) {
      coordenada = List<Coordenada>();
      map["coordenada"].forEach((e) {
        coordenada.add(Coordenada.fromMap(e));
      });
    }

    return super.fromMap(map);
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map["temPendencias"] = temPendencias;
    map["foiRespondida"] = foiRespondida;
    map["observacao"] = observacao;
    if (texto != null) map["texto"] = texto;
    if (numero != null) map["numero"] = numero;
    if (arquivo != null && arquivo is Map){
      map["arquivo"] = Map<String, dynamic>();
      for (var item in arquivo.entries){
        map["arquivo"][item.value.uploadID] = item.value.toMap();
      }
    }
    if (coordenada != null) {
      map["coordenada"] = List<Map<String, dynamic>>();
      coordenada.forEach((e) {
        map["coordenada"].add(e.toMap());
      });
    }
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

  ///Eixo do qual esta pergunta pertence
  //Vamos precisar deste campos pra filtrar perguntas para requisito.
  // EixoID eixo;

  PerguntaTipo tipo;

  Map<String, Requisito> requisitos;

  /// Mapa contendo escolhas
  Map<String, Escolha> escolhas;

  int ordem;

  int ultimaOrdemEscolha;

  String titulo;

  EixoID eixo;

  String textoMarkdown;

  dynamic dataCriacao;

  dynamic dataEdicao;

  PerguntaModel({
    String id,
    this.referencia,
    this.questionario,
    this.tipo,
    this.requisitos,
    this.escolhas,
    this.ordem,
    this.ultimaOrdemEscolha,
    this.titulo,
    this.textoMarkdown,
    this.dataCriacao,
    this.dataEdicao,
    this.eixo,
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
    ultimaOrdemEscolha = map['ultimaOrdemEscolha'];

    titulo = map['titulo'];

    textoMarkdown = map['textoMarkdown'];

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

    if (map.containsKey('eixo')) {
      eixo = map['eixo'] != null ? new EixoID.fromMap(map['eixo']) : null;
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

    if (ultimaOrdemEscolha != null)
      map["ultimaOrdemEscolha"] = ultimaOrdemEscolha;

    if (titulo != null) map["titulo"] = titulo;

    if (textoMarkdown != null) map["textoMarkdown"] = textoMarkdown;

    if (dataCriacao != null) map["dataCriacao"] = dataCriacao;

    if (dataEdicao != null) map["dataEdicao"] = dataEdicao;

    if (this.eixo != null) {
      map['eixo'] = this.eixo.toMap();
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
  Coordenada({this.latitude, this.longitude, this.accuracy, this.altitude});

  double latitude;
  double longitude;
  double accuracy;
  double altitude;

  Coordenada.fromMap(Map<dynamic, dynamic> map) {
    latitude = map["latitude"];
    longitude = map["longitude"];
    accuracy = map["accuracy"];
    altitude = map["altitude"];
  }

  Map<String, dynamic> toMap() {
    return {
      if (latitude != null) "latitude": latitude,
      if (longitude != null) "longitude": longitude,
      if (accuracy != null) "accuracy": accuracy,
      if (altitude != null) "altitude": altitude,
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
  String label;

  Requisito(
      {this.referencia,
      this.perguntaID,
      this.perguntaTipo,
      this.escolha,
      this.label});

  Requisito.fromMap(Map<dynamic, dynamic> map) {
    referencia = map["referencia"];
    perguntaID = map["perguntaID"];
    perguntaTipo = map["perguntaTipo"];
    if (map["escolha"] != null && map["escolha"] is Map)
      escolha = EscolhaRequisito.fromMap(map["escolha"]);
    label = map["label"];
  }

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (referencia != null) map["referencia"] = referencia;
    if (perguntaID != null) map["perguntaID"] = perguntaID;
    if (perguntaTipo != null) map["perguntaTipo"] = perguntaTipo;
    if (escolha != null && escolha is EscolhaRequisito)
      map["escolha"] = escolha.toMap();
    if (label != null) map["label"] = label;
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
  String label;

  EscolhaRequisito({this.id, this.marcada, this.label});

  EscolhaRequisito.fromMap(Map<dynamic, dynamic> map) {
    id = map["id"];
    marcada = map["marcada"];
    label = map["label"];
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) "id": id,
      if (marcada != null) "marcada": marcada,
      if (label != null) "label": label,
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
