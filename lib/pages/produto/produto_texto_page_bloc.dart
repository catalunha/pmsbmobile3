import 'package:pmsbmibile3/models/produto_model.dart';
import 'package:pmsbmibile3/models/produto_texto_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;
import 'package:rxdart/rxdart.dart';


class ProdutoTextoPageEvent {}

class UpdateProdutoIDEvent extends ProdutoTextoPageEvent {
  final String produtoID;

  UpdateProdutoIDEvent(this.produtoID);
}

class UpdateProdutoTextoIDEvent extends ProdutoTextoPageEvent {
  final String produtoTextoID;

  UpdateProdutoTextoIDEvent(this.produtoTextoID);
}

class UpdateProdutoTextoIDTextoEvent extends ProdutoTextoPageEvent {
  final String produtoTextoIDTexto;

  UpdateProdutoTextoIDTextoEvent(this.produtoTextoIDTexto);
}

class SaveProdutoTextoIDTextoEvent extends ProdutoTextoPageEvent {}

class ProdutoTextoPageState {
  ProdutoModel produtoModel;
  ProdutoTextoModel produtoTextoModel;

  String produtoID;
  String produtoTextoID;

  String produtoTextoIDTextoMarkdown;

  void updateStateFromProdutoTextoModel() {
    produtoTextoIDTextoMarkdown = produtoTextoModel.textoMarkdown;
  }
}

class ProdutoTextoPageBloc {
  //Firestore
  final fw.Firestore _firestore;

  //Eventos
  final _eventController = BehaviorSubject<ProdutoTextoPageEvent>();
  Stream<ProdutoTextoPageEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final ProdutoTextoPageState _state = ProdutoTextoPageState();
  final _stateController = BehaviorSubject<ProdutoTextoPageState>();
  Stream<ProdutoTextoPageState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  //Bloc
  ProdutoTextoPageBloc(this._firestore) {
    eventStream.listen(_mapEventToState);
  }

  void dispose() {
    _stateController.close();
    _eventController.close();
  }
  _mapEventToState(ProdutoTextoPageEvent event) async {
    if (event is UpdateProdutoIDEvent) {
      final docRefColl = _firestore
          .collection(ProdutoModel.collection)
          .document(event.produtoID);

      final docSnap = await docRefColl.get();

      if (docSnap.exists) {
        _state.produtoID = docSnap.documentID;
        _state.produtoTextoID = docSnap.data['produtoTextoID'];

        final docRefSubColl = docRefColl
            .collection(ProdutoTextoModel.collection)
            .document(_state.produtoTextoID);

        final docSnapSubColl = await docRefSubColl.get();

        if (docSnapSubColl.exists) {
          final produtoTextoModel =
              ProdutoTextoModel(id: docSnap.documentID).fromMap(docSnapSubColl.data);
          _state.produtoTextoModel = produtoTextoModel;
          _state.updateStateFromProdutoTextoModel();
        }
      }
    }
    if (event is UpdateProdutoTextoIDTextoEvent) {
      _state.produtoTextoIDTextoMarkdown = event.produtoTextoIDTexto;
    }

    if (event is SaveProdutoTextoIDTextoEvent) {

      final produtoTextoModelSave = ProdutoTextoModel(
        textoMarkdown: _state.produtoTextoIDTextoMarkdown,
        editando: false,
      );

      final docRef = _firestore
          .collection(ProdutoModel.collection)
          .document(_state.produtoID)
          .collection(ProdutoTextoModel.collection)
          .document(_state.produtoTextoID);
      docRef.setData(produtoTextoModelSave.toMap(), merge: true);
    }
    if (!_stateController.isClosed) _stateController.add(_state);
  }

}
