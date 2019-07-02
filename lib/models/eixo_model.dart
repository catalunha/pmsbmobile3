import 'package:pmsbmibile3/models/base_model.dart';

class EixoModel extends FirestoreModel{

  static final String collection = "Eixo";

  String nome;

  EixoModel({String id, this.nome}) : super(id);


  @override
  Map<String, dynamic> toMap() {
    return {"nome":nome,};
  }
  @override
  EixoModel fromMap(Map<String, dynamic> map) {
    if(map.containsKey("id")) id = map["id"];
    if(map.containsKey("nome")) nome = map["nome"];
    return this;
  }
}
