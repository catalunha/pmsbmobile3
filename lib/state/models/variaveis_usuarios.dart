class VarivelUsuario {
  String id;
  String userId;
  String tipo;
  String nome;
  String conteudo;

  VarivelUsuario({
    this.id,
    this.userId,
    this.tipo,
    this.nome,
    this.conteudo,
  });

  VarivelUsuario.fromFirestore() {
    VarivelUsuario(
      id: "",
      userId: "",
      tipo: "",
      nome: "",
      conteudo: "",
    );
  }

  VarivelUsuario.fromJson(Map<dynamic, dynamic> json) {
    VarivelUsuario(
      id: json['id'],
      userId: json['userId'],
      tipo: json['tipo'],
      nome: json['nome'],
      conteudo: json['conteudo'],
    );
  }
}
