import 'package:pmsbmibile3/models/base_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';

class ProdutoModel extends FirestoreModel {
  static final String collection = "Produto";

  String nome;
  String textoMarkdownID;
  EixoID eixoID;
  DateTime modificado;
  SetorCensitarioID setorCensitarioID;
  UsuarioID usuarioID;
  List<Imagem> imagem;
  List<Tabela> tabela;
  List<Grafico> grafico;
  List<Mapa> mapa;

  ProdutoModel(
      {String id,
      this.nome,
      this.textoMarkdownID,
      this.eixoID,
      this.setorCensitarioID,
      this.usuarioID,
      this.modificado,
      this.imagem,
      this.tabela,
      this.grafico,
      this.mapa})
      : super(id);
  @override
  ProdutoModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('nome')) nome = map['nome'];
    if (map.containsKey('textoMarkdownID')) textoMarkdownID = map['textoMarkdownID'];
    if (map.containsKey('eixoID')) {
      eixoID = map['eixoID'] != null ? new EixoID.fromMap(map['eixoID']) : null;
    }
    if (map.containsKey('setorCensitarioID')) {
      setorCensitarioID = map['setorCensitarioID'] != null
          ? new SetorCensitarioID.fromMap(map['setorCensitarioID'])
          : null;
    }
    if (map.containsKey('usuarioID')) {
      usuarioID = map['usuarioID'] != null
          ? new UsuarioID.fromMap(map['usuarioID'])
          : null;
    }
    if (map.containsKey('modificado')) modificado = map['modificado'].toDate();
    if (map.containsKey('imagem') && (map['imagem'] != null)) {
      imagem = new List<Imagem>();
      map['imagem'].forEach((v) {
        imagem.add(new Imagem.fromMap(v));
      });
    }
    if (map.containsKey('tabela') && (map['tabela'] != null)) {
      tabela = new List<Tabela>();
      map['tabela'].forEach((v) {
        tabela.add(new Tabela.fromMap(v));
      });
    }
    if (map.containsKey('grafico') && (map['grafico'] != null)) {
      grafico = new List<Grafico>();
      map['grafico'].forEach((v) {
        grafico.add(new Grafico.fromMap(v));
      });
    }
    if (map.containsKey('mapa') && (map['mapa'] != null)) {
      mapa = new List<Mapa>();
      map['mapa'].forEach((v) {
        mapa.add(new Mapa.fromMap(v));
      });
    }
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (textoMarkdownID != null) data['textoMarkdownID'] = this.textoMarkdownID;
    if (nome != null) data['nome'] = this.nome;
    if (this.eixoID != null) {
      data['eixoID'] = this.eixoID.toMap();
    }
    if (this.setorCensitarioID != null) {
      data['setorCensitarioID'] = this.setorCensitarioID.toMap();
    }
    if (this.usuarioID != null) {
      data['usuarioID'] = this.usuarioID.toMap();
    }
    if (modificado != null) data['modificado'] = this.modificado.toUtc();
    if (this.imagem != null) {
      data['imagem'] = this.imagem.map((v) => v.toMap()).toList();
    }
    if (this.tabela != null) {
      data['tabela'] = this.tabela.map((v) => v.toMap()).toList();
    }
    if (this.grafico != null) {
      data['grafico'] = this.grafico.map((v) => v.toMap()).toList();
    }
    if (this.mapa != null) {
      data['mapa'] = this.mapa.map((v) => v.toMap()).toList();
    }
    return data;
  }
}


class Imagem {
  String id;
  String titulo;
  String produtoArquivoIDRascunho;
  String produtoArquivoIDEditado;

  Imagem(
      {this.id,
      this.titulo,
      this.produtoArquivoIDRascunho,
      this.produtoArquivoIDEditado});

  Imagem.fromMap(Map<dynamic, dynamic> map) {
    if (map.containsKey('id')) id = map['id'];
    if (map.containsKey('titulo')) titulo = map['titulo'];
    if (map.containsKey('produtoArquivoIDRascunho'))
      produtoArquivoIDRascunho = map['produtoArquivoIDRascunho'];
    if (map.containsKey('produtoArquivoIDEditado'))
      produtoArquivoIDEditado = map['produtoArquivoIDEditado'];
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (id != null) data['id'] = this.id;
    if (titulo != null) data['titulo'] = this.titulo;
    if (produtoArquivoIDRascunho != null)
      data['produtoArquivoIDRascunho'] = this.produtoArquivoIDRascunho;
    if (produtoArquivoIDEditado != null)
      data['produtoArquivoIDEditado'] = this.produtoArquivoIDEditado;
    return data;
  }
}

class Tabela {
  String id;
  String titulo;
  String produtoArquivoIDRascunho;
  String produtoArquivoIDEditado;

  Tabela(
      {this.id,
      this.titulo,
      this.produtoArquivoIDRascunho,
      this.produtoArquivoIDEditado});

  Tabela.fromMap(Map<dynamic, dynamic> map) {
    if (map.containsKey('id')) id = map['id'];
    if (map.containsKey('titulo')) titulo = map['titulo'];
    if (map.containsKey('produtoArquivoIDRascunho'))
      produtoArquivoIDRascunho = map['produtoArquivoIDRascunho'];
    if (map.containsKey('produtoArquivoIDEditado'))
      produtoArquivoIDEditado = map['produtoArquivoIDEditado'];
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (id != null) data['id'] = this.id;
    if (titulo != null) data['titulo'] = this.titulo;
    if (produtoArquivoIDRascunho != null)
      data['produtoArquivoIDRascunho'] = this.produtoArquivoIDRascunho;
    if (produtoArquivoIDEditado != null)
      data['produtoArquivoIDEditado'] = this.produtoArquivoIDEditado;
    return data;
  }
}

class Grafico {
  String id;
  String titulo;
  String produtoArquivoIDRascunho;
  String produtoArquivoIDEditado;

  Grafico(
      {this.id,
      this.titulo,
      this.produtoArquivoIDRascunho,
      this.produtoArquivoIDEditado});

  Grafico.fromMap(Map<dynamic, dynamic> map) {
    if (map.containsKey('id')) id = map['id'];
    if (map.containsKey('titulo')) titulo = map['titulo'];
    if (map.containsKey('produtoArquivoIDRascunho'))
      produtoArquivoIDRascunho = map['produtoArquivoIDRascunho'];
    if (map.containsKey('produtoArquivoIDEditado'))
      produtoArquivoIDEditado = map['produtoArquivoIDEditado'];
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (id != null) data['id'] = this.id;
    if (titulo != null) data['titulo'] = this.titulo;
    if (produtoArquivoIDRascunho != null)
      data['produtoArquivoIDRascunho'] = this.produtoArquivoIDRascunho;
    if (produtoArquivoIDEditado != null)
      data['produtoArquivoIDEditado'] = this.produtoArquivoIDEditado;
    return data;
  }
}

class Mapa {
  String id;
  String titulo;
  String produtoArquivoIDRascunho;
  String produtoArquivoIDEditado;

  Mapa(
      {this.id,
      this.titulo,
      this.produtoArquivoIDRascunho,
      this.produtoArquivoIDEditado});

  Mapa.fromMap(Map<dynamic, dynamic> map) {
    if (map.containsKey('id')) id = map['id'];
    if (map.containsKey('titulo')) titulo = map['titulo'];
    if (map.containsKey('produtoArquivoIDRascunho'))
      produtoArquivoIDRascunho = map['produtoArquivoIDRascunho'];
    if (map.containsKey('produtoArquivoIDEditado'))
      produtoArquivoIDEditado = map['produtoArquivoIDEditado'];
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (id != null) data['id'] = this.id;
    if (titulo != null) data['titulo'] = this.titulo;
    if (produtoArquivoIDRascunho != null)
      data['produtoArquivoIDRascunho'] = this.produtoArquivoIDRascunho;
    if (produtoArquivoIDEditado != null)
      data['produtoArquivoIDEditado'] = this.produtoArquivoIDEditado;
    return data;
  }
}
