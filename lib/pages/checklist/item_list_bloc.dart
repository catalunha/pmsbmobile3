import 'package:pmsbmibile3/models/checklist_produto_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pmsbmibile3/models/checklist_item_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

class ItemListBlocEvent {}

class GetItemListEvent extends ItemListBlocEvent {
  final String produtoId;

  GetItemListEvent(this.produtoId);
}

class GetProdutoEvent extends ItemListBlocEvent {
  final String produtoId;

  GetProdutoEvent(this.produtoId);
}

class ItemListBlocState {
  bool isDataValid = false;
  ChecklistProdutoModel produto = ChecklistProdutoModel();
  List<ChecklistItemModel> itemList = List<ChecklistItemModel>();
}

class ItemListBloc {
  /// Firestore
  final fsw.Firestore _firestore;

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
  ) {
    eventStream.listen(_mapEventToState);

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
          .collection(ChecklistItemModel.collection)
          .where("checkListProdutoId", isEqualTo: event.produtoId)
          .orderBy('numero')
          .snapshots();

      final snapListRemetente = streamDocsRemetente.map((snapDocs) => snapDocs
          .documents
          .map((doc) => ChecklistItemModel(id: doc.documentID).fromMap(doc.data))
          .toList());
      snapListRemetente.listen((List<ChecklistItemModel> itemList) {
        _state.itemList.clear();
        _state.itemList = itemList;
        if (!_stateController.isClosed) _stateController.add(_state);
      });
    }

    if (event is GetProdutoEvent) {
      final futureDocSnap = await _firestore
          .collection(ChecklistProdutoModel.collection)
          .document(event.produtoId)
          .get();

      _state.produto = ChecklistProdutoModel(id: futureDocSnap.documentID)
          .fromMap(futureDocSnap.data);
    }
    _validateData();
    if (!_stateController.isClosed) _stateController.add(_state);
    print('event.runtimeType em item_list_bloc.dart  = ${event.runtimeType}');
  }
}
