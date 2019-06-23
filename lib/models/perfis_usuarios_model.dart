class PerfilUsuarioModel {
  static final String collection = "Usuario";
  String id; //mesmo id do usuario
  String nome;
  String email;
  String celular;
  String setorCensitario;
  String nomeProjeto;
  dynamic imagemPerfil;
  String imagemPerfilUrl;

  dynamic cargo;
  List<dynamic> eixos;
  dynamic eixo_atual;
  dynamic eixo;

  List<String> rotas;

  PerfilUsuarioModel({
    this.id,
    this.nome,
    this.email,
    this.celular,
    this.setorCensitario,
    this.nomeProjeto,
    this.imagemPerfil,
    this.imagemPerfilUrl,
    this.cargo,
    this.eixos,
    this.eixo_atual,
    this.eixo,
    this.rotas,
  });

  PerfilUsuarioModel.fromMap(Map<String, dynamic> map)
      : assert(map.containsKey("id")) {
    id = map['id'] ?? "";
    nome = map['nome'] ?? "";
    email = map['email'] ?? "";
    celular = map['celular'] ?? "";
    setorCensitario = map['setorCensitario'] ?? "";
    nomeProjeto = map['nomeProjeto'] ?? "";
    imagemPerfil = map['imagemPerfil'] ?? "";
    imagemPerfilUrl = map['imagemPerfilUrl'] ?? "";
  }

  Map<dynamic, dynamic> toMap() {
    return {
      "id":id,
      "nome":nome,
      "email":email,
      "celular":celular,
      "setorCensitario":setorCensitario,
      "nomeProjeto":nomeProjeto,
      "imagemPerfil":imagemPerfil,
      "imagemPerfilUrl":imagemPerfilUrl,
      "cargo":cargo,
      "eixos":eixos,
      "eixo_atual":eixo_atual,
      "eixo":eixo,
      "rotas":rotas,
    };
  }
}
