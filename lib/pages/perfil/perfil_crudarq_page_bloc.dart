import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/cupertino.dart';
import 'package:pmsbmibile3/state/upload_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pmsbmibile3/models/usuario_perfil_model2.dart';

import 'package:pmsbmibile3/api/api.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:uuid/uuid.dart';

class PerfilCRUDArqPageEvent {}

class UpDateUsuarioPerfilIDEvent extends PerfilCRUDArqPageEvent {
  final String usuarioPerfilID;

  UpDateUsuarioPerfilIDEvent(this.usuarioPerfilID);
}

class UpDateArquivoPathEvent extends PerfilCRUDArqPageEvent {
  final String arquivoPath;

  UpDateArquivoPathEvent(this.arquivoPath);
}

class UpDateImagemEvent extends PerfilCRUDArqPageEvent {
  final File imagem;

  UpDateImagemEvent(this.imagem);
}

class UpLoadEvent extends PerfilCRUDArqPageEvent {}

class PerfilCRUDArqPageState {
  String usuarioPerfilID;
  String arquivoPath;
  File arquivo;
  File imagem;
  String usuarioArquivoIDurl;
  String getDownloadURL;
  @override
  String toString() {
    // TODO: implement toString
    return 'PerfilCRUDArqPageState.toString: usuarioPerfilID: $usuarioPerfilID | arquivo: ${arquivo.path} | usuarioArquivoIDurl: $usuarioArquivoIDurl';
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

  //UpLoadFile
  final uploadBloc = UploadBloc(Bootstrap.instance.firestore);
  // final _imagemPerfilController = BehaviorSubject<String>();
  // Function get imagemPerfilSink => _imagemPerfilController.sink.add;

  PerfilCRUDArqPageBloc(this._firestore) {
    perfilCRUDArqPageEventStream.listen(_mapEventToState);
    // _imagemPerfilController.listen(_imagemPerfilUpload);
  }

  void dispose() {
    _perfilCRUDArqPageStateController.close();
    _usuarioPerfilModelController.close();
    // _imagemPerfilController.close();
  }

  // _imagemPerfilUpload(String filePath) {
  //   print('>>>>> filepath: $filePath');
  //   perfilCRUDArqPageState.arquivoLocal = filePath;
  //   uploadBloc.uploadFromPath(perfilCRUDArqPageState.arquivoLocal);
  // }

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
    if (event is UpDateArquivoPathEvent) {
      perfilCRUDArqPageState.arquivoPath = event.arquivoPath;
      File arquivo = File(perfilCRUDArqPageState.arquivoPath);
      perfilCRUDArqPageState.arquivo = arquivo;
      // uploadBloc.uploadFromPath(perfilCRUDArqPageState.arquivoPath);
    }
    if (event is UpDateImagemEvent) {
      perfilCRUDArqPageState.imagem = event.imagem;
      perfilCRUDArqPageState.arquivo = perfilCRUDArqPageState.imagem;

      // perfilCRUDArqPageState.arquivoPath = event.imagem.path;

      // File arquivo = File(perfilCRUDArqPageState.arquivoPath);
      // perfilCRUDArqPageState.arquivo = arquivo;

    }
    if (event is UpLoadEvent) {
      // uploadfirebaseStorage(perfilCRUDArqPageState.arquivo);
      saveStateToFirebaseEvent(perfilCRUDArqPageState.arquivo);
    }

    perfilCRUDArqPageStateSink(perfilCRUDArqPageState);
    // perfilCRUDArqPageStateSink(perfilCRUDArqPageState);

    // print('Oiiii');
    print(
        '>> perfilCRUDArqPageState.toString() >> ${perfilCRUDArqPageState.toString()}');
  }

  Future<String> uploadfirebaseStorage(File file) async {
    print('Storaging to ${file}');
    File _file = file;

    // String fileName = path.basename(_file.path);
    final uuid = Uuid();
    final String filename = uuid.v4();
    final storageRef = await FirebaseStorage.instance.ref().child(filename);

    final StorageTaskSnapshot task = await storageRef.putFile(file).onComplete;
    final String fileUrl = await task.ref.getDownloadURL();
    print('Storage in url ${fileUrl}');
    perfilCRUDArqPageState.getDownloadURL = fileUrl;

    return fileUrl;
  }

  void saveStateToFirebaseEvent(File file) async {
    await uploadfirebaseStorage(file);
    _firestore
        .collection(UsuarioPerfilModel.collection)
        .document(perfilCRUDArqPageState.usuarioPerfilID)
        .setData({"usuarioArquivoID":{"id":"","url":perfilCRUDArqPageState.getDownloadURL}}, merge: true);
  }
}
