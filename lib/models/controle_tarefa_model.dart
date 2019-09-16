import 'package:pmsbmibile3/models/base_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';

class ControleTarefaModel extends FirestoreModel {
  static final String collection = "ControleTarefa";

  String nome;
  DateTime inicio;
  DateTime fim;
  UsuarioID remetente;
  UsuarioID destinatario;
  SetorCensitarioID setor;
  int acaoTotal;
  int acaoCumprida;
  bool concluida;
  int ultimaAcaoCriada;

  ControleTarefaModel({String id, this.nome,this.acaoTotal}) : super(id);

  @override
  ControleTarefaModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey("nome")) nome = map["nome"];
    if (map.containsKey("acaoTotal")) acaoTotal = map["acaoTotal"];
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (nome != null) data['nome'] = this.nome;
    if (acaoTotal != null) data['acaoTotal'] = this.acaoTotal;
    return data;
  }
}
