import 'package:pmsbmibile3/models/ia_produto_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

class ProdutoListBlocEvent {}

class GetProdutoEvent extends ProdutoListBlocEvent {}

// class OrdenarEvent extends ProdutoListBlocEvent {
//   final IAProdutoModel obj;
//   final bool up;

//   OrdenarEvent(this.obj, this.up);
// }

// class CreateRelatorioEvent extends ProdutoListBlocEvent {
//   final String pastaId;

//   CreateRelatorioEvent(this.pastaId);
// }

// class ResetCreateRelatorioEvent extends ProdutoListBlocEvent {}

class ProdutoListBlocState {
  bool isDataValid = false;
  List<IAProdutoModel> produtoList = List<IAProdutoModel>();
}

class ProdutoListBloc {
  /// Firestore
  final fsw.Firestore _firestore;
  // final _authBloc;

  /// Eventos
  final _eventController = BehaviorSubject<ProdutoListBlocEvent>();
  Stream<ProdutoListBlocEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  /// Estados
  final ProdutoListBlocState _state = ProdutoListBlocState();
  final _stateController = BehaviorSubject<ProdutoListBlocState>();
  Stream<ProdutoListBlocState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  /// Bloc
  ProdutoListBloc(
    this._firestore,
    // this._authBloc,
  ) {
    eventStream.listen(_mapEventToState);
    // _authBloc.perfil.listen((usuarioAuth) {
    //   eventSink(GetUsuarioAuthEvent(usuarioAuth));
    //   if (!_stateController.isClosed) _stateController.add(_state);
    //   eventSink(GetProdutoEvent());
    // });
    eventSink(GetProdutoEvent());
  }

  void dispose() async {
    await _stateController.drain();
    _stateController.close();
    await _eventController.drain();
    _eventController.close();
  }

  _validateData() {
    _state.isDataValid = true;
  }

  _mapEventToState(ProdutoListBlocEvent event) async {
    if (event is GetProdutoEvent) {
      final streamDocsRemetente = _firestore
          .collection(IAProdutoModel.collection)
          // .where("professor.id", isEqualTo: _state.usuarioAuth.id)
          .orderBy('numero')
          .snapshots();

      final snapListRemetente = streamDocsRemetente.map((snapDocs) => snapDocs
          .documents
          .map((doc) => IAProdutoModel(id: doc.documentID).fromMap(doc.data))
          .toList());

      snapListRemetente.listen((List<IAProdutoModel> produtoList) {
        // produtoList.sort((a, b) => a.numero.compareTo(b.numero));
        // print(produtoList);
        _state.produtoList.clear();
        _state.produtoList = produtoList;
        if (!_stateController.isClosed) _stateController.add(_state);
      });
    }
    // if (event is OrdenarEvent) {
    //   final ordemOrigem = _state.produtoList.indexOf(event.obj);
    //   final ordemDestino = event.up ? ordemOrigem - 1 : ordemOrigem + 1;
    //   IAProdutoModel docOrigem = _state.produtoList[ordemOrigem];
    //   IAProdutoModel docDestino = _state.produtoList[ordemDestino];

    //   final collectionRef = _firestore.collection(IAProdutoModel.collection);

    //   final colRefOrigem = collectionRef.document(docOrigem.id);
    //   final colRefDestino = collectionRef.document(docDestino.id);

    //   colRefOrigem.setData({"numero": docDestino.numero}, merge: true);
    //   colRefDestino.setData({"numero": docOrigem.numero}, merge: true);
    // }
    // if (event is CreateRelatorioEvent) {
    //   final docRef = _firestore.collection('Relatorio').document();
    //   await docRef.setData({'pastaId': event.pastaId}, merge: true).then((_) {
    //     _state.pedidoRelatorio = docRef.documentID;
    //     if (!_stateController.isClosed) _stateController.add(_state);
    //   });
    // }
    // if (event is ResetCreateRelatorioEvent) {
    //   _state.pedidoRelatorio = null;
    // }
    _validateData();
    if (!_stateController.isClosed) _stateController.add(_state);
    print('event.runtimeType em produto_list_bloc  = ${event.runtimeType}');
  }
}
