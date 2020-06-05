import 'package:pmsbmibile3/models/models_controle/acao_model.dart';
import 'package:pmsbmibile3/models/models_controle/colunas_model.dart';
import 'package:pmsbmibile3/models/models_controle/etiqueta_model.dart';
import 'package:pmsbmibile3/models/models_controle/feed_model.dart';
import 'package:pmsbmibile3/models/models_controle/usuario_quadro_model.dart';

class TarefaModel {
  ColunaModel coluna;
  String tituloAtividade;
  String descricaoAtividade;
  List<UsuarioQuadroModel> usuarios;
  List<Etiqueta> etiquetas;
  List<Acao> acoes;
  List<Feed> feed;

  TarefaModel(
      {this.coluna,
      this.tituloAtividade,
      this.descricaoAtividade,
      this.usuarios,
      this.etiquetas,
      this.acoes,
      this.feed});

  TarefaModel.fromJson(Map<String, dynamic> json) {
    coluna =
        json['coluna'] != null ? new ColunaModel.fromJson(json['coluna']) : null;
    tituloAtividade = json['titulo_atividade'];
    descricaoAtividade = json['descricao_atividade'];
    if (json['usuarios'] != null) {
      usuarios = new List<UsuarioQuadroModel>();
      json['usuarios'].forEach((v) {
        usuarios.add(new UsuarioQuadroModel.fromJson(v));
      });
    }
    if (json['etiquetas'] != null) {
      etiquetas = new List<Etiqueta>();
      json['etiquetas'].forEach((v) {
        etiquetas.add(new Etiqueta.fromJson(v));
      });
    }
    if (json['acoes'] != null) {
      acoes = new List<Acao>();
      json['acoes'].forEach((v) {
        acoes.add(new Acao.fromJson(v));
      });
    }
    if (json['feed'] != null) {
      feed = new List<Feed>();
      json['feed'].forEach((v) {
        feed.add(new Feed.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.coluna != null) {
      data['coluna'] = this.coluna.toJson();
    }
    data['titulo_atividade'] = this.tituloAtividade;
    data['descricao_atividade'] = this.descricaoAtividade;
    if (this.usuarios != null) {
      data['usuarios'] = this.usuarios.map((v) => v.toJson()).toList();
    }
    if (this.etiquetas != null) {
      data['etiquetas'] = this.etiquetas.map((v) => v.toJson()).toList();
    }
    if (this.acoes != null) {
      data['acoes'] = this.acoes.map((v) => v.toJson()).toList();
    }
    if (this.feed != null) {
      data['feed'] = this.feed.map((v) => v.toJson()).toList();
    }
    return data;
  }
}