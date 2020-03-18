import 'package:pmsbmibile3/models/base_model.dart';

class IAItemRespostaModel extends FirestoreModel {
  static final String collection = "IAItemResposta";

  String setorId;
  String setorNome;
  String atendeTR;
  String documento;
  String descricao;
  String requisitoAtendeTR; // valor do atendeTR no red ou busca ?
  List<String> requisitoStatus; // [s|p|n]

  IAItemRespostaModel({
    String id,
    this.setorId,
    this.setorNome,
    this.atendeTR,
    this.documento,
    this.descricao,
    this.requisitoAtendeTR,
    this.requisitoStatus,
  }) : super(id);

  @override
  IAItemRespostaModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('setorId')) setorId = map['setorId'];
    if (map.containsKey('setorNome')) setorNome = map['setorNome'];
    if (map.containsKey('atendeTR')) atendeTR = map['atendeTR'];
    if (map.containsKey('documento')) documento = map['documento'];
    if (map.containsKey('descricao')) descricao = map['descricao'];
    if (map.containsKey('requisitoAtendeTR')) requisitoAtendeTR = map['requisitoAtendeTR'];
    if (map.containsKey('requisitoStatus')) requisitoStatus = map['requisitoStatus'];

    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (setorId != null) data['setorId'] = this.setorId;
    if (setorNome != null) data['setorNome'] = this.setorNome;
    if (descricao != null) data['descricao'] = this.descricao;
    if (atendeTR != null) data['atendeTR'] = this.atendeTR;
    if (documento != null) data['documento'] = this.documento;
    if (requisitoAtendeTR != null) data['requisitoAtendeTR'] = this.requisitoAtendeTR;
    if (requisitoStatus != null) data['requisitoStatus'] = this.requisitoStatus;

    return data;
  }
}
