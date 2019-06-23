import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pmsbmibile3/models/perfis_usuarios_model.dart';

class AuthBloc {
  BehaviorSubject<PerfilUsuarioModel> _perfilController =
      BehaviorSubject<PerfilUsuarioModel>();

  Stream<PerfilUsuarioModel> get perfil => _perfilController.stream;

  AuthBloc() {
    FirebaseAuth.instance.onAuthStateChanged
        .where((user) => user != null)
        .listen(_getPerfilUsuarioFromFirebaseUser);
  }

  void dispose() {
    _perfilController.close();
  }

  void _getPerfilUsuarioFromFirebaseUser(FirebaseUser user) {
    var perfilRef = Firestore.instance
        .collection(PerfilUsuarioModel.collection)
        .document(user.uid);

    perfilRef
        .snapshots()
        .map((perfilSnap) => PerfilUsuarioModel.fromMap(
            {"id": perfilSnap.documentID, ...perfilSnap.data}))
        .pipe(_perfilController);
  }
}
