import 'package:pmsbmibile3/models/base_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';

class UsuarioPerfilModel extends FirestoreModel {
  static final String collection = "UsuarioPerfil";
  UsuarioID usuarioID;
  PerfilID perfilID;
  String textPlain;
  UsuarioArquivoID usuarioArquivoID;

  UsuarioPerfilModel(
      {String id,
      this.usuarioID,
      this.perfilID,
      this.textPlain,
      this.usuarioArquivoID})
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
    if (map.containsKey('usuarioArquivoID')) {
      usuarioArquivoID = map['usuarioArquivoID'] != null
          ? new UsuarioArquivoID.fromMap(map['usuarioArquivoID'])
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
    if (this.usuarioArquivoID != null) {
      data['usuarioArquivoID'] = this.usuarioArquivoID.toMap();
    }
    return data;
  }
}
