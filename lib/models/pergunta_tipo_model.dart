import 'package:pmsbmibile3/models/base_model.dart';

enum PerguntaTipoEnum {
  Texto,
  Imagem,
  Arquivo,
  Numero,
  Coordenada,
  EscolhaUnica,
  EscolhaMultipla
}

class PerguntaTipoModel extends FirestoreModel {
  static const ENUM = {
    "texto": PerguntaTipoEnum.Texto,
    "imagem": PerguntaTipoEnum.Imagem,
    "arquivo": PerguntaTipoEnum.Arquivo,
    "numero": PerguntaTipoEnum.Numero,
    "coordenada": PerguntaTipoEnum.Coordenada,
    "escolhaunica": PerguntaTipoEnum.EscolhaUnica,
    "escolhamultipla": PerguntaTipoEnum.EscolhaMultipla,
  };

  static const IDS = {
    PerguntaTipoEnum.Texto: "texto",
    PerguntaTipoEnum.Imagem: "imagem",
    PerguntaTipoEnum.Arquivo: "arquivo",
    PerguntaTipoEnum.Numero: "numero",
    PerguntaTipoEnum.Coordenada: "coordenada",
    PerguntaTipoEnum.EscolhaUnica: "escolhaunica",
    PerguntaTipoEnum.EscolhaMultipla: "escolhamultipla",
  };

  static const NOMES = {
    PerguntaTipoEnum.Texto: "Texto",
    PerguntaTipoEnum.Imagem: "Imagem",
    PerguntaTipoEnum.Arquivo: "Arquivo",
    PerguntaTipoEnum.Numero: "Numero",
    PerguntaTipoEnum.Coordenada: "Coordenada",
    PerguntaTipoEnum.EscolhaUnica: "Escolha Única",
    PerguntaTipoEnum.EscolhaMultipla: "Escolha Múltipla",
  };

  String nome;
  String id;

  PerguntaTipoModel({String id, this.nome}) : super(id);

  @override
  FirestoreModel fromMap(Map<String, dynamic> map) {
    nome = map["nome"];
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "nome": nome,
    };
  }
}
