import 'package:pmsbmibile3/models/base_model.dart';

class ArquivoUsuarioModel extends Model{
  String id;
  String userId;
  String url;
  String storagePath;
  String titulo;
  String contentType;

  ArquivoUsuarioModel({
    this.id,
    this.userId,
    this.url,
    this.storagePath,
    this.titulo,
    this.contentType,
  });

  ArquivoUsuarioModel.fromMap(Map<String, dynamic> map){
    ArquivoUsuarioModel(
      id: map['id'],
      userId: map['userId'],
      url: map['url'],
      storagePath: map['storagePath'],
      titulo: map['titulo'],
      contentType: map['contentType']
    );
  }

  Map<String, dynamic> toMap(){
    return {
      "userId":userId,
      "url":url,
      "storagePath":storagePath,
      "titulo":titulo,
      "contentType":contentType,
    };
  }
  String toString(){
    return "<$id, $storagePath>";
  }
}
