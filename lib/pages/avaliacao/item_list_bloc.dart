import 'package:rxdart/rxdart.dart';
import 'package:pmsbmibile3/models/ia_item_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

class ItemListBlocEvent {}

class GetItemListEvent extends ItemListBlocEvent {
  final String produtoId;

  GetItemListEvent(this.produtoId);
}
// class OrdenarEvent extends ItemListBlocEvent {
//   final IAProdutoModel obj;
//   final bool up;

//   OrdenarEvent(this.obj, this.up);
// }

// class CreateRelatorioEvent extends ItemListBlocEvent {
//   final String pastaId;

//   CreateRelatorioEvent(this.pastaId);
// }

// class ResetCreateRelatorioEvent extends ItemListBlocEvent {}

class ItemListBlocState {
  bool isDataValid = false;
  List<IAItemModel> itemList = List<IAItemModel>();
}

class ItemListBloc {
  /// Firestore
  final fsw.Firestore _firestore;
  // final _authBloc;

  /// Eventos
  final _eventController = BehaviorSubject<ItemListBlocEvent>();
  Stream<ItemListBlocEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  /// Estados
  final ItemListBlocState _state = ItemListBlocState();
  final _stateController = BehaviorSubject<ItemListBlocState>();
  Stream<ItemListBlocState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  /// Bloc
  ItemListBloc(
    this._firestore,
    // this._authBloc,
  ) {
    eventStream.listen(_mapEventToState);
    // _authBloc.perfil.listen((usuarioAuth) {
    //   eventSink(GetUsuarioAuthEvent(usuarioAuth));
    //   if (!_stateController.isClosed) _stateController.add(_state);
    //   eventSink(GetProdutoEvent());
    // });
    // eventSink(GetProdutoEvent());
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

  _mapEventToState(ItemListBlocEvent event) async {
    if (event is GetItemListEvent) {
      final streamDocsRemetente = _firestore
          .collection(IAItemModel.collection)
          .where("iaprodutoId", isEqualTo: event.produtoId)
          .orderBy('numero')
          .snapshots();

      final snapListRemetente = streamDocsRemetente.map((snapDocs) => snapDocs
          .documents
          .map((doc) => IAItemModel(id: doc.documentID).fromMap(doc.data))
          .toList());

      snapListRemetente.listen((List<IAItemModel> itemList) {
        // itemList.sort((a, b) => a.numero.compareTo(b.numero));
        // print(itemList);
        // _state.itemList.clear();
        _state.itemList = itemList;
        if (!_stateController.isClosed) _stateController.add(_state);
      });
    }
    // if (event is OrdenarEvent) {
    //   final ordemOrigem = _state.itemList.indexOf(event.obj);
    //   final ordemDestino = event.up ? ordemOrigem - 1 : ordemOrigem + 1;
    //   IAProdutoModel docOrigem = _state.itemList[ordemOrigem];
    //   IAProdutoModel docDestino = _state.itemList[ordemDestino];

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
    print('event.runtimeType em item_list_bloc.dart  = ${event.runtimeType}');
  }
}
