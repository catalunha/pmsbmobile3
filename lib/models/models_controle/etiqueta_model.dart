class Etiqueta {
  String id;
  String titulo;
  int cor;

  Etiqueta({this.id, this.titulo, this.cor});

  Etiqueta.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titulo = json['titulo'];
    cor = json['cor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['titulo'] = this.titulo;
    data['cor'] = this.cor;
    return data;
  }
}