import 'package:pmsbmibile3/models/eixo_arquivo_model.dart';
import 'package:pmsbmibile3/models/produto_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';
import 'package:pmsbmibile3/models/upload_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class ProdutoArquivoCRUDPageEvent {}

class UpdateProdutoIDArquivoIDTipoEvent extends ProdutoArquivoCRUDPageEvent {
  final String produtoID;
  final String arquivoID;
  final String tipo;

  UpdateProdutoIDArquivoIDTipoEvent(this.produtoID, this.arquivoID, this.tipo);
}

class UpdateTituloEvent extends ProdutoArquivoCRUDPageEvent {
  final String titulo;

  UpdateTituloEvent(this.titulo);
}

class UpdateArquivoRascunhoEvent extends ProdutoArquivoCRUDPageEvent {
  final String arquivoRascunho;

  UpdateArquivoRascunhoEvent(this.arquivoRascunho);
}

class UpdateArquivoEditadoEvent extends ProdutoArquivoCRUDPageEvent {
  final String arquivoEditado;

  UpdateArquivoEditadoEvent(this.arquivoEditado);
}

class SaveEvent extends ProdutoArquivoCRUDPageEvent {}

class DeleteEvent extends ProdutoArquivoCRUDPageEvent {}

class DeleteArquivoEvent extends ProdutoArquivoCRUDPageEvent {
  final String arquivoTipo;

  DeleteArquivoEvent(this.arquivoTipo);
}

class ProdutoArquivoCRUDPageState {
  ProdutoModel produtoModel;
  ArquivoProduto arquivo;

  String produtoID;
  String arquivoID;
  String tipo;

  String titulo;
  String rascunhoEixoArquivoID;
  String rascunhoUrl;
  String rascunhoLocalPath;
  String editadoEixoArquivoID;
  String editadoUrl;
  String editadoLocalPath;

  void updateStateFromProdutoModel() {
    // arquivo = produtoModel.arquivo;
    if (this.arquivoID != null) {
      arquivo = produtoModel.arquivo[arquivoID];
      titulo = arquivo.titulo;
      tipo = arquivo.tipo;
      rascunhoEixoArquivoID = arquivo.rascunhoEixoArquivoID;
      rascunhoUrl = arquivo.rascunhoUrl;
      rascunhoLocalPath = arquivo.rascunhoLocalPath;
      editadoEixoArquivoID = arquivo.editadoEixoArquivoID;
      editadoUrl = arquivo.editadoUrl;
      editadoLocalPath = arquivo.editadoLocalPath;
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['produtoID'] = this.produtoID;
    data['arquivoID'] = this.arquivoID;
    data['titulo'] = this.titulo;
    data['tipo'] = this.tipo;
    data['rascunhoEixoArquivoID'] = this.rascunhoEixoArquivoID;
    data['rascunhoUrl'] = this.rascunhoUrl;
    data['rascunhoLocalPath'] = this.rascunhoLocalPath;
    data['editadoEixoArquivoID'] = this.editadoEixoArquivoID;
    data['editadoUrl'] = this.editadoUrl;
    data['editadoLocalPath'] = this.editadoLocalPath;
    return data;
  }
}

class ProdutoArquivoCRUDPageBloc {
  //Firestore
  final fw.Firestore _firestore;

  //Eventos
  final _eventController = BehaviorSubject<ProdutoArquivoCRUDPageEvent>();
  Stream<ProdutoArquivoCRUDPageEvent> get eventStream =>
      _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final ProdutoArquivoCRUDPageState _state = ProdutoArquivoCRUDPageState();
  final _stateController = BehaviorSubject<ProdutoArquivoCRUDPageState>();
  Stream<ProdutoArquivoCRUDPageState> get stateStream =>
      _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  //Bloc
  ProdutoArquivoCRUDPageBloc(this._firestore) {
    eventStream.listen(_mapEventToState);
  }

  _mapEventToState(ProdutoArquivoCRUDPageEvent event) async {
    if (event is UpdateProdutoIDArquivoIDTipoEvent) {
      _state.produtoID = event.produtoID;
      _state.arquivoID = event.arquivoID;
      _state.tipo = event.tipo;

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
      _state.rascunhoLocalPath = event.arquivoRascunho;
    }
    if (event is UpdateArquivoEditadoEvent) {
      _state.editadoLocalPath = event.arquivoEditado;
    }

    if (event is SaveEvent) {
      if (_state.rascunhoLocalPath != null) {
        // Cria doc em UpLoad collection para upload futuro
        final upLoadModel = UploadModel(
          usuarioID: _state.produtoModel.usuarioID,
          localPath: _state.rascunhoLocalPath,
          upload: false,
          atualizar: 'EixoArquivo',
        );
        final docRef = _firestore
            .collection(UploadModel.collection)
            .document(_state.rascunhoEixoArquivoID);
        await docRef.setData(upLoadModel.toMap(), merge: true);
        _state.rascunhoEixoArquivoID = docRef.documentID;
        // criar doc em EixoArquivo
        final eixoArquivoModel = EixoArquivoModel(
          produtoID:
              ProdutoID(id: _state.produtoID, nome: _state.produtoModel.nome),
          titulo: _state.titulo,
        );
        final docRef2 = _firestore
            .collection(EixoArquivoModel.collection)
            .document(_state.rascunhoEixoArquivoID);
        await docRef2.setData(eixoArquivoModel.toMap(), merge: true);
      }
      if (_state.editadoLocalPath != null) {
        final upLoadModel = UploadModel(
          usuarioID: _state.produtoModel.usuarioID,
          localPath: _state.editadoLocalPath,
          upload: false,
          atualizar: 'EixoArquivo',
        );
        final docRef = _firestore
            .collection(UploadModel.collection)
            .document(_state.editadoEixoArquivoID);
        await docRef.setData(upLoadModel.toMap(), merge: true);
        _state.editadoEixoArquivoID = docRef.documentID;
        // criar doc em EixoArquivo
        final eixoArquivoModel = EixoArquivoModel(
          produtoID:
              ProdutoID(id: _state.produtoID, nome: _state.produtoModel.nome),
          titulo: _state.titulo,
        );
        final docRef2 = _firestore
            .collection(EixoArquivoModel.collection)
            .document(_state.editadoEixoArquivoID);
        await docRef2.setData(eixoArquivoModel.toMap(), merge: true);
      }
      if (_state.rascunhoLocalPath == null && _state.rascunhoUrl == null) {
        if (_state.rascunhoEixoArquivoID != null) {
          final docRef = _firestore
              .collection(UploadModel.collection)
              .document(_state.rascunhoEixoArquivoID);
          await docRef.delete();
          _state.rascunhoEixoArquivoID = null;
        }
      }
      if (_state.editadoLocalPath == null && _state.editadoUrl == null) {
        if (_state.editadoEixoArquivoID != null) {
          final docRef = _firestore
              .collection(UploadModel.collection)
              .document(_state.editadoEixoArquivoID);
          await docRef.delete();
          _state.editadoEixoArquivoID = null;
        }
      }
      ArquivoProduto imagemSave;
      if (_state.arquivoID == null) {
        final uuid = Uuid();
          _state.arquivoID = uuid.v4();
         imagemSave = ArquivoProduto(
          id: _state.arquivoID,
          titulo: _state.titulo,
          tipo: _state.tipo,
          rascunhoEixoArquivoID: _state.rascunhoEixoArquivoID,
          rascunhoUrl: _state.rascunhoUrl,
          rascunhoLocalPath: _state.rascunhoLocalPath,
          editadoEixoArquivoID: _state.editadoEixoArquivoID,
          editadoUrl: _state.editadoUrl,
          editadoLocalPath: _state.editadoLocalPath,
        );
      } else {
         imagemSave = ArquivoProduto(
          id: _state.arquivoID,
          titulo: _state.titulo,
          tipo: _state.tipo,
          rascunhoEixoArquivoID: _state.rascunhoEixoArquivoID,
          rascunhoUrl: _state.rascunhoUrl,
          rascunhoLocalPath: _state.rascunhoLocalPath,
          editadoEixoArquivoID: _state.editadoEixoArquivoID,
          editadoUrl: _state.editadoUrl,
          editadoLocalPath: _state.editadoLocalPath,
        );
      }

      final docRef = _firestore
          .collection(ProdutoModel.collection)
          .document(_state.produtoID);
          // Map<dynamic,dynamic> map = Map<dynamic,dynamic>();
          // map[_state.arquivoID]=imagemSave.toMap();
      final doc = await docRef.setData(
          {"arquivo": {_state.arquivoID:imagemSave.toMap()}},
          merge: true);
    }

    if (event is DeleteEvent) {
      // if (_state.imagemList != null) {
      //   _state.imagemList.removeWhere((img) => img.id == _state.arquivoID);
      //   final docRef = _firestore
      //       .collection(ProdutoModel.collection)
      //       .document(_state.produtoID);
      //   docRef.setData(
      //       {"imagem": _state.imagemList.map((v) => v.toMap()).toList()},
      //       merge: true);
      // }
    }
    if (event is DeleteArquivoEvent) {
      // if (event.arquivoTipo == 'arquivoEditado') {
      //   _state.rascunhoLocalPath = null;
      //   _state.rascunhoUrl = null;
      // } else {
      //   _state.editadoLocalPath = null;
      //   _state.editadoUrl = null;
      // }
    }
    if (!_stateController.isClosed) _stateController.add(_state);
    // print('>>> _state.toMap() <<< ${_state.toMap()}');
    // print('>>> event.runtimeType <<< ${event.runtimeType}');
  }

  void dispose() {
    _stateController.close();
    _eventController.close();
  }
}
// Future<String> uploadStorage(String filePath) async {
//   final uuid = Uuid();
//   File file = File(filePath);

//   final String filename = uuid.v4();
//   final storageRef = await FirebaseStorage.instance.ref().child(filename);

//   final StorageTaskSnapshot task =
//       await storageRef.putFile(file).onComplete;

//   final String fileUrl = await task.ref.getDownloadURL();
//   print('Storage in url ${fileUrl}');

//   return fileUrl;
// }

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

// if (_state.arquivoRascunho != null) {
//   var a = uploadStorage(_state.arquivoRascunho);
//   a.then((arqPath) {
//     print('then Storage in url ${arqPath}');

//     _state.arquivoRascunho = arqPath;
//   });
// }
// if (_state.arquivoEditado != null) {
//   var b = uploadStorage(_state.arquivoEditado);
//   b.then((arqPath) {
//     _state.arquivoEditado = arqPath;
//   });
// }
// print('>>> _state.toMap() <<< ${_state.toMap()}');

// if (_state.arquivoID == null) {
//   final uuid = Uuid();
//   final imagemSave = Arquivo(
//       id: uuid.v4(),
//       titulo: _state.titulo,
//       produtoArquivoIDRascunho: _state.arquivoRascunho,
//       produtoArquivoIDEditado: _state.arquivoEditado);
//   if (_state.imagemList == null) {
//     _state.imagemList = List<Arquivo>();
//   }
//   _state.imagemList.add(imagemSave);
// } else {
//   _state.imagemList.removeWhere((img) => img.id == _state.arquivoID);
//   final imagemSave = Arquivo(
//       id: _state.arquivoID,
//       titulo: _state.titulo,
//       produtoArquivoIDRascunho: _state.arquivoRascunho,
//       produtoArquivoIDEditado: _state.arquivoEditado);
//   _state.imagemList.add(imagemSave);
// }
// final docRef = _firestore
//     .collection(ProdutoModel.collection)
//     .document(_state.produtoID);
// final doc = await docRef.setData(
//     {"imagem": _state.imagemList.map((v) => v.toMap()).toList()},
//     merge: true);
