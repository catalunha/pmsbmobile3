import 'package:pmsbmibile3/models/base_model.dart';

class UsuarioNoticiaModel extends FirestoreModel {
    static final String collection = "UsuarioNoticia";

  String usuarioID;
  String noticiaID;
  bool visualizada;

  UsuarioNoticiaModel({String id,this.usuarioID, this.noticiaID, this.visualizada}): super(id);

  UsuarioNoticiaModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('usuarioID')) usuarioID = map['usuarioID'];
    if (map.containsKey('noticiaID')) noticiaID = map['noticiaID'];
    if (map.containsKey('visualizada')) visualizada = map['visualizada'];
      return this;

  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (usuarioID != null) data['usuarioID'] = this.usuarioID;
    if (noticiaID != null) data['noticiaID'] = this.noticiaID;
    if (visualizada != null) data['visualizada'] = this.visualizada;
    return data;
  }
}

