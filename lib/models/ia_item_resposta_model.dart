import 'package:pmsbmibile3/models/base_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';

class IAItemRespostaModel extends FirestoreModel {
  static final String collection = "IAItemResposta";

  String atendeTR;
  String documento;
  String descricao;
  String requisitoAtendeTR; // valor do atendeTR no red ou busca ?
  List<String> requisitoStatus; // [s|p|n]
  SetorCensitarioID setor;
  UsuarioID usuario;
  dynamic modificado;

  IAItemRespostaModel({
    String id,
    this.atendeTR,
    this.documento,
    this.descricao,
    this.requisitoAtendeTR,
    this.requisitoStatus,
    this.usuario,
    this.modificado,
    this.setor,
  }) : super(id);

  @override
  IAItemRespostaModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('atendeTR')) atendeTR = map['atendeTR'];
    if (map.containsKey('documento')) documento = map['documento'];
    if (map.containsKey('descricao')) descricao = map['descricao'];
    if (map.containsKey('requisitoAtendeTR'))
      requisitoAtendeTR = map['requisitoAtendeTR'];
    if (map.containsKey('requisitoStatus'))
      requisitoStatus = map['requisitoStatus'];

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
          ? new SetorCensitarioID.fromMap(map['setor'])
          : null;
    }
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (descricao != null && descricao.isNotEmpty)
      data['descricao'] = this.descricao.isEmpty ? null : this.descricao;
    if (atendeTR != null) data['atendeTR'] = this.atendeTR;
    if (documento != null)
      data['documento'] = this.documento.isEmpty ? null : this.documento;
    if (requisitoAtendeTR != null)
      data['requisitoAtendeTR'] = this.requisitoAtendeTR;
    if (requisitoStatus != null) data['requisitoStatus'] = this.requisitoStatus;
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
