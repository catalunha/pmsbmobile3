import 'package:pmsbmibile3/models/base_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';

class UploadModel extends FirestoreModel {
  static final String collection = "Upload";
  String usuario;
  String nome;
  String localPath;
  bool upload;
  String storagePath;
  String contentType;
  String url;
  String hash;
  UpdateCollection updateCollection;

  UploadModel(
      {String id,
      this.usuario,
      this.nome,
      this.localPath,
      this.upload,
      this.storagePath,
      this.contentType,
      this.url,
      this.hash,
      this.updateCollection})
      : super(id);

  @override
  UploadModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('usuario')) usuario = map['usuario'];
    if (map.containsKey('nome')) nome = map['nome'];
    if (map.containsKey('localPath')) localPath = map['localPath'];
    if (map.containsKey('upload')) upload = map['upload'];
    if (map.containsKey('storagePath')) storagePath = map['storagePath'];
    if (map.containsKey('contentType')) contentType = map['contentType'];
    if (map.containsKey('url')) url = map['url'];
    if (map.containsKey('hash')) hash = map['hash'];
    if (map.containsKey('updateCollection')) {
      updateCollection = map['updateCollection'] != null
          ? new UpdateCollection.fromMap(map['updateCollection'])
          : null;
    }
    return this;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (usuario != null) data['usuario'] = this.usuario;
    if (nome != null) data['nome'] = this.nome;
    if (localPath != null) data['localPath'] = this.localPath;
    if (upload != null) data['upload'] = this.upload;
    if (storagePath != null) data['storagePath'] = this.storagePath;
    if (contentType != null) data['contentType'] = this.contentType;
    if (url != null) data['url'] = this.url;
    if (hash != null) data['hash'] = this.hash;
    if (this.updateCollection != null) {
      data['updateCollection'] = this.updateCollection.toMap();
    }
    return data;
  }
}
