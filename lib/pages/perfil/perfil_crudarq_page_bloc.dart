import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pmsbmibile3/models/usuario_perfil_model2.dart';

import 'package:pmsbmibile3/api/api.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

class PerfilCRUDArqPageEvent {}

class UpDateUsuarioPerfilIDEvent extends PerfilCRUDArqPageEvent {
  final String usuarioPerfilID;

  UpDateUsuarioPerfilIDEvent(this.usuarioPerfilID);
}

class UpDateArquivoLocalEvent extends PerfilCRUDArqPageEvent {
  final String arquivoLocal;

  UpDateArquivoLocalEvent(this.arquivoLocal);
}

class PerfilCRUDArqPageState {
  String usuarioPerfilID;
  String arquivoLocal;
  String usuarioArquivoIDurl;
  @override
  String toString() {
    // TODO: implement toString
    return 'PerfilCRUDArqPageState.toString: usuarioPerfilID: $usuarioPerfilID | arquivo:$arquivoLocal | usuarioArquivoIDurl:$usuarioArquivoIDurl';
  }
}

class PerfilCRUDArqPageBloc {
  // Database
  final fsw.Firestore _firestore;

  // Eventos
  final _perfilCRUDArqPageEventController =
      BehaviorSubject<PerfilCRUDArqPageEvent>();
  Function get perfilCRUDArqPageEventSink =>
      _perfilCRUDArqPageEventController.sink.add;
  Stream<PerfilCRUDArqPageEvent> get perfilCRUDArqPageEventStream =>
      _perfilCRUDArqPageEventController.stream;

  // Estados
  PerfilCRUDArqPageState perfilCRUDArqPageState = PerfilCRUDArqPageState();
  final _perfilCRUDArqPageStateController =
      BehaviorSubject<PerfilCRUDArqPageState>();
  Stream<PerfilCRUDArqPageState> get perfilCRUDArqPageStateStream =>
      _perfilCRUDArqPageStateController.stream;
  Function get perfilCRUDArqPageStateSink =>
      _perfilCRUDArqPageStateController.sink.add;

  //UsuarioPerfilModel
  final _usuarioPerfilModelController = BehaviorSubject<UsuarioPerfilModel>();
  Stream<UsuarioPerfilModel> get usuarioPerfilModelStream =>
      _usuarioPerfilModelController.stream;

  PerfilCRUDArqPageBloc(this._firestore) {
    perfilCRUDArqPageEventStream.listen(_mapEventToState);
  }

  void dispose() {
    _perfilCRUDArqPageStateController.close();
    _usuarioPerfilModelController.close();
  }

  _mapEventToState(PerfilCRUDArqPageEvent event) {
    if (event is UpDateUsuarioPerfilIDEvent) {
      perfilCRUDArqPageState.usuarioPerfilID = event.usuarioPerfilID;
      _firestore
          .collection(UsuarioPerfilModel.collection)
          .document(event.usuarioPerfilID)
          .snapshots()
          .map((snapDocs) => UsuarioPerfilModel(id: snapDocs.documentID)
              .fromMap(snapDocs.data))
          .pipe(_usuarioPerfilModelController);
      usuarioPerfilModelStream.listen((usuarioPerfilModel) {
        print('>> usuarioPerfilModel CRUDArqPage >> ${usuarioPerfilModel}');
        perfilCRUDArqPageState.usuarioArquivoIDurl =
            usuarioPerfilModel.usuarioArquivoID?.url;
      });
    }
    if (event is UpDateArquivoLocalEvent) {
      print('>> event.arquivoLocal >> ${event.arquivoLocal}');

      perfilCRUDArqPageState.arquivoLocal = event.arquivoLocal;
      perfilCRUDArqPageStateSink(perfilCRUDArqPageState);
    }
    perfilCRUDArqPageStateSink(perfilCRUDArqPageState);

    print('Oiiii');
    print(
        '>> perfilCRUDArqPageState.toString() >> ${perfilCRUDArqPageState.toString()}');
  }
}
