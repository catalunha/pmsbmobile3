import 'package:pmsbmibile3/models/base_model.dart';

class NoticiaModel extends FirestoreModel {
  static final String collection = "Noticia";

  String titulo;
  String textoMarkdown;
  UsuarioIDEditor usuarioIDEditor;
  bool distribuida;
  DateTime publicar;
  List<Destinatario> usuarioIDDestino;

  NoticiaModel(
      {String id,
      this.titulo,
      this.textoMarkdown,
      this.usuarioIDEditor,
      this.distribuida,
      this.publicar,
      this.usuarioIDDestino})
      : super(id);

  @override
  NoticiaModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('titulo')) titulo = map['titulo'];
    if (map.containsKey('textoMarkdown')) textoMarkdown = map['textoMarkdown'];
    if (map.containsKey('usuarioIDEditor')) {
      usuarioIDEditor =
          map['usuarioIDEditor'] != null ? new UsuarioIDEditor.fromMap(map['usuarioIDEditor']) : null;
    }
    if (map.containsKey('distribuida')) distribuida = map['distribuida'];
    if (map.containsKey('publicar')) publicar = map['publicar'].toDate();
    if (map.containsKey('usuarioIDDestino') &&
        (map['usuarioIDDestino'] != null)) {
      usuarioIDDestino = new List<Destinatario>();
      map['usuarioIDDestino'].forEach((v) {
        usuarioIDDestino.add(new Destinatario.fromMap(v));
      });
    }
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (titulo != null) data['titulo'] = this.titulo;
    if (textoMarkdown != null) data['textoMarkdown'] = this.textoMarkdown;
    if (this.usuarioIDEditor != null) {
      data['usuarioIDEditor'] = this.usuarioIDEditor.toMap();
    }
    if (distribuida != null) data['distribuida'] = this.distribuida;
    if (publicar != null) data['publicar'] = this.publicar.toUtc();
    if (this.usuarioIDDestino != null) {
      data['usuarioIDDestino'] =
          this.usuarioIDDestino.map((v) => v.toMap()).toList();
    }
    return data;
  }
}

class UsuarioIDEditor {
  String id;
  String nome;

  UsuarioIDEditor({this.id, this.nome});

  UsuarioIDEditor.fromMap(Map<dynamic, dynamic> map) {
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


class Destinatario {
  String id;
  String nome;

  Destinatario({this.id, this.nome});

  Destinatario.fromMap(Map<dynamic, dynamic> map) {
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
