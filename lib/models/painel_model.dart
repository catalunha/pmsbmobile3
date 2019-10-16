// import 'package:validators/validators.dart';
import 'package:pmsbmibile3/models/base_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';

class PainelModel extends FirestoreModel {
  static final String collection = "Painel";
  String nome;

  /// Os tipos pode ser: texto | numero | booleano | urlimagem | urlarquivo
  String tipo;

  UsuarioID usuarioID;
  dynamic modificado;

  PainelModel({String id, this.nome, this.tipo}) : super(id);

  PainelModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('nome')) nome = map['nome'];
    if (map.containsKey('tipo')) tipo = map['tipo'];
    if (map.containsKey('modificado'))
      modificado = DateTime.fromMillisecondsSinceEpoch(
          map['modificado'].millisecondsSinceEpoch);
    if (map.containsKey('usuarioID')) {
      usuarioID = map['usuarioID'] != null
          ? new UsuarioID.fromMap(map['usuarioID'])
          : null;
    }
    return this;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (nome != null) data['nome'] = this.nome;
    if (tipo != null) data['tipo'] = this.tipo;
    if (modificado != null) data['modificado'] = modificado;

    if (this.usuarioID != null) {
      data['usuarioID'] = this.usuarioID.toMap();
    }
    return data;
  }
}
