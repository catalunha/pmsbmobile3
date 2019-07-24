import 'package:pmsbmibile3/models/base_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';

class ProdutoModel extends FirestoreModel {
  static final String collection = "Produto";

  String nome;
  String textoMarkdownID;
  EixoID eixoID;
  DateTime modificado;
  SetorCensitarioID setorCensitarioID;
  UsuarioID usuarioID;
  Map<String, ArquivoProduto> arquivo;

  ProdutoModel({
    String id,
    this.nome,
    this.textoMarkdownID,
    this.eixoID,
    this.setorCensitarioID,
    this.usuarioID,
    this.modificado,
    this.arquivo,
  }) : super(id);
  @override
  ProdutoModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('nome')) nome = map['nome'];
    if (map.containsKey('textoMarkdownID'))
      textoMarkdownID = map['textoMarkdownID'];
    if (map.containsKey('eixoID')) {
      eixoID = map['eixoID'] != null ? new EixoID.fromMap(map['eixoID']) : null;
    }
    if (map.containsKey('setorCensitarioID')) {
      setorCensitarioID = map['setorCensitarioID'] != null
          ? new SetorCensitarioID.fromMap(map['setorCensitarioID'])
          : null;
    }
    if (map.containsKey('usuarioID')) {
      usuarioID = map['usuarioID'] != null
          ? new UsuarioID.fromMap(map['usuarioID'])
          : null;
    }
    if (map.containsKey('modificado')) modificado = map['modificado'].toDate();
    if (map["arquivo"] is Map) {
      arquivo = Map<String, ArquivoProduto>();
      map["arquivo"].forEach((k, v) {
        arquivo[k] = ArquivoProduto.fromMap(v);
      });
    }
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (textoMarkdownID != null) data['textoMarkdownID'] = this.textoMarkdownID;
    if (nome != null) data['nome'] = this.nome;
    if (this.eixoID != null) {
      data['eixoID'] = this.eixoID.toMap();
    }
    if (this.setorCensitarioID != null) {
      data['setorCensitarioID'] = this.setorCensitarioID.toMap();
    }
    if (this.usuarioID != null) {
      data['usuarioID'] = this.usuarioID.toMap();
    }
    if (modificado != null) data['modificado'] = this.modificado.toUtc();
    if (arquivo != null) {
      data["arquivo"] = Map<String, Map<String, dynamic>>();
      arquivo.forEach((key, value) {
        if (value != null) data["arquivo"][key] = value.toMap();
      });
    }
    return data;
  }
}

