import 'package:pmsbmibile3/models/models_controle/tarefa_model.dart';
import 'package:pmsbmibile3/models/models_controle/usuario_quadro_model.dart';

class QuadroModel {
  bool publico;
  String titulo;
  String descricao;
  List<UsuarioQuadroModel> usuarios;
  List<TarefaModel> tarefas;

  QuadroModel(
      {this.publico, this.titulo, this.descricao, this.usuarios, this.tarefas});

  QuadroModel.fromJson(Map<String, dynamic> json) {
    publico = json['publico'];
    titulo = json['titulo'];
    descricao = json['descricao'];
    if (json['usuarios'] != null) {
      usuarios = new List<UsuarioQuadroModel>();
      json['usuarios'].forEach((v) {
        usuarios.add(new UsuarioQuadroModel.fromJson(v));
      });
    }
    if (json['tarefas'] != null) {
      tarefas = new List<TarefaModel>();
      json['tarefas'].forEach((v) {
        tarefas.add(new TarefaModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['publico'] = this.publico;
    data['titulo'] = this.titulo;
    data['descricao'] = this.descricao;
    if (this.usuarios != null) {
      data['usuarios'] = this.usuarios.map((v) => v.toJson()).toList();
    }
    if (this.tarefas != null) {
      data['tarefas'] = this.tarefas.map((v) => v.toJson()).toList();
    }
    return data;
  }
}