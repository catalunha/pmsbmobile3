import 'package:pmsbmibile3/bootstrap.dart';
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

  // String id;
  String titulo;
  String rascunhoIdUpload;
  String rascunhoUrl;
  String rascunhoLocalPath;
  String editadoIdUpload;
  String editadoUrl;
  String editadoLocalPath;

  void updateStateFromProdutoModel() {
    // arquivo = produtoModel.arquivo;
    if (this.arquivoID != null) {
      arquivo = produtoModel.arquivo[arquivoID];
      // id = arquivo.id;
      titulo = arquivo.titulo;
      tipo = arquivo.tipo;
      rascunhoIdUpload = arquivo.rascunhoIdUpload;
      rascunhoUrl = arquivo.rascunhoUrl;
      rascunhoLocalPath = arquivo.rascunhoLocalPath;
      editadoIdUpload = arquivo.editadoIdUpload;
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
    // data['rascunhoIdUpload'] = this.rascunhoIdUpload;
    data['rascunhoUrl'] = this.rascunhoUrl;
    data['rascunhoLocalPath'] = this.rascunhoLocalPath;
    // data['editadoIdUpload'] = this.editadoIdUpload;
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
      _state.rascunhoUrl = null;
      _state.rascunhoIdUpload = null;
    }
    if (event is UpdateArquivoEditadoEvent) {
      _state.editadoLocalPath = event.arquivoEditado;
      _state.editadoUrl = null;
      _state.editadoIdUpload = null;
    }
    if (event is DeleteArquivoEvent) {
      if (event.arquivoTipo == 'arquivoRascunho') {
        _state.rascunhoLocalPath = null;
        _state.rascunhoUrl = null;
        _state.rascunhoIdUpload = null;
      } else {
        _state.editadoLocalPath = null;
        _state.editadoUrl = null;
        _state.editadoIdUpload = null;
      }
    }
    if (event is SaveEvent) {
      if (_state.arquivoID == null) {
        final uuid = Uuid();
        _state.arquivoID = uuid.v4();
      }
      if (!_stateController.isClosed) _stateController.add(_state);
      //+++ Se novo localPath apagar uploads
      if (_state.rascunhoUrl == null) {
        final docRef = _firestore
            .collection(UploadModel.collection)
            .document(_state.arquivo.rascunhoIdUpload);
        await docRef.delete();
      }
      if (_state.editadoUrl == null) {
        final docRef = _firestore
            .collection(UploadModel.collection)
            .document(_state.arquivo.editadoIdUpload);
        await docRef.delete();
      }
      if (!_stateController.isClosed) _stateController.add(_state);
      //---

      if (_state.rascunhoLocalPath != null) {
        //+++ Cria doc em UpLoadCollection
        final upLoadModel = UploadModel(
          usuario: _state.produtoModel.usuarioID.id,
          localPath: _state.rascunhoLocalPath,
          upload: false,
          updateCollection: UpdateCollection(
              collection: ProdutoModel.collection,
              field:
                  "${_state.produtoID}.arquivo.${_state.arquivoID}.rascunhoUrl"),
        );
        final docRef = _firestore
            .collection(UploadModel.collection)
            .document(_state.rascunhoIdUpload);
        await docRef.setData(upLoadModel.toMap(), merge: true);
        _state.rascunhoIdUpload = docRef.documentID;

        //--- Cria doc em UpLoadCollection
      }
      if (!_stateController.isClosed) _stateController.add(_state);
      // print('>>> _state.toMap() 1 <<< ${_state.toMap()}');

      if (_state.editadoLocalPath != null) {
        //+++ Cria doc em UpLoadCollection
        final upLoadModel = UploadModel(
          usuario: _state.produtoModel.usuarioID.id,
          localPath: _state.editadoLocalPath,
          upload: false,
          updateCollection: UpdateCollection(
              collection: ProdutoModel.collection,
              field:
                  "${_state.produtoID}.arquivo.${_state.arquivoID}.editadoUrl"),
        );
        final docRef = _firestore
            .collection(UploadModel.collection)
            .document(_state.editadoIdUpload);
        await docRef.setData(upLoadModel.toMap(), merge: true);
        _state.editadoIdUpload = docRef.documentID;
        //--- Cria doc em UpLoadCollection
      }
      if (!_stateController.isClosed) _stateController.add(_state);

      ArquivoProduto imagemSave;
      if (_state.arquivoID == null) {
        imagemSave = ArquivoProduto(
          // id: _state.arquivoID,
          titulo: _state.titulo,
          tipo: _state.tipo,
          rascunhoIdUpload: _state.rascunhoIdUpload,
          rascunhoUrl: _state.rascunhoUrl,
          rascunhoLocalPath: _state.rascunhoLocalPath,
          editadoIdUpload: _state.editadoIdUpload,
          editadoUrl: _state.editadoUrl,
          editadoLocalPath: _state.editadoLocalPath,
        );
      } else {
        imagemSave = ArquivoProduto(
          // id: _state.arquivoID,
          titulo: _state.titulo,
          tipo: _state.tipo,
          rascunhoIdUpload: _state.rascunhoIdUpload,
          rascunhoUrl: _state.rascunhoUrl,
          rascunhoLocalPath: _state.rascunhoLocalPath,
          editadoIdUpload: _state.editadoIdUpload,
          editadoUrl: _state.editadoUrl,
          editadoLocalPath: _state.editadoLocalPath,
        );
      }
      if (!_stateController.isClosed) _stateController.add(_state);
      // print('>>> _state.toMap() 5 <<< ${_state.toMap()}');
      // print('>>> imagemSave.toMap2() 5 <<< ${imagemSave.toMap()}');

      final docRef = _firestore
          .collection(ProdutoModel.collection)
          .document(_state.produtoID);
      await docRef.setData({
        "arquivo": {_state.arquivoID: imagemSave.toMapFirestore()}
      }, merge: true);

      if (!_stateController.isClosed) _stateController.add(_state);
      print('>>> _state.toMap() 4 <<< ${_state.toMap()}');
    }

    if (event is DeleteEvent) {
      final docRef = _firestore
          .collection(ProdutoModel.collection)
          .document(_state.produtoID);
      docRef.setData({
        "arquivo": {_state.arquivoID: Bootstrap.instance.FieldValue.delete()}
      }, merge: true);
    }

    if (!_stateController.isClosed) _stateController.add(_state);
    print('>>> _state.toMap() <<< ${_state.toMap()}');
    print('>>> event.runtimeType <<< ${event.runtimeType}');
  }

  void dispose() {
    _stateController.close();
    _eventController.close();
  }
}
