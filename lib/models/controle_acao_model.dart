import 'package:pmsbmibile3/models/base_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';

class ControleAcaoModel extends FirestoreModel {
  static final String collection = "ControleAcao";

  String referencia;
  String nome;
  String url;
  String observacao;
  Map<String, bool> tarefaLink = Map<String, bool>();
  ControleTarefaID tarefa;
  SetorCensitarioID setor;
  UsuarioID remetente;
  UsuarioID destinatario;
  bool concluida;
  DateTime modificada;
  int ordem;

  ControleAcaoModel({String id}) : super(id);

  @override
  ControleAcaoModel fromMap(Map<String, dynamic> map) {
    if (map.containsKey("referencia")) referencia = map["referencia"];
    if (map.containsKey("nome")) nome = map["nome"];
    if (map.containsKey("url")) url = map["url"];
    if (map.containsKey("observacao")) observacao = map["observacao"];
    if (map.containsKey("tarefaLink") && map["tarefaLink"] != null) {
      final refs = map["tarefaLink"] as Map<dynamic, dynamic>;
      for (var ref in refs.entries) {
        tarefaLink[ref.key] = ref.value;
      }
    }
    // if (map.containsKey("modificada") && map["modificada"] != null) {
    //   modificada = map["modificada"].toDate();
    // }
    if (map.containsKey("modificada") && map["modificada"] != null) {
      modificada = map["modificada"];
    }

    if (map.containsKey('tarefa')) {
      tarefa = map['tarefa'] != null
          ? new ControleTarefaID.fromMap(map['tarefa'])
          : null;
    }
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
    if (map.containsKey("concluida")) concluida = map["concluida"];
    if (map.containsKey("ordem")) ordem = map["ordem"];

    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (referencia != null) data['referencia'] = this.referencia;
    if (nome != null) data['nome'] = this.nome;
    if (url != null) data['url'] = this.url;
    if (tarefaLink != null) data['tarefaLink'] = this.tarefaLink;
    if (observacao != null) data['observacao'] = this.observacao;
    if (ordem != null) data['ordem'] = this.ordem;
    if (concluida != null) data['concluida'] = this.concluida;
    if (modificada != null) data['modificada'] = this.modificada.toUtc();
    if (this.tarefa != null) {
      data['tarefa'] = this.tarefa.toMap();
    }
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
