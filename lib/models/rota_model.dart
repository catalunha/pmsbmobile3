import 'package:pmsbmibile3/models/base_model.dart';

class Rota extends FirestoreModel {
  static final String collection = "Eixo";
  String url;

  Rota({String id, this.url}) : super(id);

  Rota fromMap(Map<String, dynamic> map) {
    if (map.containsKey('url')) url = map['url'];
    return this;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (url != null) data['url'] = this.url;
    return data;
  }
}
