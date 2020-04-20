import 'package:pmsbmibile3/models/base_model.dart';

class ChecklistItemModel extends FirestoreModel {
  static final String collection = "ChecklistItem";

  String checkListProdutoId;
  int numero;
  String indice;
  String descricao;
  int linhaPlanilhaItem;

  ChecklistItemModel({
    String id,
    this.checkListProdutoId,
    this.numero,
    this.indice,
    this.descricao,
    this.linhaPlanilhaItem,
  }) : super(id);

  @override
  ChecklistItemModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('checkListProdutoId'))
      checkListProdutoId = map['checkListProdutoId'];
    if (map.containsKey('numero')) numero = map['numero'];
    if (map.containsKey('indice')) indice = map['indice'];
    if (map.containsKey('descricao')) descricao = map['descricao'];
    if (map.containsKey('linhaPlanilhaItem'))
      linhaPlanilhaItem = map['linhaPlanilhaItem'];
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (checkListProdutoId != null)
      data['checkListProdutoId'] = this.checkListProdutoId;
    if (numero != null) data['numero'] = this.numero;
    if (indice != null) data['indice'] = this.indice;
    if (descricao != null) data['descricao'] = this.descricao;
    if (linhaPlanilhaItem != null)
      data['linhaPlanilhaItem'] = this.linhaPlanilhaItem;

    return data;
  }
}
