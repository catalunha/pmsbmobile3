import 'package:pmsbmibile3/models/base_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';

class UsuarioPerfilModel extends FirestoreModel {
  static final String collection = "UsuarioPerfil";
  UsuarioID usuarioID;
  PerfilID perfilID;
  String textPlain;
  UploadID arquivo;

  UsuarioPerfilModel(
      {String id,
      this.usuarioID,
      this.perfilID,
      this.textPlain,
      this.arquivo})
      : super(id);

  @override
  UsuarioPerfilModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('usuarioID')) {
      usuarioID = map['usuarioID'] != null
          ? new UsuarioID.fromMap(map['usuarioID'])
          : null;
    }
    if (map.containsKey('perfilID')) {
      perfilID = map['perfilID'] != null
          ? new PerfilID.fromMap(map['perfilID'])
          : null;
    }
    if (map.containsKey('textPlain')) textPlain = map['textPlain'];
    if (map.containsKey('arquivo')) {
      arquivo = map['arquivo'] != null
          ? new UploadID.fromMap(map['arquivo'])
          : null;
    }
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.usuarioID != null) {
      data['usuarioID'] = this.usuarioID.toMap();
    }
    if (this.perfilID != null) {
      data['perfilID'] = this.perfilID.toMap();
    }
    if (textPlain != null) data['textPlain'] = this.textPlain;
    if (this.arquivo != null) {
      data['arquivo'] = this.arquivo.toMap();
    }
    return data;
  }
}
