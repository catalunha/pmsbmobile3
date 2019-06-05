import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:pmsbmibile3/state/models/usuarios.dart';
import 'package:pmsbmibile3/state/models/noticia.dart';

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

  Stream<List<Future<Noticia>>> streamNoticias(String userId) {
    return _firestore
        .collection("perfis_usuarios")
        .document(userId)
        .collection("noticias")
        .where("visualizada", isEqualTo: false)
        .snapshots()
        .map((snap) => snap.documents
            .map((docSnap) async => Noticia.fromFirestore(await docSnap['noticia'].get()))
            .toList());
  }
}
