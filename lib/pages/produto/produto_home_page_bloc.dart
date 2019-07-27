import 'package:pmsbmibile3/models/produto_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;
import 'package:rxdart/rxdart.dart';


class ProdutoHomePageEvent {}

class UpdateUsuarioIDEvent extends ProdutoHomePageEvent {
  final String usuarioID;

  UpdateUsuarioIDEvent(this.usuarioID);
}

class ProdutoHomePageState {
  UsuarioModel usuarioModel;
}

class ProdutoHomePageBloc {
  //Firestore
  final fw.Firestore _firestore;
  final _authBloc;

  //Eventos
  final _eventController = BehaviorSubject<ProdutoHomePageEvent>();
  Stream<ProdutoHomePageEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final ProdutoHomePageState _state = ProdutoHomePageState();
  final _stateController = BehaviorSubject<ProdutoHomePageState>();
  Stream<ProdutoHomePageState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  //ProdutoModel List
  final _produtoModelListController = BehaviorSubject<List<ProdutoModel>>();
  Stream<List<ProdutoModel>> get produtoModelListStream =>
      _produtoModelListController.stream;
  Function get produtoModelListSink => _produtoModelListController.sink.add;

  //Bloc
  ProdutoHomePageBloc(this._firestore, this._authBloc) {
    eventStream.listen(_mapEventToState);
    _authBloc.userId.listen((userId)  {
    eventSink(UpdateUsuarioIDEvent(userId));
    });
  }

  _mapEventToState(ProdutoHomePageEvent event) async {
    if (event is UpdateUsuarioIDEvent) {
        //Atualiza estado com usuario logado
        final docRef =
            _firestore.collection(UsuarioModel.collection).document(event.usuarioID);
        final docSnap = await docRef.get();
        if (docSnap.exists) {
          final usuarioModel =
              UsuarioModel(id: docSnap.documentID).fromMap(docSnap.data);
          _state.usuarioModel = usuarioModel;
          if (!_stateController.isClosed) _stateController.add(_state);
        }

      // le todos os produtos associados e ele, setor e eixo.
      final streamDocs = _firestore
          .collection(ProdutoModel.collection)
          .where("eixoID.id", isEqualTo: _state.usuarioModel.eixoIDAtual.id)
          .where("setorCensitarioID.id",
              isEqualTo: _state.usuarioModel.setorCensitarioID.id)
          .snapshots();

      final snapList = streamDocs.map((snapDocs) => snapDocs.documents
          .map((doc) => ProdutoModel(id: doc.documentID).fromMap(doc.data))
          .toList());

      snapList.listen((List<ProdutoModel> produtoModelList) {
        produtoModelListSink(produtoModelList);
      });

    }

    if (!_stateController.isClosed) _stateController.add(_state);
    print(event.runtimeType);
  }

  void dispose() {
    _stateController.close();
    _eventController.close();
    _produtoModelListController.close();
  }
}

// if (event is UpdateProdutoIDEvent) {
//   // if (event.produtoID == null) {
//   //   print('>>> <<< Novo');
//   //   _produtoHomePageState.produtoModel = ProdutoModel();
//   // } else {
//   _firestore
//       .collection(ProdutoModel.collection)
//       .document(event.produtoID)
//       .snapshots()
//       .map((snap) => ProdutoModel(id: snap.documentID).fromMap(snap.data))
//       .listen((produtoModel) async {
//     _produtoHomePageState.produtoModel = produtoModel;
//     await produtoHomePageStateSink(_produtoHomePageState);
//     // print('>> produtoModel >> ${produtoModel.toMap()}');
//   });
// }

// if (event is UpdateProdutoIDNomeEvent) {
//   _produtoHomePageState.produtoModelIDNome = event.produtoIDNome;
//   produtoHomePageStateSink(_produtoHomePageState);
// }

// if (event is UpdateProdutoIDTextoEvent) {
//   _produtoHomePageState.produtoModelIDTexto = event.produtoIDTexto;
//   produtoHomePageStateSink(_produtoHomePageState);
// }

// if (event is SaveProdutoIDEvent) {
//   Map<String, dynamic> produtoModelMap = Map<String, dynamic>();
//   produtoModelMap['nome'] = _produtoHomePageState.produtoModelIDNome;
//   produtoModelMap['eixoID'] =
//       _produtoHomePageState.usuarioModel.eixoIDAtual.toMap();
//   produtoModelMap['setorCensitarioID'] =
//       _produtoHomePageState.usuarioModel.setorCensitarioID.toMap();
//   produtoModelMap['usuarioIDEditou'] = {
//     "id": _produtoHomePageState.usuarioModel.id,
//     "nome": _produtoHomePageState.usuarioModel.nome
//   };

//   ProdutoModel produtoModel = ProdutoModel().fromMap(produtoModelMap);
//   produtoModel.modificado=DateTime.now().toUtc();
//   final map = produtoModel.toMap();
//   // print('>>> map <<< ${map}');
//   _firestore
//       .collection(ProdutoModel.collection)
//       .document(_produtoHomePageState.produtoModelID)
//       .setData(map, merge: true);
// }
