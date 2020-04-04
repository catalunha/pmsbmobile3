import 'package:pmsbmibile3/models/checklist_produto_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

class ProdutoListBlocEvent {}

class GetProdutoEvent extends ProdutoListBlocEvent {}

class ProdutoListBlocState {
  bool isDataValid = false;
  List<ChecklistProdutoModel> produtoList = List<ChecklistProdutoModel>();
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
  ) {
    eventStream.listen(_mapEventToState);

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
          .collection(ChecklistProdutoModel.collection)
          .orderBy('numero')
          .snapshots();

      final snapListRemetente = streamDocsRemetente.map((snapDocs) => snapDocs
          .documents
          .map((doc) => ChecklistProdutoModel(id: doc.documentID).fromMap(doc.data))
          .toList());

      snapListRemetente.listen((List<ChecklistProdutoModel> produtoList) {

        _state.produtoList.clear();
        _state.produtoList = produtoList;
        if (!_stateController.isClosed) _stateController.add(_state);
      });
    }

    _validateData();
    if (!_stateController.isClosed) _stateController.add(_state);
    print('event.runtimeType em produto_list_bloc  = ${event.runtimeType}');
  }
}
