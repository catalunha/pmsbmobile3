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

/// Class base Eventos da Pagina ConfiguracaoPage
class ConfiguracaoPageEvent {}

class UpdateNomeEvent extends ConfiguracaoPageEvent {
  final String nomeProjeto;

  UpdateNomeEvent(this.nomeProjeto);
}

class UpdateSetorCensitarioEvent extends ConfiguracaoPageEvent {
  final String setorId;
  final String setorNome;

  UpdateSetorCensitarioEvent(this.setorId, this.setorNome);
}

class UpdateEmailEvent extends ConfiguracaoPageEvent {
  final String email;

  UpdateEmailEvent(this.email);
}

class UpdateUserIdEvent extends ConfiguracaoPageEvent {
  final String userId;

  UpdateUserIdEvent(this.userId);
}

class UpdateCelularEvent extends ConfiguracaoPageEvent {
  final String celular;

  UpdateCelularEvent(this.celular);
}

class ConfiguracaoSaveEvent extends ConfiguracaoPageEvent {}

/// Class base Estado da Pagina ConfiguracaoPage
class ConfiguracaoPageState {
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

/// class Bloc para ConfiguracaoPage
class ConfiguracaoPageBloc {
  final fsw.Firestore _firestore;

  final uploadBloc = UploadBloc(Bootstrap.instance.firestore);

  // Estados da Página
  final ConfiguracaoPageState pageState = ConfiguracaoPageState();
  final _outputController = BehaviorSubject<ConfiguracaoPageState>();
  Stream<ConfiguracaoPageState> get state => _outputController.stream;

  // Eventos da Página
  final _configuracaoPageEventController =
      BehaviorSubject<ConfiguracaoPageEvent>();
  Stream<ConfiguracaoPageEvent> get configuracaoPageEventStream =>
      _configuracaoPageEventController.stream;
  Function get configuracaoPageEventSink =>
      _configuracaoPageEventController.sink.add;

  // UsuarioModel
  BehaviorSubject<UsuarioModel> _usuarioModelController =
      BehaviorSubject<UsuarioModel>();

  Stream<UsuarioModel> get usuarioModelStream => _usuarioModelController.stream;

  Function get usuarioModelSink => _usuarioModelController.sink.add;

  // EixoModel
  BehaviorSubject<List<EixoModel>> _eixoModelList =
      BehaviorSubject<List<EixoModel>>();

// SetorCensitarioModel
  BehaviorSubject<List<SetorCensitarioModel>> _setorCensitarioModelList =
      BehaviorSubject<List<SetorCensitarioModel>>();

  Stream<List<SetorCensitarioModel>> get setorCensitarioModelListStream =>
      _setorCensitarioModelList.stream;

  //Imagem usuario. Pra que stream ?
  BehaviorSubject<String> _imagemPerfil = BehaviorSubject<String>();

  Function get updateImagemPerfil => _imagemPerfil.sink.add;

  //form
  StreamController<bool> _processForm = BehaviorSubject<bool>();

  get processForm => _processForm.sink.add;

  ConfiguracaoPageBloc(this._firestore) {
    configuracaoPageEventStream.listen(_mapEventToState);

    //retorna somente id do usuario caso esteja logado
    FirebaseAuth.instance.onAuthStateChanged
        .where((user) => user != null)
        .map((user) => user.uid)
        .listen((userId) {
      configuracaoPageEventSink(UpdateUserIdEvent(userId));
    });

    //pega lista de eixos
    _firestore
        .collection(SetorCensitarioModel.collection)
        .snapshots()
        .map((snap) => snap.documents
            .map((doc) =>
                SetorCensitarioModel(id: doc.documentID).fromMap(doc.data))
            .toList())
        .pipe(_setorCensitarioModelList);

    //update state
    usuarioModelStream.listen(perfilUpdateConfiguracaoBlocState);
    _imagemPerfil.listen(_imagemPerfilUpload);
    uploadBloc.arquivo
        .listen(_imagemPerfilUpdateState); //update informação do perfil
  }

  void dispose() {
    _usuarioModelController.close();
    _processForm.close();
    _setorCensitarioModelList.close();
    _eixoModelList.close();
    _configuracaoPageEventController.close();
    _outputController.close();
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
        .pipe(_usuarioModelController);
  }

  void perfilUpdateConfiguracaoBlocState(UsuarioModel perfil) {
    pageState.numeroCelular = perfil.celular;
    pageState.nomeProjeto = perfil.nome;
    pageState.imagemPerfilUrl = perfil.usuarioArquivoID.url;
    pageState.imagemPerfil = perfil.usuarioArquivoID.id;
    pageState.setorCensitarioNome = perfil.setorCensitarioID.nome;
    pageState.setorCensitarioId = perfil.setorCensitarioID.id;
    pageState.eixoAtualId = perfil.eixoIDAtual.id;
    pageState.eixoAtualNome = perfil.eixoIDAtual.nome;
    configuracaoPageEventSink(ConfiguracaoSaveEvent());
  }

  bool processConfiguracaoBlocState(String userId) {
    UsuarioArquivoID usuarioArquivoID = UsuarioArquivoID(
        id: pageState.imagemPerfil, url: pageState.imagemPerfilUrl);
    SetorCensitarioID setorCensitarioID = SetorCensitarioID(
        id: pageState.setorCensitarioId, nome: pageState.setorCensitarioNome);
    _firestore.collection(UsuarioModel.collection).document(userId).setData({
      ...UsuarioModel(
        id: userId,
        nome: pageState.nomeProjeto,
        celular: pageState.numeroCelular,
        usuarioArquivoID: usuarioArquivoID,
        email: pageState.email,
        setorCensitarioID: setorCensitarioID,
      ).toMap(),
    }, merge: true);
    return true;
  }

  //upload file
  void _imagemPerfilUpload(String filepath) {
    pageState.filePath = filepath;
    uploadBloc.uploadFromPath(pageState.filePath);
  }

  void _imagemPerfilUpdateState(ArquivoModel arquivo) {
    pageState.imagemPerfilUrl = arquivo.url;
    pageState.imagemPerfil =
        _firestore.collection(ArquivoModel.collection).document(arquivo.id);
  }

  void _mapEventToState(ConfiguracaoPageEvent event) {
    // if (event is UpdateEmailEvent) {
    //   pageState.email = event.email;
    // }
    if (event is UpdateUserIdEvent) {
      pageState.userId = event.userId;
      setUpUser(event.userId);
    }
    if (event is ConfiguracaoSaveEvent) {
      processConfiguracaoBlocState(pageState.userId);
    }
    if (event is UpdateNomeEvent) {
      pageState.nomeProjeto = event.nomeProjeto;
    }
    if (event is UpdateSetorCensitarioEvent) {
      pageState.setorCensitarioId = event.setorId;
      pageState.setorCensitarioNome = event.setorNome;
    }
    _outputController.sink.add(pageState);
  }
}
