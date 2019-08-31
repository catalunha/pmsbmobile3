import 'package:pmsbmibile3/models/base_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';

class ProdutoModel extends FirestoreModel {
  static final String collection = "Produto";

  String titulo;
  String googleDocsUrl;
  EixoID eixoID;
  SetorCensitarioID setorCensitarioID;
  DateTime modificado;
  UsuarioID usuarioID;
  UploadID pdf;

  ProdutoModel({
    String id,
    this.titulo,
    this.googleDocsUrl,
    this.eixoID,
    this.pdf,
    this.setorCensitarioID,
    this.usuarioID,
    this.modificado,
  }) : super(id);
  @override
  ProdutoModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('titulo')) titulo = map['titulo'];
    if (map.containsKey('googleDocsUrl')) googleDocsUrl = map['googleDocsUrl'];
    if (map.containsKey('pdf')) {
      pdf = map['pdf'] != null ? new UploadID.fromMap(map['pdf']) : null;
    }

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

    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (titulo != null) data['titulo'] = this.titulo;
    if (googleDocsUrl != null) data['googleDocsUrl'] = this.googleDocsUrl;
    if (this.eixoID != null) {
      data['eixoID'] = this.eixoID.toMap();
    }
    if (this.pdf != null) {
      data['pdf'] = this.pdf.toMap();
    }

    if (this.setorCensitarioID != null) {
      data['setorCensitarioID'] = this.setorCensitarioID.toMap();
    }
    if (this.usuarioID != null) {
      data['usuarioID'] = this.usuarioID.toMap();
    }
    if (modificado != null) data['modificado'] = this.modificado.toUtc();
    return data;
  }
}
