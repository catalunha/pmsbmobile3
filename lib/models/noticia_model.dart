import 'package:pmsbmibile3/models/base_model.dart';

class NoticiaModel extends FirestoreModel {
  static final String collection = "Noticia";

  String titulo;
  String textoMarkdown;
  UsuarioIDEditor usuarioIDEditor;
  bool distribuida;
  DateTime publicar;
  List<String> destinatarios;

  NoticiaModel(
      {String id,
      this.titulo,
      this.textoMarkdown,
      this.usuarioIDEditor,
      this.distribuida,
      this.publicar,
      this.destinatarios})
      : super(id);

  @override
  NoticiaModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('titulo')) titulo = map['titulo'];
    if (map.containsKey('textoMarkdown')) textoMarkdown = map['textoMarkdown'];
    if (map.containsKey('usuarioIDEditor')) {
      usuarioIDEditor = map['usuarioIDEditor'] != null
          ? new UsuarioIDEditor.fromMap(map['usuarioIDEditor'])
          : null;
    }
    if (map.containsKey('distribuida')) distribuida = map['distribuida'];
    if (map.containsKey('publicar')) publicar = map['publicar'].toDate();
    if (map.containsKey('destinatarios'))
      destinatarios = map['destinatarios'].cast<String>();
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
    if (destinatarios != null) data['destinatarios'] = this.destinatarios;
    return data;
  }
}

class UsuarioIDEditor {
  String id;

  UsuarioIDEditor({this.id});

  UsuarioIDEditor.fromMap(Map<dynamic, dynamic> map) {
    if (map.containsKey('id')) id = map['id'];
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (id != null) data['id'] = this.id;
    return data;
  }
}
