import 'package:pmsbmibile3/models/base_model.dart';

class RelatorioPdfMakeModel extends FirestoreModel {
  static final String collectionFirestore = "RelatorioPdfMake";
  String collection;
  String document;
  String tipo;
  String url;
  bool pdfGerar;
  bool pdfGerado;
  
  RelatorioPdfMakeModel({String id}) : super(id);

  @override
  RelatorioPdfMakeModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey("collection")) collection = map["collection"];
    if (map.containsKey("document")) document = map["document"];
    if (map.containsKey("tipo")) tipo = map["tipo"];
    if (map.containsKey("url")) url = map["url"];
    if (map.containsKey("pdfGerar")) pdfGerar = map["pdfGerar"];
    if (map.containsKey("pdfGerado")) pdfGerado = map["pdfGerado"];
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (collection != null) data['collection'] = this.collection;
    if (document != null) data['document'] = this.document;
    if (tipo != null) data['tipo'] = this.tipo;
    if (url != null) data['url'] = this.url;
    if (pdfGerar != null) data['pdfGerar'] = this.pdfGerar;
    if (pdfGerado != null) data['pdfGerado'] = this.pdfGerado;
    return data;
  }
}
