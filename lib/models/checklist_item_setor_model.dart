import 'package:pmsbmibile3/models/base_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';

class ChecklistItemSetorModel extends FirestoreModel {
  static final String collection = "ChecklistItemResposta";

  SetorCensitarioRef setor;
  UsuarioID usuario;
  dynamic modificado;
  String atendeTR;
  String linkDocumento;
  String comentario;

  ChecklistItemSetorModel({
    String id,
    this.atendeTR,
    this.linkDocumento,
    this.comentario,
    this.usuario,
    this.modificado,
    this.setor,
  }) : super(id);

  @override
  ChecklistItemSetorModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('atendeTR')) atendeTR = map['atendeTR'];
    if (map.containsKey('linkDocumento')) linkDocumento = map['linkDocumento'];
    if (map.containsKey('comentario')) comentario = map['comentario'];

    if (map.containsKey('modificado')) {
      modificado = map['modificado'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['modificado'].millisecondsSinceEpoch)
          : null;
    }
    if (map.containsKey('usuarioID')) {
      usuario = map['usuarioID'] != null
          ? new UsuarioID.fromMap(map['usuarioID'])
          : null;
    }
    if (map.containsKey('setor')) {
      setor = map['setor'] != null
          ? new SetorCensitarioRef.fromMap(map['setor'])
          : null;
    }
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (comentario != null && comentario.isNotEmpty)
      data['comentario'] = this.comentario.isEmpty ? null : this.comentario;
    if (comentario != null)
      data['comentario'] = this.comentario.isEmpty ? null : this.comentario;
    if (linkDocumento != null)
      data['linkDocumento'] =
          this.linkDocumento.isEmpty ? null : this.linkDocumento;
    if (modificado != null) data['modificado'] = modificado;
    if (this.usuario != null) {
      data['usuarioID'] = this.usuario.toMap();
    }
    if (this.setor != null) {
      data['setor'] = this.setor.toMap();
    }
    return data;
  }
}

class SetorCensitarioRef {
  String id;
  String nome;
  String checklistPasta;
  String checklistPlanilha;

  SetorCensitarioRef(
      {this.id, this.nome, this.checklistPasta, this.checklistPlanilha});

  SetorCensitarioRef.fromMap(Map<dynamic, dynamic> map) {
    if (map.containsKey('id')) id = map['id'];
    if (map.containsKey('nome')) nome = map['nome'];
    if (map.containsKey('checklistPasta'))
      checklistPasta = map['checklistPasta'];
    if (map.containsKey('checklistPlanilha'))
      checklistPlanilha = map['checklistPlanilha'];
  }

  Map<dynamic, dynamic> toMap() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (id != null) data['id'] = this.id;
    if (nome != null) data['nome'] = this.nome;
    if (checklistPasta != null) data['checklistPasta'] = this.checklistPasta;
    if (checklistPlanilha != null)
      data['checklistPlanilha'] = this.checklistPlanilha;
    return data;
  }
}
