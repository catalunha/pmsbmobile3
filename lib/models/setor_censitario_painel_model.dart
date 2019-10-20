import 'package:pmsbmibile3/models/base_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';

class SetorCensitarioPainelModel extends FirestoreModel {
  static final String collection = "SetorCensitarioPainel";

  SetorCensitarioID setorCensitarioID;
  PainelID painelID;
  UsuarioID usuarioQEditou;
  UsuarioID usuarioQVaiResponder;
  EixoID eixo;
  ProdutoFunasaID produto;
  String observacao;
  dynamic valor;
  dynamic modificada;

  SetorCensitarioPainelModel({String id}) : super(id);

  @override
  SetorCensitarioPainelModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('setorCensitarioID')) {
      setorCensitarioID = map['setorCensitarioID'] != null
          ? new SetorCensitarioID.fromMap(map['setorCensitarioID'])
          : null;
    }
    if (map.containsKey('painelID')) {
      painelID = map['painelID'] != null
          ? new PainelID.fromMap(map['painelID'])
          : null;
    }
    if (map.containsKey('usuarioID')) {
      usuarioQEditou = map['usuarioID'] != null
          ? new UsuarioID.fromMap(map['usuarioID'])
          : null;
    }
    usuarioQVaiResponder = map.containsKey('usuarioQVaiResponder') &&
            map['usuarioQVaiResponder'] != null
        ? new UsuarioID.fromMap(map['usuarioQVaiResponder'])
        : null;

    eixo = map.containsKey('eixo') && map['eixo'] != null
        ? new EixoID.fromMap(map['eixo'])
        : null;
    produto = map.containsKey('produto') && map['produto'] != null
        ? new ProdutoFunasaID.fromMap(map['produto'])
        : null;
    if (map.containsKey('observacao')) observacao = map['observacao'];
    if (map.containsKey('valor')) valor = map['valor'];
    if (map.containsKey("modificada") && map["modificada"] != null) {
      modificada = DateTime.fromMillisecondsSinceEpoch(
          map['modificada'].millisecondsSinceEpoch);
    }
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.setorCensitarioID != null) {
      data['setorCensitarioID'] = this.setorCensitarioID.toMap();
    }
    if (this.painelID != null) {
      data['painelID'] = this.painelID.toMap();
    }
    if (this.usuarioQEditou != null) {
      data['usuarioID'] = this.usuarioQEditou.toMap();
    }
    if (this.usuarioQVaiResponder != null) {
      data['usuarioQVaiResponder'] = this.usuarioQVaiResponder.toMap();
    }
    if (this.eixo != null) {
      data['eixo'] = this.eixo.toMap();
    }
    if (this.produto != null) {
      data['produto'] = this.produto.toMap();
    }
    if (observacao != null) data['observacao'] = this.observacao;
    if (modificada != null) data['modificada'] = this.modificada.toUtc();
    if (valor != null) data['valor'] = this.valor;
    return data;
  }
}
