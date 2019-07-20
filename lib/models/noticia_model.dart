import 'package:pmsbmibile3/models/base_model.dart';

class NoticiaModel extends FirestoreModel {
  static final String collection = "Noticia";

  String titulo;
  String textoMarkdown;
  UsuarioIDEditor usuarioIDEditor;
  bool distribuida;
  DateTime publicar;
  Map<String, Destinatario> usuarioIDDestino;

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
      usuarioIDEditor = map['usuarioIDEditor'] != null
          ? new UsuarioIDEditor.fromMap(map['usuarioIDEditor'])
          : null;
    }
    if (map.containsKey('distribuida')) distribuida = map['distribuida'];
    if (map.containsKey('publicar')) publicar = map['publicar'].toDate();
    if (map.containsKey('usuarioIDDestino')) {
      Map<dynamic, dynamic> dataFromMap = Map<dynamic, dynamic>();
      Map<String, Destinatario> dataToField = Map<String, Destinatario>();
      dataFromMap = map['usuarioIDDestino'];
      // print('>> dataFromMap >> ${dataFromMap}');
      dataFromMap.forEach((k, v) {
        // print(">> v[id].runtimeType >> ${v['id'].runtimeType}");
        dataToField[k] = Destinatario(
            uid: v['uid'],
            id: v['id'],
            nome: v['nome'],
            visualizada: v['visualizada']);
      });
      this.usuarioIDDestino = Map.from(dataToField);
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

    if (usuarioIDDestino != null) {
      Map<String, dynamic> dataFromField = Map<String, dynamic>();
      this.usuarioIDDestino.forEach((k, v) {
        dataFromField[k] = v.toMap();
      });
      data['usuarioIDDestino'] = dataFromField;
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
  String uid;
  bool id;
  String nome;
  bool visualizada;

  Destinatario({this.uid, this.id, this.nome, this.visualizada});

  Destinatario fromMap(Map<dynamic, dynamic> map) {
//     if (map.containsKey('uid')) uid = map['uid'];
    if (map.containsKey('id')) id = map['id'];
    if (map.containsKey('nome')) nome = map['nome'];
    if (map.containsKey('visualizada')) visualizada = map['visualizada'];
    return this;
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    // if (uid != null) data['uid'] = this.uid;
    if (id != null) data['id'] = this.id;
    if (nome != null) data['nome'] = this.nome;
    if (visualizada != null) data['visualizada'] = this.visualizada;
    return data;
  }
}
