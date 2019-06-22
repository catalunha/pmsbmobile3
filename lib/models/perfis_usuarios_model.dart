class PerfilUsuarioModel{
  String id; //mesmo id do usuario
  String nome;
  String email;
  String celular;
  String setorCensitario;
  String nomeProjeto;
  String imagemPeril;

  dynamic cargo;
  List<dynamic> eixos;
  dynamic eixo_atual;
  dynamic eixo;

  List<String> rotas;

  PerfilUsuarioModel.fromMap(Map<String, dynamic> map) {
    id = map['id'] ?? "";
    nome = map['nome'] ?? "";
    email = map['email'] ?? "";
    celular = map['celular'] ?? "";
    setorCensitario = map['setorCensitario'] ?? "";
    nomeProjeto = map['nomeProjeto'] ?? "";
    imagemPeril = map['imagemPerfil'] ?? "";
  }
}