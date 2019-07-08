import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/setor_censitario_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:pmsbmibile3/models/eixo_model.dart';
import 'package:pmsbmibile3/models/arquivo_model.dart';
import 'package:pmsbmibile3/state/upload_bloc.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

class ConfiguracaoEvent {}

class ConfiguracaoUpdateNomeProjetoEvent extends ConfiguracaoEvent {
  final String nomeProjeto;

  ConfiguracaoUpdateNomeProjetoEvent(this.nomeProjeto);
}

class UpdateSetorCensitarioConfiguracaoUpdateNomeProjetoEvent extends ConfiguracaoEvent{
  final String setorId;
  final String setorNome;

  UpdateSetorCensitarioConfiguracaoUpdateNomeProjetoEvent(this.setorId, this.setorNome);
}

class ConfiguracaoUpdateEmailEvent extends ConfiguracaoEvent {
  final String email;

  ConfiguracaoUpdateEmailEvent(this.email);
}

class ConfiguracaoUpdateUserIdEvent extends ConfiguracaoEvent {
  final String userId;

  ConfiguracaoUpdateUserIdEvent(this.userId);
}

class ConfiguracaoUpdateCelularEvent extends ConfiguracaoEvent {
  final String celular;

  ConfiguracaoUpdateCelularEvent(this.celular);
}

class ConfiguracaoSaveEvent extends ConfiguracaoEvent {}

class ConfiguracaoBlocState {
  UsuarioModel currentPerfilUsuario;
  String userId;
  String nomeProjeto;
  String numeroCelular;
  String email;
  String setorCensitarioId;
  String setorCensitarioNome;
  String eixoAtualId;
  String eixoAtualNome;

  String filePath;
  dynamic imagemPerfil;
  String imagemPerfilUrl;

  @override
  String toString() => "$email $nomeProjeto, $numeroCelular, $filePath";
}

class ConfiguracaoBloc {
  final fsw.Firestore _firestore;
  final formState = ConfiguracaoBlocState();
  final uploadBloc = UploadBloc(Bootstrap.instance.firestore);

  final _inputController = BehaviorSubject<ConfiguracaoEvent>();
  final _outputController = BehaviorSubject<ConfiguracaoBlocState>();

  Stream<ConfiguracaoBlocState> get state => _outputController.stream;

  Function get dispatch => _inputController.sink.add;

  BehaviorSubject<UsuarioModel> _perfil = BehaviorSubject<UsuarioModel>();

  Stream<UsuarioModel> get perfil => _perfil.stream;

  BehaviorSubject<List<EixoModel>> _eixos = BehaviorSubject<List<EixoModel>>();

  BehaviorSubject<List<SetorCensitarioModel>> _setoresCensitarios =
      BehaviorSubject<List<SetorCensitarioModel>>();

  Stream<List<SetorCensitarioModel>> get setores => _setoresCensitarios.stream;

  //imagem perfil
  BehaviorSubject<String> _imagemPerfil = BehaviorSubject<String>();

  Function get updateImagemPerfil => _imagemPerfil.sink.add;

  //form
  StreamController<bool> _processForm = BehaviorSubject<bool>();

  get processForm => _processForm.sink.add;

  ConfiguracaoBloc(this._firestore) {
    _inputController.stream.listen(_handleInputEvent);

    //retorna somente id do usuario caso esteja logado
    FirebaseAuth.instance.onAuthStateChanged
        .where((user) => user != null)
        .map((user) => user.uid)
        .listen((userId) {
      dispatch(ConfiguracaoUpdateUserIdEvent(userId));
    });

    //pega lista de eixos
    _firestore
        .collection(SetorCensitarioModel.collection)
        .snapshots()
        .map((snap) {
      return snap.documents
          .map((doc) =>
              SetorCensitarioModel(id: doc.documentID).fromMap(doc.data))
          .toList();
    }).pipe(_setoresCensitarios);

    //update state
    _perfil.stream.listen(perfilUpdateConfiguracaoBlocState);
    _imagemPerfil.listen(_imagemPerfilUpload);
    uploadBloc.arquivo
        .listen(_imagemPerfilUpdateState); //update informação do perfil
  }

  UsuarioModel perfilSnapToInstance(fsw.DocumentSnapshot snap) {
    var user = UsuarioModel().fromMap({
      "id": snap.documentID,
      ...snap.data,
    });
    return user;
  }

  void setUpUser(String userId) {
    _firestore
        .collection(UsuarioModel.collection)
        .document(userId)
        .snapshots()
        .where((snap) => snap.exists)
        .map(perfilSnapToInstance)
        .pipe(_perfil);
  }


  void perfilUpdateConfiguracaoBlocState(UsuarioModel perfil) {
    formState.numeroCelular = perfil.celular;
    formState.nomeProjeto = perfil.nomeProjeto;
    formState.imagemPerfilUrl = perfil.imagemPerfilUrl;
    formState.imagemPerfil = perfil.imagemPerfilId;
    formState.setorCensitarioNome = perfil.setorCensitarioNome;
    formState.setorCensitarioId = perfil.setorCensitarioId;
    formState.eixoAtualId = perfil.eixoAtualId;
    formState.eixoAtualNome = perfil.eixoAtualNome;
    dispatch(ConfiguracaoSaveEvent());
  }

  bool processConfiguracaoBlocState(String userId) {
    _firestore
        .collection(UsuarioModel.collection)
        .document(userId)
        .setData({
      ...UsuarioModel(
        id: userId,
        nomeProjeto: formState.nomeProjeto,
        celular: formState.numeroCelular,
        imagemPerfilId: formState.imagemPerfil,
        imagemPerfilUrl: formState.imagemPerfilUrl,
        email: formState.email,
        setorCensitarioId: formState.setorCensitarioId,
        setorCensitarioNome: formState.setorCensitarioNome,
      ).toMap(),
    }, merge: true);
    return true;
  }

  void dispose() {
    _perfil.close();
    _processForm.close();
    _setoresCensitarios.close();
    _eixos.close();
    _inputController.close();
    _outputController.close();
  }

  //upload file
  void _imagemPerfilUpload(String filepath) {
    formState.filePath = filepath;
    uploadBloc.uploadFromPath(formState.filePath);
  }

  void _imagemPerfilUpdateState(ArquivoModel arquivo) {
    formState.imagemPerfilUrl = arquivo.url;
    formState.imagemPerfil = _firestore
        .collection(ArquivoModel.collection)
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
    if (event is ConfiguracaoUpdateNomeProjetoEvent) {
      formState.nomeProjeto = event.nomeProjeto;
    }
    if(event is UpdateSetorCensitarioConfiguracaoUpdateNomeProjetoEvent){
      formState.setorCensitarioId = event.setorId;
      formState.setorCensitarioNome = event.setorNome;
    }
    _outputController.sink.add(formState);
  }
}
