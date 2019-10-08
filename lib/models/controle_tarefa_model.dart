import 'package:pmsbmibile3/models/base_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';

class ControleTarefaModel extends FirestoreModel {
  static final String collection = "ControleTarefa";

  String referencia;
  String nome;
  String acaoLink;
  DateTime inicio;
  DateTime fim;
  SetorCensitarioID setor;
  UsuarioID remetente;
  UsuarioID destinatario;
  int acaoTotal;
  int acaoCumprida;
  int ultimaOrdemAcao;
  bool concluida;
  DateTime modificada;

  ControleTarefaModel({String id}) : super(id);

  @override
  ControleTarefaModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey("referencia")) referencia = map["referencia"];
    if (map.containsKey("nome")) nome = map["nome"];
    if (map.containsKey("acaoLink")) acaoLink = map["acaoLink"];
    if (map.containsKey("acaoTotal")) acaoTotal = map["acaoTotal"];
    if (map.containsKey("acaoCumprida")) acaoCumprida = map["acaoCumprida"];
    if (map.containsKey("concluida")) concluida = map["concluida"];
    if (map.containsKey("ultimaOrdemAcao"))
      ultimaOrdemAcao = map["ultimaOrdemAcao"];
    // if (map.containsKey("modificada") && map["modificada"] != null)
    //   modificada = map["modificada"].toDate();
    if (map.containsKey("modificada") && map["modificada"] != null)
      modificada = map["modificada"];
    // if (map.containsKey("inicio") && map["inicio"] != null)
    //   inicio = map["inicio"].toDate();
    if (map.containsKey("inicio") && map["inicio"] != null)
      inicio = map["inicio"];
    // if (map.containsKey("fim") && map["fim"] != null) fim = map["fim"].toDate();
    if (map.containsKey("fim") && map["fim"] != null) fim = map["fim"];
    if (map.containsKey('setor')) {
      setor = map['setor'] != null
          ? new SetorCensitarioID.fromMap(map['setor'])
          : null;
    }
    if (map.containsKey('remetente')) {
      remetente = map['remetente'] != null
          ? new UsuarioID.fromMap(map['remetente'])
          : null;
    }
    if (map.containsKey('destinatario')) {
      destinatario = map['destinatario'] != null
          ? new UsuarioID.fromMap(map['destinatario'])
          : null;
    }
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (referencia != null) data['referencia'] = this.referencia;
    if (nome != null) data['nome'] = this.nome;
    if (acaoLink != null) data['acaoLink'] = this.acaoLink;
    if (acaoTotal != null) data['acaoTotal'] = this.acaoTotal;
    if (acaoCumprida != null) data['acaoCumprida'] = this.acaoCumprida;
    if (concluida != null) data['concluida'] = this.concluida;
    if (ultimaOrdemAcao != null)
      data['ultimaOrdemAcao'] = this.ultimaOrdemAcao;
    if (inicio != null) data['inicio'] = this.inicio.toUtc();
    if (fim != null) data['fim'] = this.fim.toUtc();
    if (this.setor != null) {
      data['setor'] = this.setor.toMap();
    }
    if (this.remetente != null) {
      data['remetente'] = this.remetente.toMap();
    }
    if (this.destinatario != null) {
      data['destinatario'] = this.destinatario.toMap();
    }
    return data;
  }
}
