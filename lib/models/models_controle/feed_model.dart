import 'package:pmsbmibile3/models/models_controle/anexos_model.dart';

class Feed {
  String usuario;
  String dataPostagem;
  String corpoTexto;
  List<Anexo> anexos;

  Feed({this.usuario, this.dataPostagem, this.corpoTexto, this.anexos});

  Feed.fromJson(Map<String, dynamic> json) {
    usuario = json['usuario'];
    dataPostagem = json['data_postagem'];
    corpoTexto = json['corpo_texto'];
    if (json['anexos'] != null) {
      anexos = new List<Anexo>();
      json['anexos'].forEach((v) {
        anexos.add(new Anexo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['usuario'] = this.usuario;
    data['data_postagem'] = this.dataPostagem;
    data['corpo_texto'] = this.corpoTexto;
    if (this.anexos != null) {
      data['anexos'] = this.anexos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
