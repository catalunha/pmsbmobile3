import 'package:pmsbmibile3/api/auth_api_mobile.dart';
import 'package:pmsbmibile3/models/produto_model.dart';
import 'package:pmsbmibile3/models/produto_texto_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:pmsbmibile3/pages/pages.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'package:pmsbmibile3/bootstrap.dart';

class ProdutoArquivoListPageEvent {}

class UpdateProdutoIDTipoEvent extends ProdutoArquivoListPageEvent {
  final String produtoID;
  final String tipo;

  UpdateProdutoIDTipoEvent(this.produtoID, this.tipo);

}

class ProdutoArquivoListPageState {
  ProdutoModel produtoModel;

  String produtoID;
  String tipo;

  Map<String, ArquivoProduto> arquivo;

  void updateStateFromProdutoModel() {
    arquivo = Map<String, ArquivoProduto>();
    produtoModel.arquivo.forEach((k, v) {
      if (v.tipo==this.tipo) {
        arquivo[k]=v;
      }
    });
  }

  // Map<String, dynamic> toMap() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['produtoID'] = this.produtoID;
  //   data['produtoModel'] = this.produtoModel.toMap();
  //   data['arquivoList'] = this.arquivoList.map((v) => v.toMap()).toList();
  //   return data;
  // }
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

  _mapEventToState(ProdutoArquivoListPageEvent event) async {
    if (event is UpdateProdutoIDTipoEvent) {
      _state.produtoID = event.produtoID;
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
    if (!_stateController.isClosed) _stateController.add(_state);

    // print('>>> _state.toMap() <<< ${_state.toMap()}');
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
