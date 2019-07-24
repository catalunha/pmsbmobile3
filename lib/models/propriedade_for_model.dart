
class UsuarioArquivoID {
  String id;
  String url;

  UsuarioArquivoID({this.id, this.url});

  UsuarioArquivoID.fromMap(Map<dynamic, dynamic> map) {
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

class ArquivoProduto {
  String id;
  String titulo;
  String tipo;
  String rascunhoEixoArquivoID;
  String rascunhoUrl;
  String rascunhoLocalPath;
  String editadoEixoArquivoID;
  String editadoUrl;
  String editadoLocalPath;

  ArquivoProduto(
      {this.id,
      this.titulo,
      this.rascunhoEixoArquivoID,
      this.rascunhoUrl,
      this.rascunhoLocalPath,
      this.editadoEixoArquivoID,
      this.editadoUrl,
      this.editadoLocalPath});

  ArquivoProduto.fromMap(Map<dynamic, dynamic> map) {
    if (map.containsKey('id')) id = map['id'];
    if (map.containsKey('titulo')) titulo = map['titulo'];
    if (map.containsKey('tipo')) tipo = map['tipo'];
    if (map.containsKey('rascunhoEixoArquivoID'))
      rascunhoEixoArquivoID = map['rascunhoEixoArquivoID'];
    if (map.containsKey('rascunhoUrl')) rascunhoUrl = map['rascunhoUrl'];
    if (map.containsKey('rascunhoLocalPath'))
      rascunhoLocalPath = map['rascunhoLocalPath'];
    if (map.containsKey('editadoEixoArquivoID'))
      editadoEixoArquivoID = map['editadoEixoArquivoID'];
    if (map.containsKey('editadoUrl')) editadoUrl = map['editadoUrl'];
    if (map.containsKey('editadoLocalPath'))
      editadoLocalPath = map['editadoLocalPath'];
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (id != null) data['id'] = this.id;
    if (titulo != null) data['titulo'] = this.titulo;
    if (rascunhoEixoArquivoID != null)
      data['rascunhoEixoArquivoID'] = this.rascunhoEixoArquivoID;
    if (rascunhoUrl != null) data['rascunhoUrl'] = this.rascunhoUrl;
    if (rascunhoLocalPath != null)
      data['rascunhoLocalPath'] = this.rascunhoLocalPath;
    if (editadoEixoArquivoID != null)
      data['editadoEixoArquivoID'] = this.editadoEixoArquivoID;
    if (editadoUrl != null) data['editadoUrl'] = this.editadoUrl;
    if (editadoLocalPath != null)
      data['editadoLocalPath'] = this.editadoLocalPath;
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
  String nome;

  ProdutoID({this.id, this.nome});

  ProdutoID.fromMap(Map<dynamic, dynamic> map) {
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
