import 'package:pmsbmibile3/models/base_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';

class ControleAcaoModel extends FirestoreModel {
  static final String collection = "ControleAcao";

  ControleTarefaID tarefa;
  String nome;
  UsuarioID remetente;
  UsuarioID destinatario;
  bool concluida;
  DateTime modificada;
  int ordem;

  ControleAcaoModel({String id, this.nome, this.ordem})
      : super(id);

  @override
  ControleAcaoModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey("nome")) nome = map["nome"];
    if (map.containsKey("ordem"))
      ordem = map["ordem"];
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (nome != null) data['nome'] = this.nome;
    if (ordem != null)
      data['ordem'] = this.ordem;
    return data;
  }
}
