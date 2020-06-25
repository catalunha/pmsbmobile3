class UsuarioQuadroModel {
  int id;
  String nome;
  String urlImagem;

  UsuarioQuadroModel({this.id, this.nome, this.urlImagem});

  UsuarioQuadroModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    urlImagem = json['url_imagem'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['url_imagem'] = this.urlImagem;
    return data;
  }
}