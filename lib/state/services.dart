import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:pmsbmibile3/state/models/usuarios.dart';

class DatabaseService {
  final Firestore _firestore = Firestore.instance;

  Future<Usuario> getUsuario(String id) async {
    var snap = await _firestore.collection("usuarios").document(id).get();
    return Usuario.fromFirestore(snap);
  }

  Stream<Usuario> streamUsuario(String id){
    return _firestore
        .collection("usuarios")
        .document(id)
        .snapshots()
        .map((snap) => Usuario.fromFirestore(snap));
  }
}
