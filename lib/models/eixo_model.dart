import 'package:pmsbmibile3/models/base_model.dart';

class EixoModel extends FirestoreModel {
  static final String collection = "Eixo";

  String nome;
  int ultimaOrdemQuestionario;

  EixoModel({String id, this.nome,this.ultimaOrdemQuestionario}) : super(id);

  @override
  EixoModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey("nome")) nome = map["nome"];
    if (map.containsKey("ultimaOrdemQuestionario")) ultimaOrdemQuestionario = map["ultimaOrdemQuestionario"];
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (nome != null) data['nome'] = this.nome;
    if (ultimaOrdemQuestionario != null) data['ultimaOrdemQuestionario'] = this.ultimaOrdemQuestionario;
    return data;
  }
}
