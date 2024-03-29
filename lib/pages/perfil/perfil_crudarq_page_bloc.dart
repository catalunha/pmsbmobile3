import 'dart:async';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';
import 'package:pmsbmibile3/models/upload_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pmsbmibile3/naosuportato/firebase_storage.dart'
    if (dart.library.io) 'package:firebase_storage/firebase_storage.dart';

import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:pmsbmibile3/models/usuario_perfil_model.dart';

class PerfilCRUDArqPageEvent {}

class UpDateUsuarioPerfilIDEvent extends PerfilCRUDArqPageEvent {
  final String usuarioPerfilID;

  UpDateUsuarioPerfilIDEvent(this.usuarioPerfilID);
}

class UpDateArquivoEvent extends PerfilCRUDArqPageEvent {
  final String arquivoLocalPath;

  UpDateArquivoEvent(this.arquivoLocalPath);
}

class SaveEvent extends PerfilCRUDArqPageEvent {}

class PerfilCRUDArqPageState {
  UsuarioPerfilModel usuarioPerfilModel;

  String usuarioPerfilID;

  String arquivoUploadID;
  String arquivoUrl;
  String arquivoLocalPath;

  void updateStateFromUsuarioPerfilModel() {
    arquivoUploadID = usuarioPerfilModel?.arquivo?.uploadID;
    arquivoUrl = usuarioPerfilModel?.arquivo?.url;
    arquivoLocalPath = usuarioPerfilModel?.arquivo?.localPath;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['usuarioPerfilID'] = this.usuarioPerfilID;
    data['arquivoUploadID'] = this.arquivoUploadID;
    data['arquivoUrl'] = this.arquivoUrl;
    data['arquivoLocalPath'] = this.arquivoLocalPath;
    return data;
  }
}

class PerfilCRUDArqPageBloc {
  /// Database
  final fsw.Firestore _firestore;

  /// Eventos
  final _eventController = BehaviorSubject<PerfilCRUDArqPageEvent>();

  Function get eventSink => _eventController.sink.add;

  Stream<PerfilCRUDArqPageEvent> get eventStream => _eventController.stream;

  /// Estados
  PerfilCRUDArqPageState _state = PerfilCRUDArqPageState();
  final _stateController = BehaviorSubject<PerfilCRUDArqPageState>();

  Stream<PerfilCRUDArqPageState> get stateStream => _stateController.stream;

  Function get stateSink => _stateController.sink.add;

  /// UsuarioPerfilModel
  final _usuarioPerfilModelController = BehaviorSubject<UsuarioPerfilModel>();

  Stream<UsuarioPerfilModel> get usuarioPerfilModelStream =>
      _usuarioPerfilModelController.stream;

  PerfilCRUDArqPageBloc(this._firestore) {
    eventStream.listen(_mapEventToState);
  }

  void dispose() async {
    await _stateController.drain();
    _stateController.close();
    await _usuarioPerfilModelController.drain();
    _usuarioPerfilModelController.close();
    await _eventController.drain();
    _eventController.close();
  }

  _mapEventToState(PerfilCRUDArqPageEvent event) async {
    if (event is UpDateUsuarioPerfilIDEvent) {
      _state.usuarioPerfilID = event.usuarioPerfilID;
      final docRef = _firestore
          .collection(UsuarioPerfilModel.collection)
          .document(event.usuarioPerfilID);
      final docSnap = await docRef.get();

      if (docSnap.exists) {
        final usuarioPerfilModel =
            UsuarioPerfilModel(id: docSnap.documentID).fromMap(docSnap.data);
        _state.usuarioPerfilModel = usuarioPerfilModel;
        _state.updateStateFromUsuarioPerfilModel();
      } 
    }
    if (event is UpDateArquivoEvent) {
      _state.arquivoLocalPath = event.arquivoLocalPath;
      _state.arquivoUrl = null;
    }
    if (event is SaveEvent) {
      if (_state.arquivoUploadID != null && _state.arquivoUrl == null) {
        final docRef = _firestore
            .collection(UploadModel.collection)
            .document(_state.arquivoUploadID);
        await docRef.delete();
        _state.arquivoUploadID = null;
      }
      if (_state.arquivoLocalPath != null) {
        //+++ Cria doc em UpLoadCollection
        final upLoadModel = UploadModel(
          usuario: _state.usuarioPerfilModel.usuarioID.id,
          localPath: _state.arquivoLocalPath,
          upload: false,
          updateCollection: UpdateCollection(
              collection: UsuarioPerfilModel.collection,
              document: _state.usuarioPerfilID,
              field: "arquivo.url"),
        );
        final docRef = _firestore
            .collection(UploadModel.collection)
            .document(_state.arquivoUploadID);
        await docRef.setData(upLoadModel.toMap(), merge: true);
        _state.arquivoUploadID = docRef.documentID;
        //--- Cria doc em UpLoadCollection

        UsuarioPerfilModel usuarioPerfilModel = UsuarioPerfilModel(
          arquivo: UploadID(
              uploadID: _state.arquivoUploadID,
              localPath: _state.arquivoLocalPath),
        );
        final docRef2 = _firestore
            .collection(UsuarioPerfilModel.collection)
            .document(_state.usuarioPerfilID);
        await docRef2.setData(usuarioPerfilModel.toMap(), merge: true);
      }
    }

    if (!_stateController.isClosed) _stateController.add(_state);
    print('event.runtimeType em PerfilCRUDArqPageBloc  = ${event.runtimeType}');
  }
}
