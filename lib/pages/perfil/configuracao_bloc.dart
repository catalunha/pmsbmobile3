import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pmsbmibile3/models/perfis_usuarios_model.dart';
import 'package:pmsbmibile3/models/eixos_model.dart';
import 'package:pmsbmibile3/models/setores_censitarios_model.dart';
import 'package:pmsbmibile3/models/arquivos_usuarios_model.dart';
import 'package:pmsbmibile3/state/upload_bloc.dart';

class FormState {
  PerfilUsuarioModel currentPerfilUsuario;
  String nomeProjeto;
  String numeroCelular;

  String filePath;
  dynamic imagemPerfil;
  String imagemPerfilUrl;

  @override
  String toString() => "$nomeProjeto, $numeroCelular, $filePath";
}

class ConfiguracaoBloc {
  final formState = FormState();
  final uploadBloc = UploadBloc();

  BehaviorSubject<String> _userId = BehaviorSubject<String>();

  BehaviorSubject<PerfilUsuarioModel> _perfil =
      BehaviorSubject<PerfilUsuarioModel>();

  Stream<PerfilUsuarioModel> get perfil => _perfil.stream;

  BehaviorSubject<List<EixoModel>> _eixos = BehaviorSubject<List<EixoModel>>();

  BehaviorSubject<List<SetorCensitarioModel>> _setoresCensitarios =
      BehaviorSubject<List<SetorCensitarioModel>>();

  Stream<List<SetorCensitarioModel>> get setores => _setoresCensitarios.stream;

  //numero celular
  BehaviorSubject<String> _numeroCelular = BehaviorSubject<String>();

  get numeroCelular => _numeroCelular.stream;

  Function get updateNumeroCelular => _numeroCelular.sink.add;

  //nome projeto
  BehaviorSubject<String> _nomeProjeto = BehaviorSubject<String>();

  Function get updateNomeProjeto => _nomeProjeto.sink.add;

  //imagem perfil
  BehaviorSubject<String> _imagemPerfil = BehaviorSubject<String>();

  Function get updateImagemPerfil => _imagemPerfil.sink.add;

  //form
  StreamController<bool> _processForm = BehaviorSubject<bool>();

  get processForm => _processForm.sink.add;

  Observable<bool> formSaved;

  ConfiguracaoBloc() {
    //retorna somente id do usuario caso esteja logado
    FirebaseAuth.instance.onAuthStateChanged
        .where((user) => user != null)
        .map((user) => user.uid)
        .pipe(_userId);

    //pega lista de eixos
    Firestore.instance
        .collection(SetorCensitarioModel.collection)
        .snapshots()
        .map((snap) {
      return snap.documents
          .map((doc) =>
              SetorCensitarioModel.fromMap({"id": doc.documentID, ...doc.data}))
          .toList();
    }).pipe(_setoresCensitarios);

    _userId.stream.listen(setUpUser);

    //update state
    _perfil.stream.listen(perfilUpdateFormState);
    _numeroCelular.listen(numeroCelularUpdateState);
    _nomeProjeto.listen(nomeProjetoUpdateState);
    _imagemPerfil.listen(_imagemPerfilUpload);
    uploadBloc.arquivo.listen(_imagemPerfilUpdateState); //update informação do perfil

    //processa formulario
    formSaved = Observable.combineLatest2(
        _processForm.stream, _userId.stream, processFormState);
    formSaved.listen((_) => _);
  }

  PerfilUsuarioModel perfilSnapToInstance(DocumentSnapshot snap) {
    var user = PerfilUsuarioModel.fromMap({
      "id": snap.documentID,
      ...snap.data,
    });
    return user;
  }

  void setUpUser(String userId) {
    Firestore.instance
        .collection(PerfilUsuarioModel.collection)
        .document(userId)
        .snapshots()
        .where((snap) => snap.exists)
        .map(perfilSnapToInstance)
        .pipe(_perfil);
  }

  void numeroCelularUpdateState(String numeroCelular) {
    formState.numeroCelular = numeroCelular;
  }

  void nomeProjetoUpdateState(String nomeProjeto) {
    formState.nomeProjeto = nomeProjeto;
  }

  void perfilUpdateFormState(PerfilUsuarioModel perfil) {
    formState.numeroCelular = perfil.celular;
    formState.nomeProjeto = perfil.nomeProjeto;
  }

  bool processFormState(bool flag, String userId) {
    Firestore.instance
        .collection(PerfilUsuarioModel.collection)
        .document(userId)
        .setData({
      ...PerfilUsuarioModel(
        id: userId,
        nomeProjeto: formState.nomeProjeto,
        celular: formState.numeroCelular,
        imagemPerfil: formState.imagemPerfil,
        imagemPerfilUrl: formState.imagemPerfilUrl,
      ).toMap(),
    }, merge: true);
    return true;
  }

  void dispose() {
    _perfil.close();
    _processForm.close();
    _nomeProjeto.close();
    _userId.close();
    _setoresCensitarios.close();
    _eixos.close();
  }

  //upload file
  void _imagemPerfilUpload(String filepath) {
    formState.filePath = filepath;
    uploadBloc.uploadFromPath(formState.filePath);
  }

  void _imagemPerfilUpdateState(ArquivoUsuarioModel arquivo) {
    formState.imagemPerfilUrl = arquivo.url;
    formState.imagemPerfil = Firestore.instance.collection(ArquivoUsuarioModel.collection).document(arquivo.id);
  }
}
