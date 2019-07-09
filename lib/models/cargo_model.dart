import 'package:pmsbmibile3/models/base_model.dart';

class CargoModel extends FirestoreModel{

  static final String collection = "Cargo";

  String nome;

  CargoModel({this.nome, String id}) : super(id);
  @override
  CargoModel fromMap(Map<String, dynamic> map) {
    if(map.containsKey("id")) id = map['id'];
    if(map.containsKey("nome")) nome = map['nome'];
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    return {"nome":nome};
  }
}