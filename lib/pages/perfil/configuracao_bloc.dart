import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pmsbmibile3/models/perfis_usuarios_model.dart';
import 'package:pmsbmibile3/models/eixos_model.dart';
import 'package:pmsbmibile3/models/setores_censitarios_model.dart';
import 'package:pmsbmibile3/models/arquivos_usuarios_model.dart';
import 'package:pmsbmibile3/state/upload_bloc.dart';

class ConfiguracaoEvent {}

class ConfiguracaoUpdateEmailEvent extends ConfiguracaoEvent {
  final String email;

  ConfiguracaoUpdateEmailEvent(this.email);
}

class ConfiguracaoUpdateUserIdEvent extends ConfiguracaoEvent {
  final String userId;

  ConfiguracaoUpdateUserIdEvent(this.userId);
}

class ConfiguracaoSaveEvent extends ConfiguracaoEvent{

}

class ConfiguracaoBlocState {
  PerfilUsuarioModel currentPerfilUsuario;
  String userId;
  String nomeProjeto;
  String numeroCelular;
  String email;

  String filePath;
  dynamic imagemPerfil;
  String imagemPerfilUrl;

  @override
  String toString() => "$nomeProjeto, $numeroCelular, $filePath";
}

class ConfiguracaoBloc {
  final formState = ConfiguracaoBlocState();
  final uploadBloc = UploadBloc();

  final _inputController = BehaviorSubject<ConfiguracaoEvent>();
  final _outputController = BehaviorSubject<ConfiguracaoBlocState>();
  Stream<ConfiguracaoBlocState> get state => _outputController.stream;

  Function get dispatch => _inputController.sink.add;

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

  ConfiguracaoBloc() {
    _inputController.stream.listen(_handleInputEvent);

    //retorna somente id do usuario caso esteja logado
    FirebaseAuth.instance.onAuthStateChanged
        .where((user) => user != null)
        .map((user) => user.uid)
        .listen((userId) {
      dispatch(ConfiguracaoUpdateUserIdEvent(userId));
    });

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

    //update state
    _perfil.stream.listen(perfilUpdateConfiguracaoBlocState);
    _numeroCelular.listen(numeroCelularUpdateState);
    _nomeProjeto.listen(nomeProjetoUpdateState);
    _imagemPerfil.listen(_imagemPerfilUpload);
    uploadBloc.arquivo
        .listen(_imagemPerfilUpdateState); //update informação do perfil
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

  void perfilUpdateConfiguracaoBlocState(PerfilUsuarioModel perfil) {
    formState.numeroCelular = perfil.celular;
    formState.nomeProjeto = perfil.nomeProjeto;
    formState.imagemPerfilUrl = perfil.imagemPerfilUrl;
    formState.imagemPerfil = perfil.imagemPerfil;
  }

  bool processConfiguracaoBlocState(String userId) {
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
        email: formState.email,
      ).toMap(),
    }, merge: true);
    return true;
  }

  void dispose() {
    _perfil.close();
    _processForm.close();
    _nomeProjeto.close();
    _setoresCensitarios.close();
    _eixos.close();
    _inputController.close();
  }

  //upload file
  void _imagemPerfilUpload(String filepath) {
    formState.filePath = filepath;
    uploadBloc.uploadFromPath(formState.filePath);
  }

  void _imagemPerfilUpdateState(ArquivoUsuarioModel arquivo) {
    formState.imagemPerfilUrl = arquivo.url;
    formState.imagemPerfil = Firestore.instance
        .collection(ArquivoUsuarioModel.collection)
        .document(arquivo.id);
  }

  void _handleInputEvent(ConfiguracaoEvent event) {
    if (event is ConfiguracaoUpdateEmailEvent) {
      formState.email = event.email;
    }
    if (event is ConfiguracaoUpdateUserIdEvent) {
      formState.userId = event.userId;
      setUpUser(event.userId);
    }
    if (event is ConfiguracaoSaveEvent) {
      processConfiguracaoBlocState(formState.userId);
    }


    _outputController.sink.add(formState);
  }
}
