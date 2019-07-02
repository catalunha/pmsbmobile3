import 'package:pmsbmibile3/models/base_model.dart';

class SetorCensitarioModel extends FirestoreModel{

  static final String collection = "SetorCensitario";

  String nome;

  String setorSuperiorId;

  SetorCensitarioModel({this.nome, this.setorSuperiorId, String id}) : super(id);

  @override
  SetorCensitarioModel fromMap(Map<String, dynamic> map) {
    if(map.containsKey("id")) id = map['id'];
    if(map.containsKey("nome")) nome = map["nome"];
    if(map.containsKey("setorSuperiorId")) setorSuperiorId = map["setorSuperiorId"];
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    return {"nome":nome, "setorSuperiorId":setorSuperiorId};
  }
}

