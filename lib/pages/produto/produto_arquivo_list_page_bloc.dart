import 'package:pmsbmibile3/models/produto_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;
import 'package:rxdart/rxdart.dart';

class ProdutoArquivoListPageEvent {}

class UpdateProdutoIDTipoEvent extends ProdutoArquivoListPageEvent {
  final String produtoID;
  final String tipo;

  UpdateProdutoIDTipoEvent(this.produtoID, this.tipo);
}

class UpdateArquivoMapPageEvent extends ProdutoArquivoListPageEvent{
  final fw.DocumentSnapshot snap;

  UpdateArquivoMapPageEvent(this.snap);
  
}

class ProdutoArquivoListPageState {
  ProdutoModel produtoModel;

  String produtoID;
  String tipo;

  Map<String, ArquivoProduto> arquivo;

  void updateStateFromProdutoModel() {
    arquivo = Map<String, ArquivoProduto>();
    if (produtoModel.arquivo != null) {
      produtoModel?.arquivo?.forEach((k, v) {
        if (v.tipo == this.tipo) {
          arquivo[k] = v;
        }
      });
    }
  }
}

class ProdutoArquivoListPageBloc {
  //Firestore
  final fw.Firestore _firestore;

  //Eventos
  final _eventController = BehaviorSubject<ProdutoArquivoListPageEvent>();
  Stream<ProdutoArquivoListPageEvent> get eventStream =>
      _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final ProdutoArquivoListPageState _state = ProdutoArquivoListPageState();
  final _stateController = BehaviorSubject<ProdutoArquivoListPageState>();
  Stream<ProdutoArquivoListPageState> get stateStream =>
      _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  //Bloc
  ProdutoArquivoListPageBloc(this._firestore) {
    eventStream.listen(_mapEventToState);
  }

  void dispose() async {
    await _stateController.drain();
    _stateController.close();
    await _eventController.drain();
    _eventController.close();
  }
  _mapEventToState(ProdutoArquivoListPageEvent event) async {
    if (event is UpdateProdutoIDTipoEvent) {
      _state.produtoID = event.produtoID;
      _state.tipo = event.tipo;

      final docRef = _firestore
          .collection(ProdutoModel.collection)
          .document(_state.produtoID);

      docRef.snapshots().listen((snap){
        if (snap.exists) {
        _eventController.add(UpdateArquivoMapPageEvent(snap)); 
      }
       
      });
    }
    if(event is UpdateArquivoMapPageEvent){
      final produtoModel =
            ProdutoModel(id: event.snap.documentID).fromMap(event.snap.data);
        _state.produtoModel = produtoModel;
        _state.updateStateFromProdutoModel(); 
    }



 

    if (!_stateController.isClosed) _stateController.add(_state);

    // print('>>> _state.toMap() <<< ${_state.toMap()}');
  }

}
