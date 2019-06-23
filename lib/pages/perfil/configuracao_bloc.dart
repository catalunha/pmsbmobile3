import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pmsbmibile3/models/perfis_usuarios_model.dart';
import 'package:pmsbmibile3/models/eixos_model.dart';
import 'package:pmsbmibile3/models/setores_censitarios_model.dart';

class ConfiguracaoBloc {
  BehaviorSubject<String> _userId = BehaviorSubject<String>();

  BehaviorSubject<PerfilUsuarioModel> _perfil =
      BehaviorSubject<PerfilUsuarioModel>();

  Stream<PerfilUsuarioModel> get perfil => _perfil.stream;

  BehaviorSubject<List<EixoModel>> _eixos = BehaviorSubject<List<EixoModel>>();

  BehaviorSubject<List<SetorCensitarioModel>> _setoresCensitarios =
      BehaviorSubject<List<SetorCensitarioModel>>();

  Stream<List<SetorCensitarioModel>> get setores => _setoresCensitarios.stream;

  BehaviorSubject<String> _numeroCelular = BehaviorSubject<String>();

  get numeroCelular => _numeroCelular.stream;

  Function get updateNumeroCelular => _numeroCelular.sink.add;

  BehaviorSubject<String> _nomeProjeto = BehaviorSubject<String>();

  Function get updateNomeProjeto => _nomeProjeto.sink.add;
  BehaviorSubject<String> _imagemPerfil = BehaviorSubject<String>();

  Function get updateImagemPerfil => _imagemPerfil.sink.add;

  StreamController<bool> _processForm = BehaviorSubject<bool>();
  StreamController<bool> _validForm = BehaviorSubject<bool>();

  get isValidForm => _validForm.stream;

  get processForm => _processForm.sink.add;
  Observable<bool> save;

  ConfiguracaoBloc() {
    //retorna somente id do usuario caso esteja logado
    FirebaseAuth.instance.onAuthStateChanged.where((user) => user != null).map((user)=>user.uid).pipe(_userId);

    //pega lista de eixos

    Firestore.instance.collection(SetorCensitarioModel.collection).snapshots().map((snap) {
      return snap.documents
          .map((doc) =>
              SetorCensitarioModel.fromMap({"id": doc.documentID, ...doc.data}))
          .toList();
    }).pipe(_setoresCensitarios);

    _userId.stream.listen(setUpUser);
    save = Observable.combineLatest2(
      _numeroCelular.stream,
      _nomeProjeto.stream,
      (String numeroCelular, String nomeProjeto) {
        print("dados $numeroCelular, $nomeProjeto");
        return true;
      },
    );
    save.pipe(_validForm);
  }

  PerfilUsuarioModel perfilSnapToInstance(DocumentSnapshot snap) {
    return PerfilUsuarioModel.fromMap({
      "id": snap.documentID,
      ...snap.data,
    });
  }

  void setUpUser(String userId) {
    Firestore.instance
        .collection(PerfilUsuarioModel.collection)
        .document(userId)
        .snapshots()
        .map(perfilSnapToInstance)
        .pipe(_perfil);
  }

  void validFormData(bool v, StreamSink<bool> sink) {
    print("validade form");
    sink.add(true);
  }

  void dispose() {
    _perfil.close();
    _processForm.close();
    _nomeProjeto.close();
    _userId.close();
  }
}
