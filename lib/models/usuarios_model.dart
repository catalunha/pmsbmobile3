import 'package:cloud_firestore/cloud_firestore.dart';

class UsuarioModel {
  static final String collection = "usuarios";
  String id;
  String firstName;
  String lastName;
  String username;
  String telefoneCelular;

  UsuarioModel({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.telefoneCelular,
  });

  factory UsuarioModel.fromFirestore(DocumentSnapshot ref) {
    return UsuarioModel(
      id: ref.data['id'] ?? 'id',
      firstName: ref.data['first_name'] ?? 'first_name',
      lastName: ref.data['last_name'] ?? 'last_name',
      username: ref.data['username'] ?? 'username',
      telefoneCelular: ref.data['telefone_celular'],
    );
  }
}
