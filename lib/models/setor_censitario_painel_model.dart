import 'package:pmsbmibile3/models/base_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';

class SetorCensitarioPainelModel extends FirestoreModel {
  static final String collection = "SetorCensitarioPainel";
  SetorCensitarioID setorCensitarioID;
  PainelID painelID;
  UsuarioID usuarioID;

  String observacao;
  dynamic valor;
  DateTime modificada;

  SetorCensitarioPainelModel({String id}) : super(id);

  @override
  SetorCensitarioPainelModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey('setorCensitarioID')) {
      setorCensitarioID =
          map['setorCensitarioID'] != null ? new SetorCensitarioID.fromMap(map['setorCensitarioID']) : null;
    }
    if (map.containsKey('painelID')) {
      painelID = map['painelID'] != null ? new PainelID.fromMap(map['painelID']) : null;
    }
    if (map.containsKey('usuarioID')) {
      usuarioID = map['usuarioID'] != null ? new UsuarioID.fromMap(map['usuarioID']) : null;
    }
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
    if (this.usuarioID != null) {
      data['usuarioID'] = this.usuarioID.toMap();
    }
    if (observacao != null) data['observacao'] = this.observacao;
    if (modificada != null) data['modificada'] = this.modificada.toUtc();
    if (valor != null) data['valor'] = this.valor;
    return data;
  }
}
