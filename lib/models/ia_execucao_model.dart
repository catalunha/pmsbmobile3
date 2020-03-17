import 'package:pmsbmibile3/models/base_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';

class IAExecucaoModel extends FirestoreModel {
  static final String collection = "IAExecucao";
  int numero;
  String meta;
  String produto;
  String descricao;
  String previsto;
  String executado;
  String documento;
  String observacao;

  Map<String, Celula> celula;

  IAExecucaoModel({
    String id,
    this.numero,
    this.meta,
    this.produto,
    this.descricao,
    this.previsto,
    this.executado,
    this.documento,
    this.observacao,
    this.celula,
  }) : super(id);

  @override
  IAExecucaoModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('numero')) numero = map['numero'];
    if (map.containsKey('meta')) meta = map['meta'];
    if (map.containsKey('produto')) produto = map['produto'];
    if (map.containsKey('descricao')) descricao = map['descricao'];
    if (map.containsKey('previsto')) previsto = map['previsto'];
    if (map.containsKey('executado')) executado = map['executado'];
    if (map.containsKey('documento')) documento = map['documento'];
    if (map.containsKey('observacao')) observacao = map['observacao'];

    if (map["celula"] is Map) {
      celula = Map<String, Celula>();
      for (var item in map["celula"].entries) {
        celula[item.key] = Celula.fromMap(item.value);
      }
    }
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (numero != null) data['numero'] = this.numero;
    if (meta != null) data['meta'] = this.meta;
    if (produto != null) data['produto'] = this.produto;
    if (descricao != null) data['descricao'] = this.descricao;
    if (previsto != null) data['previsto'] = this.previsto;
    if (executado != null) data['executado'] = this.executado;
    if (documento != null) data['documento'] = this.documento;
    if (observacao != null) data['observacao'] = this.observacao;

    if (celula != null && celula is Map) {
      data["celula"] = Map<String, dynamic>();
      for (var item in celula.entries) {
        data["celula"][item.key] = item.value.toMap();
      }
    }
    return data;
  }
}
