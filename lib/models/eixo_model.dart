import 'package:pmsbmibile3/models/base_model.dart';

class EixoModel extends FirestoreModel {
  static final String collection = "Eixo";

  String nome;

  EixoModel({String id, this.nome}) : super(id);

  @override
  EixoModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey("nome")) nome = map["nome"];
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (nome != null) data['nome'] = this.nome;
    return data;
  }
}
