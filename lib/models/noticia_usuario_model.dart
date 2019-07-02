import 'package:pmsbmibile3/models/base_model.dart';

class NoticiaUsuarioModel extends FirestoreModel{
  static final String collection = "NoticiaUsuario";

  String userId;
  String noticiaId;
  bool visualizada;

  //campos duplicados
  String titulo;
  String numero;
  DateTime dataPublicacao;

  NoticiaUsuarioModel({
    String id,
    this.userId,
    this.noticiaId,
    this.titulo,
    this.numero,
    this.dataPublicacao,
    this.visualizada,
  }) : super(id);

  @override
  NoticiaUsuarioModel fromMap(Map<String, dynamic> map) {
    if(map.containsKey("id")) id = map["id"];
    if(map.containsKey("userId")) userId = map["userId"];
    if(map.containsKey("noticiaId")) noticiaId = map["noticiaId"];
    if(map.containsKey("titulo")) titulo = map["titulo"];
    if(map.containsKey("numero")) numero = map["numero"];
    if(map.containsKey("visualizada")) numero = map["visualizada"];
    if(map.containsKey("dataPublicacao")) dataPublicacao = map["dataPublicacao"];
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "userId":userId,
      "noticiaId":noticiaId,
      "titulo":titulo,
      "numero":numero,
      "visualizada":visualizada,
      "dataPublicacao":dataPublicacao,
    };
  }
}