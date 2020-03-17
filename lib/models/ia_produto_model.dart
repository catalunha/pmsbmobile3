import 'package:pmsbmibile3/models/base_model.dart';

class IAProdutoModel extends FirestoreModel {
  static final String collection = "IAProduto";
  int numero;
  String indice;
  String titulo;
  String subtitulo;
  String itensTotal;
  String itensSim;
  String itensParcial;
  String itensNao;

  IAProdutoModel({
    String id,
    this.numero,
    this.indice,
    this.titulo,
    this.subtitulo,
    this.itensTotal,
    this.itensSim,
    this.itensParcial,
    this.itensNao,
  }) : super(id);

  @override
  IAProdutoModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('numero')) numero = map['numero'];
    if (map.containsKey('indice')) indice = map['indice'];
    if (map.containsKey('titulo')) titulo = map['titulo'];
    if (map.containsKey('subtitulo')) subtitulo = map['subtitulo'];
    if (map.containsKey('itensTotal')) itensTotal = map['itensTotal'];
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
    if (titulo != null) data['titulo'] = this.titulo;
    if (subtitulo != null) data['subtitulo'] = this.subtitulo;
    if (itensTotal != null) data['itensTotal'] = this.itensTotal;
    if (itensSim != null) data['itensSim'] = this.itensSim;
    if (itensParcial != null) data['itensParcial'] = this.itensParcial;
    if (itensNao != null) data['itensNao'] = this.itensNao;

    return data;
  }
}
