import 'package:pmsbmibile3/bootstrap.dart';

///Trata da gestão de acesso dos usuarios ao google drive
class UsuarioGoogleDrive {
  /// se False a function nao criou acesso ou foi alterado o tipo
  bool atualizar;

  /// Codigo da permissao de acesso daquele usuario aquele arquivo no google drive
  String permissaoID;

  /// Pode ser escrever/comentar/ler se null o acesso do usuario será retirado.
  String tipo;

  UsuarioGoogleDrive({this.atualizar, this.permissaoID, this.tipo});

  UsuarioGoogleDrive.fromMap(Map<dynamic, dynamic> map) {
    if (map.containsKey('atualizar')) atualizar = map['atualizar'];
    if (map.containsKey('permissaoID')) permissaoID = map['permissaoID'];
    if (map.containsKey('tipo')) tipo = map['tipo'];
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (atualizar != null) data['atualizar'] = this.atualizar;
    if (permissaoID != null) data['permissaoID'] = this.permissaoID;
    if (tipo != null) data['tipo'] = this.tipo;
    return data;
  }

  Map<dynamic, dynamic> toMapFirestore() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['atualizar'] =
        this.atualizar ?? Bootstrap.instance.FieldValue.delete();
    data['permissaoID'] =
        this.permissaoID ?? Bootstrap.instance.FieldValue.delete();
    data['tipo'] = this.tipo ?? Bootstrap.instance.FieldValue.delete();
    return data;
  }
}

class GoogleDriveID {
  String id;
  String arquivoID;
  String tipo;
  
  String url(){
    return 'https://docs.google.com/${tipo}/d/${arquivoID}';
  }

  GoogleDriveID({this.id, this.arquivoID, this.tipo});

  GoogleDriveID.fromMap(Map<dynamic, dynamic> map) {
    if (map.containsKey('id')) id = map['id'];
    if (map.containsKey('arquivoID')) arquivoID = map['arquivoID'];
    if (map.containsKey('tipo')) tipo = map['tipo'];
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (id != null) data['id'] = this.id;
    if (arquivoID != null) data['arquivoID'] = this.arquivoID;
    if (tipo != null) data['tipo'] = this.tipo;
    return data;
  }

  Map<dynamic, dynamic> toMapFirestore() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id ?? Bootstrap.instance.FieldValue.delete();
    data['arquivoID'] = this.arquivoID ?? Bootstrap.instance.FieldValue.delete();
    data['tipo'] =
        this.tipo ?? Bootstrap.instance.FieldValue.delete();
    return data;
  }
}

class UploadID {
  String uploadID;
  String url;
  String localPath;

  UploadID({this.uploadID, this.url, this.localPath});

  UploadID.fromMap(Map<dynamic, dynamic> map) {
    if (map.containsKey('uploadID')) uploadID = map['uploadID'];
    if (map.containsKey('url')) url = map['url'];
    if (map.containsKey('localPath')) localPath = map['localPath'];
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (uploadID != null) data['uploadID'] = this.uploadID;
    if (url != null) data['url'] = this.url;
    if (localPath != null) data['localPath'] = this.localPath;
    return data;
  }

  Map<dynamic, dynamic> toMapFirestore() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['uploadID'] = this.uploadID ?? Bootstrap.instance.FieldValue.delete();
    data['url'] = this.url ?? Bootstrap.instance.FieldValue.delete();
    data['localPath'] =
        this.localPath ?? Bootstrap.instance.FieldValue.delete();
    return data;
  }
}

class ArquivoProduto {
  // String id;
  String titulo;
  String tipo;
  String rascunhoIdUpload;
  String rascunhoUrl;
  String rascunhoLocalPath;
  String editadoIdUpload;
  String editadoUrl;
  String editadoLocalPath;

  ArquivoProduto(
      {
      // this.id,
      this.titulo,
      this.tipo,
      this.rascunhoIdUpload,
      this.rascunhoUrl,
      this.rascunhoLocalPath,
      this.editadoIdUpload,
      this.editadoUrl,
      this.editadoLocalPath});

  ArquivoProduto.fromMap(Map<dynamic, dynamic> map) {
    // if (map.containsKey('id')) id = map['id'];
    if (map.containsKey('titulo')) titulo = map['titulo'];
    if (map.containsKey('tipo')) tipo = map['tipo'];
    if (map.containsKey('rascunhoIdUpload'))
      rascunhoIdUpload = map['rascunhoIdUpload'];
    if (map.containsKey('rascunhoUrl')) rascunhoUrl = map['rascunhoUrl'];
    if (map.containsKey('rascunhoLocalPath'))
      rascunhoLocalPath = map['rascunhoLocalPath'];
    if (map.containsKey('editadoIdUpload'))
      editadoIdUpload = map['editadoIdUpload'];
    if (map.containsKey('editadoUrl')) editadoUrl = map['editadoUrl'];
    if (map.containsKey('editadoLocalPath'))
      editadoLocalPath = map['editadoLocalPath'];
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    // if (id != null) data['id'] = this.id;
    if (titulo != null) data['titulo'] = this.titulo;
    if (tipo != null) data['tipo'] = this.tipo;
    if (rascunhoIdUpload != null)
      data['rascunhoIdUpload'] = this.rascunhoIdUpload;
    if (rascunhoUrl != null) data['rascunhoUrl'] = this.rascunhoUrl;
    if (rascunhoLocalPath != null)
      data['rascunhoLocalPath'] = this.rascunhoLocalPath;
    if (editadoIdUpload != null) data['editadoIdUpload'] = this.editadoIdUpload;
    if (editadoUrl != null) data['editadoUrl'] = this.editadoUrl;
    if (editadoLocalPath != null)
      data['editadoLocalPath'] = this.editadoLocalPath;
    return data;
  }

  Map<dynamic, dynamic> toMapFirestore() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    // data['id'] = this.id ?? Bootstrap.instance.FieldValue.delete();
    data['titulo'] = this.titulo ?? Bootstrap.instance.FieldValue.delete();
    data['tipo'] = this.tipo ?? Bootstrap.instance.FieldValue.delete();
    data['rascunhoIdUpload'] =
        this.rascunhoIdUpload ?? Bootstrap.instance.FieldValue.delete();
    data['rascunhoUrl'] =
        this.rascunhoUrl ?? Bootstrap.instance.FieldValue.delete();
    data['rascunhoLocalPath'] =
        this.rascunhoLocalPath ?? Bootstrap.instance.FieldValue.delete();
    data['editadoIdUpload'] =
        this.editadoIdUpload ?? Bootstrap.instance.FieldValue.delete();
    data['editadoUrl'] =
        this.editadoUrl ?? Bootstrap.instance.FieldValue.delete();
    data['editadoLocalPath'] =
        this.editadoLocalPath ?? Bootstrap.instance.FieldValue.delete();
    return data;
  }
}

class UpdateCollection {
  String collection;
  String document;
  String field;

  UpdateCollection({this.collection, this.document, this.field});

  UpdateCollection.fromMap(Map<dynamic, dynamic> map) {
    if (map.containsKey('collection')) collection = map['collection'];
    if (map.containsKey('document')) document = map['document'];
    if (map.containsKey('field')) field = map['field'];
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (collection != null) data['collection'] = this.collection;
    if (document != null) data['document'] = this.document;
    if (field != null) data['field'] = this.field;
    return data;
  }
}

class RotaID {
  String id;
  String url;

  RotaID({this.id, this.url});

  RotaID.fromMap(Map<dynamic, dynamic> map) {
    if (map.containsKey('id')) id = map['id'];
    if (map.containsKey('url')) url = map['url'];
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (id != null) data['id'] = this.id;
    if (url != null) data['url'] = this.url;
    return data;
  }
}

class ProdutoID {
  String id;
  String titulo;

  ProdutoID({this.id, this.titulo});

  ProdutoID.fromMap(Map<dynamic, dynamic> map) {
    if (map.containsKey('id')) id = map['id'];
    if (map.containsKey('titulo')) titulo = map['titulo'];
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (id != null) data['id'] = this.id;
    if (titulo != null) data['titulo'] = this.titulo;
    return data;
  }
}

class SetorCensitarioID {
  String id;
  String nome;

  SetorCensitarioID({this.id, this.nome});

  SetorCensitarioID.fromMap(Map<dynamic, dynamic> map) {
    if (map.containsKey('id')) id = map['id'];
    if (map.containsKey('nome')) nome = map['nome'];
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (id != null) data['id'] = this.id;
    if (nome != null) data['nome'] = this.nome;
    return data;
  }
}

class CargoID {
  String id;
  String nome;

  CargoID({this.id, this.nome});

  CargoID.fromMap(Map<dynamic, dynamic> map) {
    if (map.containsKey('id')) id = map['id'];
    if (map.containsKey('nome')) nome = map['nome'];
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (id != null) data['id'] = this.id;
    if (nome != null) data['nome'] = this.nome;
    return data;
  }
}

class EixoID {
  String id;
  String nome;

  EixoID({this.id, this.nome});

  EixoID.fromMap(Map<dynamic, dynamic> map) {
    if (map.containsKey('id')) id = map['id'];
    if (map.containsKey('nome')) nome = map['nome'];
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (id != null) data['id'] = this.id;
    if (nome != null) data['nome'] = this.nome;
    return data;
  }
}

class UsuarioID {
  String id;
  String nome;

  UsuarioID({this.id, this.nome});

  UsuarioID.fromMap(Map<dynamic, dynamic> map) {
    if (map.containsKey('id')) id = map['id'];
    if (map.containsKey('nome')) nome = map['nome'];
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (id != null) data['id'] = this.id;
    if (nome != null) data['nome'] = this.nome;
    return data;
  }
}

class PerfilID {
  String id;
  String nome;
  String contentType;

  PerfilID({this.id, this.nome, this.contentType});

  PerfilID.fromMap(Map<dynamic, dynamic> map) {
    if (map.containsKey('id')) id = map['id'];
    if (map.containsKey('nome')) nome = map['nome'];
    if (map.containsKey('contentType')) contentType = map['contentType'];
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (id != null) data['id'] = this.id;
    if (nome != null) data['nome'] = this.nome;
    if (contentType != null) data['contentType'] = this.contentType;
    return data;
  }
}
