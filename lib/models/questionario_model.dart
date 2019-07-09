import 'package:pmsbmibile3/models/base_model.dart';

class Questionario extends FirestoreModel{
  static final String collection = "Questionario";

  String userId;

  String usuarioNomeProjeto; //campo duplicado Usuario.nomeProjeto

  String nome;

  String dataCriacao;

  String eixoId;

  String eixoNome;

  Questionario({
    String id,
    this.userId,
    this.usuarioNomeProjeto,
    this.nome,
    this.dataCriacao,
    this.eixoId,
    this.eixoNome,
  }) : super(id);

  @override
  Questionario fromMap(Map<String, dynamic> map) {
    return null;
  }

  @override
  Map<String, dynamic> toMap() {
    return {

    };
  }
}
