import 'dart:async';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';
import 'package:pmsbmibile3/models/setor_censitario_model.dart';
import 'package:pmsbmibile3/models/upload_model.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

/// Class base Eventos da Pagina ConfiguracaoPage
class ConfiguracaoPageEvent {}

class UpdateUsuarioIDEvent extends ConfiguracaoPageEvent {}

class PullSetorCensitarioEvent extends ConfiguracaoPageEvent {}

class UpdateNomeEvent extends ConfiguracaoPageEvent {
  final String nomeProjeto;

  UpdateNomeEvent(this.nomeProjeto);
}

class UpdateSetorCensitarioEvent extends ConfiguracaoPageEvent {
  final String setorId;
  final String setorNome;

  UpdateSetorCensitarioEvent(this.setorId, this.setorNome);
}

class UpdateEixoIDAtualEvent extends ConfiguracaoPageEvent {
  final String eixoId;
  final String eixoNome;

  UpdateEixoIDAtualEvent(this.eixoId, this.eixoNome);
}

class UpdateCelularEvent extends ConfiguracaoPageEvent {
  final String celular;

  UpdateCelularEvent(this.celular);
}

class UpdateFotoEvent extends ConfiguracaoPageEvent {
  final String fotoLocalPath;

  UpdateFotoEvent(this.fotoLocalPath);
}

class SaveEvent extends ConfiguracaoPageEvent {}

/// Class base Estado da Pagina ConfiguracaoPage
class ConfiguracaoPageState {
  UsuarioModel usuarioModel;

  String usuarioID;
  String nome;
  String celular;
  String fotoUploadID;
  String fotoUrl;
  String fotoLocalPath;
  String setorCensitarioIDId;
  String setorCensitarioIDnome;
  String eixoIDAtualId;
  String eixoIDAtualNome;

  void updateStateFromUsuarioModel() {
    usuarioID = usuarioModel.id;
    nome = usuarioModel.nome;
    celular = usuarioModel.celular;
    fotoUrl = usuarioModel.foto?.url;
    fotoLocalPath = usuarioModel?.foto?.localPath;
    fotoUploadID = usuarioModel?.foto?.uploadID;
    setorCensitarioIDId = usuarioModel.setorCensitarioID.id;
    setorCensitarioIDnome = usuarioModel.setorCensitarioID.nome;
    eixoIDAtualId = usuarioModel.eixoIDAtual.id;
    eixoIDAtualNome = usuarioModel.eixoIDAtual.nome;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['usuarioID'] = this.usuarioID;
    data['nome'] = this.nome;
    data['celular'] = this.celular;
    data['fotoUrl'] = this.fotoUrl;
    data['fotoLocalPath'] = this.fotoLocalPath;
    return data;
  }

  @override
  String toString() => "$nome, $celular";
}

/// class Bloc para ConfiguracaoPage
class ConfiguracaoPageBloc {
  final fsw.Firestore _firestore;

  // Authenticacação
  AuthBloc _authBloc;

  // Eventos da Página
  final _eventController = BehaviorSubject<ConfiguracaoPageEvent>();
  Stream<ConfiguracaoPageEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  // Estados da Página
  final ConfiguracaoPageState _state = ConfiguracaoPageState();
  final _stateController = BehaviorSubject<ConfiguracaoPageState>();
  Stream<ConfiguracaoPageState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  // UsuarioModel
  BehaviorSubject<UsuarioModel> _usuarioModelController =
      BehaviorSubject<UsuarioModel>();
  Stream<UsuarioModel> get usuarioModelStream => _usuarioModelController.stream;
  Function get usuarioModelSink => _usuarioModelController.sink.add;

// SetorCensitarioModel
  BehaviorSubject<List<SetorCensitarioModel>>
      _setorCensitarioModelListController =
      BehaviorSubject<List<SetorCensitarioModel>>();
  Stream<List<SetorCensitarioModel>> get setorCensitarioModelListStream =>
      _setorCensitarioModelListController.stream;

  ConfiguracaoPageBloc(this._firestore, this._authBloc) {
    eventStream.listen(_mapEventToState);
  }
  void dispose() async {
    await _eventController.drain();
    _eventController.close();
    await _stateController.drain();
    _stateController.close();
    await _usuarioModelController.drain();
    _usuarioModelController.close();
    await _setorCensitarioModelListController.drain();
    _setorCensitarioModelListController.close();
  }

  void _mapEventToState(ConfiguracaoPageEvent event) async {
    if (event is UpdateUsuarioIDEvent) {
      _authBloc.perfil.listen((usuario) {
        _state.usuarioModel = usuario;
        usuarioModelSink(usuario);
        _state.updateStateFromUsuarioModel();
      });
    }
    if (event is PullSetorCensitarioEvent) {
      _firestore
          .collection(SetorCensitarioModel.collection)
          .snapshots()
          .map((snap) => snap.documents
              .map((doc) =>
                  SetorCensitarioModel(id: doc.documentID).fromMap(doc.data))
              .toList())
          .pipe(_setorCensitarioModelListController);
    }
    if (event is SaveEvent) {
      if (_state.fotoUploadID != null && _state.fotoUrl == null) {
        final docRef = _firestore
            .collection(UploadModel.collection)
            .document(_state.fotoUploadID);
        await docRef.delete();
        _state.fotoUploadID = null;
      }
      if (_state.fotoLocalPath != null) {
        //+++ Cria doc em UpLoadCollection
        final upLoadModel = UploadModel(
          usuario: _state.usuarioID,
          localPath: _state.fotoLocalPath,
          upload: false,
          updateCollection: UpdateCollection(
              collection: UsuarioModel.collection,
              document: _state.usuarioID,
              field: "foto.url"),
        );
        final docRef = _firestore
            .collection(UploadModel.collection)
            .document(_state.fotoUploadID);
        await docRef.setData(upLoadModel.toMap(), merge: true);
        _state.fotoUploadID = docRef.documentID;

        //--- Cria doc em UpLoadCollection
      }
      UploadID foto = UploadID(
          uploadID: _state.fotoUploadID, localPath: _state.fotoLocalPath);
      // final Map<dynamic, dynamic> foto = new Map<dynamic, dynamic>();
      // foto['uploadID'] = _state.fotoUploadID;
      // foto['localPath'] = _state.fotoLocalPath;
      // foto['url'] = Bootstrap.instance.FieldValue.delete();

      SetorCensitarioID setorCensitarioID = SetorCensitarioID(
          id: _state.setorCensitarioIDId, nome: _state.setorCensitarioIDnome);
      EixoID eixoIDAtual =
          EixoID(id: _state.eixoIDAtualId, nome: _state.eixoIDAtualNome);
      final docRef2 = _firestore
          .collection(UsuarioModel.collection)
          .document(_state.usuarioID);
      final Map<String, dynamic> usuarioModel = new Map<String, dynamic>();

      // UsuarioModel usuarioModel = UsuarioModel(
      usuarioModel['nome'] = _state.nome;
      usuarioModel['celular'] = _state.celular;
      usuarioModel['setorCensitarioID'] = setorCensitarioID.toMap();
      usuarioModel['eixoIDAtual'] = eixoIDAtual.toMap();
      // );
      if (_state.fotoUrl == null) {
        usuarioModel['foto'] = foto.toMapFirestore();
      }
      await docRef2.setData(usuarioModel, merge: true);
    }
    if (event is UpdateNomeEvent) {
      _state.nome = event.nomeProjeto;
    }
    if (event is UpdateCelularEvent) {
      _state.celular = event.celular;
    }
    if (event is UpdateSetorCensitarioEvent) {
      _state.setorCensitarioIDId = event.setorId;
      _state.setorCensitarioIDnome = event.setorNome;
    }
    if (event is UpdateEixoIDAtualEvent) {
      _state.eixoIDAtualId = event.eixoId;
      _state.eixoIDAtualNome = event.eixoNome;
    }
    if (event is UpdateFotoEvent) {
      _state.fotoLocalPath = event.fotoLocalPath;
      _state.fotoUrl = null;
    }

    if (!_stateController.isClosed) _stateController.add(_state);
    // print('>>> _state.toMap() <<< ${_state.toMap()}');
    print('event.runtimeType em ConfiguracaoPageBloc  = ${event.runtimeType}');
  }
}
