import 'package:pmsbmibile3/models/base_model.dart';

class IAItemModel extends FirestoreModel {
  static final String collection = "IAItens";

  String iaprodutoId;
  int numero;
  String indice;
  String descricao;
  String atendeTR;
  String cor;
  String documento;
  String observacoes;
  // String requisito; // Se null=faz perg automaticamente. Se id= tem ligação
  // String requisitoAtendeTR; // valor do atendeTR no red ou busca ?
  // List<String> requisitoStatus; // [s|p|n]

  IAItemModel({
    String id,
    this.iaprodutoId,
    this.numero,
    this.indice,
    this.descricao,
    this.atendeTR,
    this.cor,
    this.documento,
    this.observacoes,
    // this.requisito,
    // this.requisitoAtendeTR,
    // this.requisitoStatus,
  }) : super(id);

  @override
  IAItemModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('iaprodutoId')) iaprodutoId = map['iaprodutoId'];
    if (map.containsKey('numero')) numero = map['numero'];
    if (map.containsKey('indice')) indice = map['indice'];
    if (map.containsKey('descricao')) descricao = map['descricao'];
    if (map.containsKey('atendeTR')) atendeTR = map['atendeTR'];
    if (map.containsKey('cor')) cor = map['cor'];
    if (map.containsKey('documento')) documento = map['documento'];
    if (map.containsKey('observacoes')) observacoes = map['observacoes'];
    // if (map.containsKey('requisito')) requisito = map['requisito'];
    // if (map.containsKey('requisitoAtendeTR')) requisitoAtendeTR = map['requisitoAtendeTR'];
    // if (map.containsKey('requisitoStatus')) requisitoStatus = map['requisitoStatus'];

    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (iaprodutoId != null) data['iaprodutoId'] = this.iaprodutoId;
    if (numero != null) data['numero'] = this.numero;
    if (indice != null) data['indice'] = this.indice;
    if (descricao != null) data['descricao'] = this.descricao;
    if (atendeTR != null) data['atendeTR'] = this.atendeTR;
    if (cor != null) data['cor'] = this.cor;
    if (documento != null) data['documento'] = this.documento;
    if (observacoes != null) data['observacoes'] = this.observacoes;
    // if (requisito != null) data['requisito'] = this.requisito;
    // if (requisitoAtendeTR != null) data['requisitoAtendeTR'] = this.requisitoAtendeTR;
    // if (requisitoStatus != null) data['requisitoStatus'] = this.requisitoStatus;

    return data;
  }
}
