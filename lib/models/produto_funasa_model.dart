// import 'package:validators/validators.dart';
import 'package:pmsbmibile3/models/base_model.dart';

class ProdutoFunasaModel extends FirestoreModel {
  static final String collection = "ProdutoFunasa";

  String nome;
  String descricao;

  ProdutoFunasaModel({
    String id,
    this.nome,
    this.descricao,
  }) : super(id);

  ProdutoFunasaModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('nome')) nome = map['nome'];
    if (map.containsKey('descricao')) descricao = map['descricao'];

    return this;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (nome != null) data['nome'] = this.nome;
    if (descricao != null) data['descricao'] = this.descricao;
    return data;
  }
}
