import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pmsbmibile3/models/perfis_usuarios_model.dart';

class AuthBloc {

  BehaviorSubject<String> _userId = BehaviorSubject<String>();
  Stream<String> get userId => _userId.stream;

  BehaviorSubject<PerfilUsuarioModel> _perfilController =
      BehaviorSubject<PerfilUsuarioModel>();
  Stream<PerfilUsuarioModel> get perfil => _perfilController.stream;

  AuthBloc() {
    var stream =
        FirebaseAuth.instance.onAuthStateChanged.where((user) => user != null);

    stream.listen(_getPerfilUsuarioFromFirebaseUser);
    stream.listen(_getUserId);
  }

  void dispose() {
    _perfilController.close();
    _userId.close();
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

  void _getUserId(FirebaseUser user) {
    _userId.sink.add(user.uid);
  }
}
