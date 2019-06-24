import 'package:cloud_firestore/cloud_firestore.dart';


class DestinatarioModel{
  String opcao;
  String destinatario;
}

class NoticiaModel {
  static final String collection = "noticias";
  String id;
  String conteudoMarkdown;
  Timestamp dataPublicacao;
  String userId;
  String titulo;
  List<DestinatarioModel> destinatarios;

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
      conteudoMarkdown: ref.data['conteudoMarkdown'] ?? 'conteudoMarkdown',
      dataPublicacao: ref.data['dataPublicacao'] ?? null,
      titulo: ref.data['titulo'],
    );
  }

  Map<String, dynamic> toMap() {
    return{
      "userId":userId,
      "conteudoMarkdown":conteudoMarkdown,
      "dataPublicacao":dataPublicacao,
      "titulo":titulo,
    };
  }

}
