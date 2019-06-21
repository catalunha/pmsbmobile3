import 'package:cloud_firestore/cloud_firestore.dart';

class NoticiaUsuarioModel {
  String id;
  DocumentReference noticia;
  String userId;
  bool visualizada;

  NoticiaUsuarioModel({
    this.id,
    this.userId,
    this.visualizada,
    this.noticia,
  });

  factory NoticiaUsuarioModel.fromFirestore(DocumentSnapshot ref) {
    return NoticiaUsuarioModel(
      id: ref.documentID,
      userId: ref.data['userId'] ?? 'userId',
      visualizada: ref['visualizada'] ?? false,
      noticia: ref['noticia'],
    );
  }

}
