import 'package:pmsbmibile3/models/base_model.dart';

class QuestionarioModel extends FirestoreModel{
  static final String collection = "Questionario";

  String userId;

  String usuarioNomeProjeto; //campo duplicado Usuario.nomeProjeto

  String nome;

  String dataCriacao;

  String eixoId;

  String eixoNome;

  QuestionarioModel({
    String id,
    this.userId,
    this.usuarioNomeProjeto,
    this.nome,
    this.dataCriacao,
    this.eixoId,
    this.eixoNome,
  }) : super(id);

  @override
  QuestionarioModel fromMap(Map<String, dynamic> map) {
    nome = map["nome"];
    userId = map["userId"];
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final data = Map<String, dynamic>();
    if(nome != null) data['nome'] = nome;
    if(userId != null) data['userId'] = userId;
    return data;
  }
}
