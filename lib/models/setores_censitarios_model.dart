import 'base_model.dart';

class SetorCensitarioModel extends Model{
  static final String collection = "setor_censitario";
  String nome;
  String id;

  SetorCensitarioModel.fromMap(Map<dynamic, dynamic> map){
    id = map["id"] ?? "";
    nome = map["nome"] ?? "";
  }

  Map<dynamic, dynamic> toMao(){
    return {
      "nome":nome,
    };
  }
}