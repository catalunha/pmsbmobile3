import 'package:pmsbmibile3/models/base_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';

class EixoArquivoModel extends FirestoreModel {
  static final String collection = "EixoArquivo";

  ProdutoID produtoID;
  String titulo;
  String referencia;
  String contentType;
  String storagePath;
  String url;

  EixoArquivoModel(
      {String id,
      this.produtoID,
      this.titulo,
      this.referencia,
      this.contentType,
      this.storagePath,
      this.url})
      : super(id);

  @override
  EixoArquivoModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('produtoID')) {
      produtoID = map['produtoID'] != null
          ? new ProdutoID.fromMap(map['produtoID'])
          : null;
    }
    if (map.containsKey('titulo')) titulo = map['titulo'];
    if (map.containsKey('referencia')) referencia = map['referencia'];
    if (map.containsKey('contentType')) contentType = map['contentType'];
    if (map.containsKey('storagePath')) storagePath = map['storagePath'];
    if (map.containsKey('url')) url = map['url'];
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.produtoID != null) {
      data['produtoID'] = this.produtoID.toMap();
    }
    if (titulo != null) data['titulo'] = this.titulo;
    if (referencia != null) data['referencia'] = this.referencia;
    if (contentType != null) data['contentType'] = this.contentType;
    if (storagePath != null) data['storagePath'] = this.storagePath;
    if (url != null) data['url'] = this.url;
    return data;
  }
}
