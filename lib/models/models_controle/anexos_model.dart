class Anexo {
  String titulo;
  String url;
  String tipo;

  Anexo({this.titulo, this.url, this.tipo});

  Anexo.fromJson(Map<String, dynamic> json) {
    titulo = json['titulo'];
    url = json['url'];
    tipo = json['tipo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['titulo'] = this.titulo;
    data['url'] = this.url;
    data['tipo'] = this.tipo;
    return data;
  }
}