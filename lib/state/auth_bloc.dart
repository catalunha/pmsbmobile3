import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pmsbmibile3/models/perfis_usuarios_model.dart';

class AuthBloc {
  final _userId = BehaviorSubject<String>();

  Stream<String> get userId => _userId.stream;

  final _perfilController = BehaviorSubject<PerfilUsuarioModel>();
  StreamSubscription<PerfilUsuarioModel> _perfilSubscription;

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
    _perfilSubscription.cancel();
  }

  void _getPerfilUsuarioFromFirebaseUser(FirebaseUser user) {
    final perfilRef = Firestore.instance
        .collection(PerfilUsuarioModel.collection)
        .document(user.uid);

    final perfilStream = perfilRef.snapshots().map((perfilSnap) =>
        PerfilUsuarioModel.fromMap(
            {"id": perfilSnap.documentID, ...perfilSnap.data}));
    //.pipe(_perfilController);
    if (_perfilSubscription != null) {
      _perfilSubscription.cancel().then((_) {
        _perfilSubscription = perfilStream.listen(_pipPerfil);
      });
    } else {
      _perfilSubscription = perfilStream.listen(_pipPerfil);
    }
  }

  void _getUserId(FirebaseUser user) {
    _userId.sink.add(user.uid);
  }

  void _pipPerfil(PerfilUsuarioModel perfil) {
    _perfilController.sink.add(perfil);
  }
}
