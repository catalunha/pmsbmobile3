class Acao {
  
  String titulo;
  bool status;

  Acao({this.titulo, this.status});

  Acao.fromJson(Map<String, dynamic> json) {
    titulo = json['titulo'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['titulo'] = this.titulo;
    data['status'] = this.status;
    return data;
  }
}