class ColunaModel {
  
  String id;
  String titulo;

  ColunaModel({this.id, this.titulo});

  ColunaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titulo = json['titulo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['titulo'] = this.titulo;
    return data;
  }
}