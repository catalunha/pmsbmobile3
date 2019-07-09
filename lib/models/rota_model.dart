import 'package:pmsbmibile3/models/base_model.dart';

/// id da rota representa a rota do app
/// exemplo: /administracao/home
class RotaModel extends FirestoreModel{
  static final String collection = "Rota";
  RotaModel(String id):super(id);

  @override
  Map<String, dynamic> toMap() {
    return {"id":this.id};
  }

  @override
  RotaModel fromMap(Map<String, dynamic> map) {
    assert(map['id'] != null);
    id = map['id'];
    return this;
  }
}
