// import 'package:validators/validators.dart';
import 'package:pmsbmibile3/models/base_model.dart';

class Painel extends FirestoreModel {
  static final String collection = "Painel";
  String nome;
  /// Os tipos pode ser: texto | numero | booleano | urlimagem | urlarquivo
  String tipo;

  Painel({String id, this.nome, this.tipo}) : super(id);

  Painel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('nome')) nome = map['nome'];
    if (map.containsKey('tipo')) tipo = map['tipo'];
    return this;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (nome != null) data['nome'] = this.nome;
    if (tipo != null) data['tipo'] = this.tipo;
    return data;
  }
}
