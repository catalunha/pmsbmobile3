import 'package:pmsbmibile3/models/base_model.dart';

class UsuarioArquivoModel extends FirestoreModel {
  static final String collection = "UsuarioArquivo";

  String usuarioID;
  String titulo;
  String referencia;
  String contentType;
  String storagePath;
  String url;

  UsuarioArquivoModel({
    String id,
    this.usuarioID,
    this.titulo,
    this.referencia,
    this.contentType,
    this.storagePath,
    this.url,
  }) : super(id);

  @override
  UsuarioArquivoModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey("id")) id = map["id"];
    if (map.containsKey("usuarioID")) usuarioID = map["usuarioID"];
    if (map.containsKey("titulo")) titulo = map["titulo"];
    if (map.containsKey("referencia")) referencia = map["referencia"];
    if (map.containsKey("contentType")) contentType = map["contentType"];
    if (map.containsKey("storagePath")) storagePath = map["storagePath"];
    if (map.containsKey("url")) url = map["url"];
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "usuarioID": usuarioID,
      "titulo": titulo,
      "referencia": referencia,
      "contentType": contentType,
      "storagePath": storagePath,
      "url": url,
    };
  }
}
