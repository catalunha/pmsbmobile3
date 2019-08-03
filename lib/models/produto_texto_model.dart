import 'package:pmsbmibile3/models/base_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';

class ProdutoTextoModel extends FirestoreModel {
  static final String collection = "ProdutoTexto";

  UsuarioID usuarioID;
  DateTime modificado;
  bool editando;
  String textoMarkdown;

  ProdutoTextoModel(
      {String id,
      this.usuarioID,
      this.modificado,
      this.editando,
      this.textoMarkdown})
      : super(id);
  @override
  ProdutoTextoModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('usuarioID')) {
      usuarioID = map['usuarioID'] != null
          ? new UsuarioID.fromMap(map['usuarioID'])
          : null;
    }
    if (map.containsKey('modificado')) modificado = map['modificado'].toDate();
    if (map.containsKey('editando')) editando = map['editando'];
    if (map.containsKey('textoMarkdown')) textoMarkdown = map['textoMarkdown'];
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.usuarioID != null) {
      data['usuarioID'] = this.usuarioID.toMap();
    }
    if (modificado != null) data['modificado'] = this.modificado.toUtc();
    if (editando != null) data['editando'] = this.editando;
    if (textoMarkdown != null) data['textoMarkdown'] = this.textoMarkdown;
    return data;
  }
}
