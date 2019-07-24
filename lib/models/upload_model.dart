import 'package:pmsbmibile3/models/base_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';

class UploadModel extends FirestoreModel {
  static final String collection = "Upload";
  UsuarioID usuarioID;
  String hash;
  String localPath;
  bool upload;
  String storagePath;
  String url;
  String atualizar;

  UploadModel(
      {String id,
      this.usuarioID,
      this.hash,
      this.localPath,
      this.upload,
      this.storagePath,
      this.url,
      this.atualizar})
      : super(id);

  UploadModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('usuarioID')) {
      usuarioID = map['usuarioID'] != null
          ? new UsuarioID.fromMap(map['usuarioID'])
          : null;
    }
    if (map.containsKey('hash')) hash = map['hash'];
    if (map.containsKey('localPath')) localPath = map['localPath'];
    if (map.containsKey('upload')) upload = map['upload'];
    if (map.containsKey('storagePath')) storagePath = map['storagePath'];
    if (map.containsKey('url')) url = map['url'];
    if (map.containsKey('atualizar')) atualizar = map['atualizar'];
    return this;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.usuarioID != null) {
      data['usuarioID'] = this.usuarioID.toMap();
    }
    if (hash != null) data['hash'] = this.hash;
    if (localPath != null) data['localPath'] = this.localPath;
    if (upload != null) data['upload'] = this.upload;
    if (storagePath != null) data['storagePath'] = this.storagePath;
    if (url != null) data['url'] = this.url;
    if (atualizar != null) data['atualizar'] = this.atualizar;
    return data;
  }
}
