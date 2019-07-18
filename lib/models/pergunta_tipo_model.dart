import 'package:pmsbmibile3/models/base_model.dart';

const NOMES = {
  "Texto": "texto",
  "Imagem": "imagem",
  "Arquivo": "arquivo",
  "Numero": "numero",
  "Coordenada": "coordenada",
  "Escolha Única": "escolhaunica",
  "Escolha Múltipla": "escolhamultipla",
};

const IDS = {
  "texto": "Texto",
  "imagem": "Imagem",
  "arquivo": "Arquivo",
  "numero": "Numero",
  "coordenada": "Coordenada",
  "escolhaunica": "Escolha Única",
  "escolhamultipla": "Escolha Múltipla",
};

class PerguntaTipoModel extends FirestoreModel {
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
      "nome":nome,
    };
  }
}
