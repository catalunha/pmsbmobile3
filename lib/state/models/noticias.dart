import 'package:cloud_firestore/cloud_firestore.dart';

class Noticia {
  String id;
  String conteudoMarkdown;
  Timestamp dataPublicacao;
  String userId;
  String titulo;

  Noticia({
    this.id,
    this.userId,
    this.conteudoMarkdown,
    this.dataPublicacao,
    this.titulo,
  });

  factory Noticia.fromFirestore(DocumentSnapshot ref) {
    return Noticia(
      id: ref.documentID,
      userId: ref.data['userId'] ?? 'userId',
      conteudoMarkdown: ref.data['conteudo_markdown'] ?? 'conteudo_markdown',
      dataPublicacao: ref.data['data_publicacao'] ?? 'data_publicacao',
      titulo: ref.data['titulo'],
    );
  }

}
