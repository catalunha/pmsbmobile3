import 'base_model.dart';

class EixoModel extends Model{
  String nome;
  String id;

  EixoModel.fromMap(Map<dynamic, dynamic> map){
    id = map["id"] ?? "";
    nome = map["nome"] ?? "";
  }

  Map<dynamic, dynamic> toMao(){
    return {
      "name":nome,
    };
  }
}