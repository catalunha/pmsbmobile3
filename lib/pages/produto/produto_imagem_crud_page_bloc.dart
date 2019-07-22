import 'package:pmsbmibile3/api/auth_api_mobile.dart';
import 'package:pmsbmibile3/models/produto_model.dart';
import 'package:pmsbmibile3/models/produto_texto_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:pmsbmibile3/pages/pages.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'package:pmsbmibile3/bootstrap.dart';

class ProdutoImagemCRUDPageEvent {}

class UpdateProdutoIDEvent extends ProdutoImagemCRUDPageEvent {
  final String produtoID;

  UpdateProdutoIDEvent(this.produtoID);
}

class ProdutoImagemCRUDPageState {
  ProdutoModel produtoModel;

  String produtoID;

  Imagem imagem;

  void updateStateFromProdutoModel() {
    imagemCRUD = produtoModel.imagem;
    print('>>> imagemCRUD <<< ${imagemCRUD}');
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
    if (event is UpdateProdutoIDEvent) {
      _state.produtoID = event.produtoID;

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
  }

  void dispose() {
    _stateController.close();
    _eventController.close();
  }
}

// _produtoModelListController.close();
// _produtoModelController.close();
// //ProdutoModel
// final _produtoModelController = BehaviorSubject<ProdutoModel>();
// Stream<ProdutoModel> get produtoModelStream => _produtoModelController.stream;
// Function get produtoModelSink => _produtoModelController.sink.add;
// Authenticacação
// final _authBloc = AuthBloc(AuthApiMobile(), Bootstrap.instance.firestore);
