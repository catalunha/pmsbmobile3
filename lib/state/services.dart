import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:pmsbmibile3/state/models/usuarios.dart';
import 'package:pmsbmibile3/state/models/noticias.dart';
import 'package:pmsbmibile3/state/models/noticias_usuarios.dart';
import 'package:meta/meta.dart';

class DatabaseService {
  final Firestore _firestore = Firestore.instance;

  Future<Usuario> getUsuario(String id) async {
    var snap = await _firestore.collection("usuarios").document(id).get();
    return Usuario.fromFirestore(snap);
  }

  Stream<Usuario> streamUsuario(String id) {
    return _firestore
        .collection("usuarios")
        .document(id)
        .snapshots()
        .map((snap) => Usuario.fromFirestore(snap));
  }

  Stream<List<NoticiaUsuario>> streamNoticiasUsuarios({
    @required String userId,
    @required bool visualizada,
  }) {
    return _firestore
        .collection("noticias_usuarios")
        .where("userId", isEqualTo: userId)
        .where("visualizada", isEqualTo: visualizada)
        .snapshots()
        .map((snap) => snap.documents
            .map((doc) => NoticiaUsuario.fromFirestore(doc))
            .toList());
  }

  Stream<Noticia> streamNoticiaByDocumentReference(DocumentReference ref) {
    return ref.snapshots().map((doc) => Noticia.fromFirestore(doc));
  }

  Stream<List<Future<Noticia>>> streamNoticias(
      {@required String userId, bool visualizada = false}) {
    return _firestore
        .collection("noticias_usuarios")
        .where("userId", isEqualTo: userId)
        .where("visualizada", isEqualTo: visualizada)
        .snapshots()
        .map((snap) => snap.documents
            .map((docSnap) async =>
                Noticia.fromFirestore(await docSnap['noticia'].get()))
            .toList());
  }

  Future<void> marcarNoticiaUsuarioVisualizada(String noticiaUsuarioId) {
    _firestore
        .collection("noticias_usuarios")
        .document(noticiaUsuarioId)
        .setData({
      "visualizada": true,
    }, merge: true);
    return Future.delayed(Duration.zero);
  }
}
