class VariavelUsuarioModel {
  String id;
  String userId;
  String tipo;
  String nome;
  dynamic conteudo;

  VariavelUsuarioModel({
    this.id,
    this.userId,
    this.tipo,
    this.nome,
    this.conteudo,
  });

  VariavelUsuarioModel.fromFirestore() {
    VariavelUsuarioModel(
      id: "",
      userId: "",
      tipo: "",
      nome: "",
      conteudo: "",
    );
  }

  VariavelUsuarioModel.fromJson(Map<dynamic, dynamic> json) {
    VariavelUsuarioModel(
      id: json['id'],
      userId: json['userId'],
      tipo: json['tipo'],
      nome: json['nome'],
      conteudo: json['conteudo'],
    );
  }

  VariavelUsuarioModel.fromMap(Map<String, dynamic> map) {
    VariavelUsuarioModel(
      id: map['id'],
      userId: map['userId'],
      tipo: map['tipo'],
      nome: map['nome'],
      conteudo: map['conteudo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "nome": nome,
      "tipo": tipo,
      "conteudo": conteudo,
    };
  }
}
