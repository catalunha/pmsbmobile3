import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime/mime.dart';
import 'package:pmsbmibile3/api/auth_api_mobile.dart';
import 'package:pmsbmibile3/models/produto_model.dart';
import 'package:pmsbmibile3/models/produto_texto_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:pmsbmibile3/pages/pages.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'package:pmsbmibile3/bootstrap.dart';
import 'package:uuid/uuid.dart';

class ProdutoImagemCRUDPageEvent {}

class UpdateProdutoIDArquivoIDEvent extends ProdutoImagemCRUDPageEvent {
  final String produtoID;
  final String arquivoID;

  UpdateProdutoIDArquivoIDEvent(this.produtoID, this.arquivoID);
}

class UpdateTituloEvent extends ProdutoImagemCRUDPageEvent {
  final String titulo;

  UpdateTituloEvent(this.titulo);
}

class UpdateArquivoRascunhoEvent extends ProdutoImagemCRUDPageEvent {
  final String arquivoRascunho;

  UpdateArquivoRascunhoEvent(this.arquivoRascunho);
}

class UpdateArquivoEditadoEvent extends ProdutoImagemCRUDPageEvent {
  final String arquivoEditado;

  UpdateArquivoEditadoEvent(this.arquivoEditado);
}

class SaveEvent extends ProdutoImagemCRUDPageEvent {}

class DeleteEvent extends ProdutoImagemCRUDPageEvent {}

class DeleteArquivoEvent extends ProdutoImagemCRUDPageEvent {
  final String arquivoTipo;

  DeleteArquivoEvent(this.arquivoTipo);
}

class ProdutoImagemCRUDPageState {
  ProdutoModel produtoModel;

  String produtoID;
  String arquivoID;

  String arquivoRascunho;
  String arquivoEditado;
  String titulo;

  List<Imagem> imagemList;
  Imagem imagem;

  void updateStateFromProdutoModel() {
    imagemList = produtoModel.imagem;

    produtoModel.imagem?.forEach((img) {
      if (img.id == arquivoID) {
        imagem = img;
        titulo = imagem.titulo;
        arquivoRascunho = imagem.produtoArquivoIDRascunho;
        arquivoEditado = imagem.produtoArquivoIDEditado;
      }
    });
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['produtoID'] = this.produtoID;
    data['arquivoID'] = this.arquivoID;
    data['arquivoRascunho'] = this.arquivoRascunho;
    data['arquivoEditado'] = this.arquivoEditado;
    data['titulo'] = this.titulo;
    return data;
  }
}

class ProdutoImagemCRUDPageBloc {
  //Firestore
  final fw.Firestore _firestore;

  //Eventos
  final _eventController = BehaviorSubject<ProdutoImagemCRUDPageEvent>();
  Stream<ProdutoImagemCRUDPageEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final ProdutoImagemCRUDPageState _state = ProdutoImagemCRUDPageState();
  final _stateController = BehaviorSubject<ProdutoImagemCRUDPageState>();
  Stream<ProdutoImagemCRUDPageState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  //Bloc
  ProdutoImagemCRUDPageBloc(this._firestore) {
    eventStream.listen(_mapEventToState);
  }

  _mapEventToState(ProdutoImagemCRUDPageEvent event) async {
    if (event is UpdateProdutoIDArquivoIDEvent) {
      _state.produtoID = event.produtoID;
      _state.arquivoID = event.arquivoID;

      final docRef = _firestore
          .collection(ProdutoModel.collection)
          .document(_state.produtoID);

      final docSnap = await docRef.get();

      if (docSnap.exists) {
        final produtoModel =
            ProdutoModel(id: docSnap.documentID).fromMap(docSnap.data);
        _state.produtoModel = produtoModel;
        _state.updateStateFromProdutoModel();
      }
    }
    if (event is UpdateTituloEvent) {
      _state.titulo = event.titulo;
      print('>>> _state.titulo <<< ${_state.titulo}');
    }
    if (event is UpdateArquivoRascunhoEvent) {
      _state.arquivoRascunho = event.arquivoRascunho;
    }
    if (event is UpdateArquivoEditadoEvent) {
      _state.arquivoEditado = event.arquivoEditado;
    }

    Future<String> uploadStorage(String filePath) async {
      final uuid = Uuid();
      File file = File(filePath);

      final String filename = uuid.v4();
      final storageRef = await FirebaseStorage.instance.ref().child(filename);

      final StorageTaskSnapshot task =
          await storageRef.putFile(file).onComplete;
          
      final String fileUrl = await task.ref.getDownloadURL();
      print('Storage in url ${fileUrl}');

      return fileUrl;
    }

    if (event is SaveEvent) {
          print('>>> _state.toMap() <<< ${_state.toMap()}');

      if (_state.arquivoRascunho != null) {
        var a = uploadStorage(_state.arquivoRascunho);
        a.then((arqPath) {
                print('then Storage in url ${arqPath}');

          _state.arquivoRascunho = arqPath;
        });
      }
      if (_state.arquivoEditado != null) {
        var b=uploadStorage(_state.arquivoEditado);
        b.then((arqPath) {
          _state.arquivoEditado = arqPath;
        });
      }
    print('>>> _state.toMap() <<< ${_state.toMap()}');

      if (_state.arquivoID == null) {
        final uuid = Uuid();
        final imagemSave = Imagem(
            id: uuid.v4(),
            titulo: _state.titulo,
            produtoArquivoIDRascunho: _state.arquivoRascunho,
            produtoArquivoIDEditado: _state.arquivoEditado);
        if (_state.imagemList == null) {
          _state.imagemList = List<Imagem>();
        }
        _state.imagemList.add(imagemSave);
      } else {
        _state.imagemList.removeWhere((img) => img.id == _state.arquivoID);
        final imagemSave = Imagem(
            id: _state.arquivoID,
            titulo: _state.titulo,
            produtoArquivoIDRascunho: _state.arquivoRascunho,
            produtoArquivoIDEditado: _state.arquivoEditado);
        _state.imagemList.add(imagemSave);
      }
      final docRef = _firestore
          .collection(ProdutoModel.collection)
          .document(_state.produtoID);
      final doc = await docRef.setData(
          {"imagem": _state.imagemList.map((v) => v.toMap()).toList()},
          merge: true);
    }

    // void saveStateToFirebaseEvent(File file) async {
    //   await uploadfirebaseStorage(file);
    //   _firestore
    //       .collection(UsuarioPerfilModel.collection)
    //       .document(perfilCRUDArqPageState.usuarioPerfilID)
    //       .setData({
    //     "usuarioArquivoID": {
    //       "id": "${perfilCRUDArqPageState.usuarioPerfilID}",
    //       "url": perfilCRUDArqPageState.getDownloadURL
    //     }
    //   }, merge: true);
    // }

    if (event is DeleteEvent) {
      if (_state.imagemList != null) {
        _state.imagemList.removeWhere((img) => img.id == _state.arquivoID);
        final docRef = _firestore
            .collection(ProdutoModel.collection)
            .document(_state.produtoID);
        docRef.setData(
            {"imagem": _state.imagemList.map((v) => v.toMap()).toList()},
            merge: true);
      }
    }
    if (event is DeleteArquivoEvent) {
      if (event.arquivoTipo == 'arquivoEditado') {
        _state.arquivoEditado = null;
      } else {
        _state.arquivoRascunho = null;
      }
    }
    if (!_stateController.isClosed) _stateController.add(_state);
    // print('>>> _state.toMap() <<< ${_state.toMap()}');
    print('>>> event.runtimeType <<< ${event.runtimeType}');
  }

  void dispose() {
    _stateController.close();
    _eventController.close();
  }
}
