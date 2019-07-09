import 'package:pmsbmibile3/models/base_model.dart';

class AdministradorVariavelModel extends FirestoreModel{
  static final String collection = "administrador_variaveis";
  String nome;
  String tipo;

  AdministradorVariavelModel({String id, this.nome, this.tipo}) : super(id);

  @override
  AdministradorVariavelModel fromMap(Map<String, dynamic> map) {
    if(map.containsKey("nome")) nome = map['nome'];
    if(map.containsKey("tipo")) tipo = map['tipo'];
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "nome":nome,
      "tipo":tipo,
    };
  }
}