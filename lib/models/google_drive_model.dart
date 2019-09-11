import 'package:pmsbmibile3/models/base_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';

class GoogleDriveModel extends FirestoreModel {
  static final String collection = "GoogleDrive";

  /// Representa o ID do arquivo q pode ser um document/spreadsheets/etc dentro do google drive
  String arquivoID;

  /// Criado pela function. Se false a function ainda nao criou o arquvio no gdrive
  bool criado;

  /// Representa o tipo que pode ser document/spreadsheets/etc
  String tipo;

  /// Representa a permissão do link compartilhado null/writer/reader. writer seria produto. reader seria relatorio
  String link;

  /// Map de usuarios com informações para gestão de acesso
  Map<String, UsuarioGoogleDrive> usuario;

  /// Contem informações do usuario deste arquivo do google drive. Após criado o arquivo no google drive retorar o arquivoID para este update.
  UpdateCollection updateCollection;

  GoogleDriveModel(
      {String id,
      this.arquivoID,
      this.criado,
      this.tipo,
      this.link,
      this.usuario,
      this.updateCollection})
      : super(id);

  @override
  GoogleDriveModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('arquivoID')) arquivoID = map['arquivoID'];
    if (map.containsKey('criado')) criado = map['criado'];
    if (map.containsKey('tipo')) tipo = map['tipo'];
    if (map.containsKey('link')) link = map['link'];
    if (map.containsKey('usuario') && map["usuario"] is Map) {
      usuario = Map<String, UsuarioGoogleDrive>();
      for (var item in map["usuario"].entries) {
        usuario[item.key] = UsuarioGoogleDrive.fromMap(item.value);
      }
    }
    if (map.containsKey('updateCollection')) {
      updateCollection = map['updateCollection'] != null
          ? new UpdateCollection.fromMap(map['updateCollection'])
          : null;
    }
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (arquivoID != null) data['arquivoID'] = this.arquivoID;
    if (criado != null) data['criado'] = this.criado;
    if (tipo != null) data['tipo'] = this.tipo;
    if (link != null) data['link'] = this.link;
    if (usuario != null && usuario is Map) {
      data["usuario"] = Map<String, dynamic>();
      for (var item in usuario.entries) {
        data["usuario"][item.key] = item.value.toMap();
      }
    }
    if (this.updateCollection != null) {
      data['updateCollection'] = this.updateCollection.toMap();
    }
    return data;
  }
}
