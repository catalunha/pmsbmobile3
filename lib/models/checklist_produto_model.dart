import 'package:pmsbmibile3/models/base_model.dart';

class ChecklistProdutoModel extends FirestoreModel {
  static final String collection = "ChecklistProduto";
  int numero;
  String indice;
  String descricao;
  String linhaPlanilhaProduto;
  String linhaPlanilhaTotal;
  int itensSim;
  int itensParcial;
  int itensNao;

  ChecklistProdutoModel({
    String id,
    this.numero,
    this.indice,
    this.descricao,
    this.linhaPlanilhaProduto,
    this.linhaPlanilhaTotal,
    this.itensSim,
    this.itensParcial,
    this.itensNao,
  }) : super(id);

  @override
  ChecklistProdutoModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('numero')) numero = map['numero'];
    if (map.containsKey('indice')) indice = map['indice'];
    if (map.containsKey('descricao')) descricao = map['descricao'];
    if (map.containsKey('linhaPlanilhaProduto')) linhaPlanilhaProduto = map['linhaPlanilhaProduto'];
    if (map.containsKey('linhaPlanilhaTotal')) linhaPlanilhaTotal = map['linhaPlanilhaTotal'];
    if (map.containsKey('itensSim')) itensSim = map['itensSim'];
    if (map.containsKey('itensParcial')) itensParcial = map['itensParcial'];
    if (map.containsKey('itensNao')) itensNao = map['itensNao'];

    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (numero != null) data['numero'] = this.numero;
    if (indice != null) data['indice'] = this.indice;
    if (descricao != null) data['descricao'] = this.descricao;
    if (linhaPlanilhaProduto != null) data['linhaPlanilhaProduto'] = this.linhaPlanilhaProduto;
    if (linhaPlanilhaTotal != null) data['linhaPlanilhaTotal'] = this.linhaPlanilhaTotal;
    if (itensSim != null) data['itensSim'] = this.itensSim;
    if (itensParcial != null) data['itensParcial'] = this.itensParcial;
    if (itensNao != null) data['itensNao'] = this.itensNao;

    return data;
  }
}
