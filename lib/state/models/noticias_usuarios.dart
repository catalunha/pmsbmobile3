import 'package:cloud_firestore/cloud_firestore.dart';

class NoticiaUsuario {
  String id;
  DocumentReference noticia;
  String userId;
  bool visualizada;

  NoticiaUsuario({
    this.id,
    this.userId,
    this.visualizada,
    this.noticia,
  });

  factory NoticiaUsuario.fromFirestore(DocumentSnapshot ref) {
    return NoticiaUsuario(
      id: ref.documentID,
      userId: ref.data['userId'] ?? 'userId',
      visualizada: ref['visualizada'] ?? false,
      noticia: ref['noticia'],
    );
  }

}
