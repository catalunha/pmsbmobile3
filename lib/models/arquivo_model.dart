import 'package:pmsbmibile3/models/base_model.dart';

class ArquivoModel extends FirestoreModel{

  static final String collection = "Arquivo";

  String userId;

  String titulo;

  String contentType;

  String storagePath;

  String url;

  ArquivoModel({
    String id,
    this.userId,
    this.titulo,
    this.contentType,
    this.storagePath,
    this.url,
  }) : super(id);

  @override
  ArquivoModel fromMap(Map<String, dynamic> map) {
    if(map.containsKey("id")) id = map["id"];
    if(map.containsKey("userId")) userId = map["userId"];
    if(map.containsKey("titulo")) titulo = map["titulo"];
    if(map.containsKey("contentType")) contentType = map["contentType"];
    if(map.containsKey("storagePath")) storagePath = map["storagePath"];
    if(map.containsKey("url")) url = map["url"];
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "userId":userId,
      "titulo":titulo,
      "contentType":contentType,
      "storagePath":storagePath,
      "url":url,
    };
  }

}