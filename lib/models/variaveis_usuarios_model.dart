class VariavelUsuarioModel {
  String id;
  String userId;
  String variavelId;
  String tipo;
  String nome;
  dynamic conteudo;

  VariavelUsuarioModel({
    this.id,
    this.userId,
    this.variavelId,
    this.tipo,
    this.nome,
    this.conteudo,
  });

  VariavelUsuarioModel.fromMap(Map<String, dynamic> map) {

    id = map['id'];
    userId = map['userId'];
    variavelId = map['variavelId'];
    tipo = map['tipo'];
    nome = map['nome'];
    conteudo = map['conteudo'];

  }

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "variavelId": variavelId,
      "nome": nome,
      "tipo": tipo,
      "conteudo": conteudo,
    };
  }
}
