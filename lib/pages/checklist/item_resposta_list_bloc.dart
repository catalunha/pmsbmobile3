import 'package:pmsbmibile3/models/checklist_item_setor_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pmsbmibile3/models/checklist_item_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

class ItemRespostaListBlocEvent {}

class GetItemRespostaListEvent extends ItemRespostaListBlocEvent {
  final String itemId;

  GetItemRespostaListEvent(this.itemId);
}

class GetItemEvent extends ItemRespostaListBlocEvent {
  final String itemId;

  GetItemEvent(this.itemId);
}

class ItemRespostaListBlocState {
  bool isDataValid = false;
  ChecklistItemModel item = ChecklistItemModel();

  List<ChecklistItemSetorModel> itemRespostaList = List<ChecklistItemSetorModel>();
}

class ItemRespostaListBloc {
  /// Firestore
  final fsw.Firestore _firestore;
  // final _authBloc;

  /// Eventos
  final _eventController = BehaviorSubject<ItemRespostaListBlocEvent>();
  Stream<ItemRespostaListBlocEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  /// Estados
  final ItemRespostaListBlocState _state = ItemRespostaListBlocState();
  final _stateController = BehaviorSubject<ItemRespostaListBlocState>();
  Stream<ItemRespostaListBlocState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  /// Bloc
  ItemRespostaListBloc(
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

  _mapEventToState(ItemRespostaListBlocEvent event) async {
    if (event is GetItemRespostaListEvent) {
      final streamDocsRemetente = _firestore
          .collection(ChecklistItemModel.collection)
          .document(event.itemId)
          .collection(ChecklistItemSetorModel.collection)
          .orderBy('setor.nome')
          .snapshots();

      final snapListRemetente = streamDocsRemetente.map((snapDocs) => snapDocs
          .documents
          .map((doc) =>
              ChecklistItemSetorModel(id: doc.documentID).fromMap(doc.data))
          .toList());

      snapListRemetente.listen((List<ChecklistItemSetorModel> itemRespostaList) {
        // itemRespostaList.sort((a, b) => a.numero.compareTo(b.numero));
        // print(itemRespostaList);
        _state.itemRespostaList.clear();
        _state.itemRespostaList = itemRespostaList;
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
    if (event is GetItemEvent) {
      final futureDocSnap = await _firestore
          .collection(ChecklistItemModel.collection)
          .document(event.itemId)
          .get();

      _state.item =
          ChecklistItemModel(id: futureDocSnap.documentID).fromMap(futureDocSnap.data);
    }
    _validateData();
    if (!_stateController.isClosed) _stateController.add(_state);
    print('event.runtimeType em PastaList  = ${event.runtimeType}');
  }
}
