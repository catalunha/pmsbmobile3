import 'package:cloud_firestore/cloud_firestore.dart';

class NoticiaModel {
  static final String collection = "noticias";
  String id;
  String conteudoMarkdown;
  Timestamp dataPublicacao;
  String userId;
  String titulo;

  NoticiaModel({
    this.id,
    this.userId,
    this.conteudoMarkdown,
    this.dataPublicacao,
    this.titulo,
  });

  factory NoticiaModel.fromFirestore(DocumentSnapshot ref) {
    return NoticiaModel(
      id: ref.documentID,
      userId: ref.data['userId'] ?? 'userId',
      conteudoMarkdown: ref.data['conteudo_markdown'] ?? 'conteudo_markdown',
      dataPublicacao: ref.data['data_publicacao'] ?? 'data_publicacao',
      titulo: ref.data['titulo'],
    );
  }

}
