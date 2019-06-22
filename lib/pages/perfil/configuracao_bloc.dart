import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pmsbmibile3/models/perfis_usuarios_model.dart';

class ConfiguracaoBloc {
  BehaviorSubject<String> _userId = BehaviorSubject<String>();

  Function get setUserId => _userId.sink.add;

  BehaviorSubject<PerfilUsuarioModel> _perfil =
      BehaviorSubject<PerfilUsuarioModel>();

  Stream<PerfilUsuarioModel> get perfil => _perfil.stream;

  BehaviorSubject<String> _numeroCelular = BehaviorSubject<String>();

  get numeroCelular => _numeroCelular.stream;

  Function get updateNumeroCelular => _numeroCelular.sink.add;

  BehaviorSubject<String> _nomeProjeto = BehaviorSubject<String>();
  Function get updateNomeProjeto => _nomeProjeto.sink.add;
  BehaviorSubject<String> _imagemPerfil = BehaviorSubject<String>();

  StreamController<bool> _processForm = BehaviorSubject<bool>();
  StreamController<bool> _validForm = BehaviorSubject<bool>();
  get isValidForm => _validForm.stream;
  get processForm => _processForm.sink.add;
  Observable<bool> save;

  ConfiguracaoBloc() {
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
        .collection("perfis_usuarios")
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
