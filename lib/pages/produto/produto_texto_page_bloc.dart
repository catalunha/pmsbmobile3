import 'package:pmsbmibile3/api/auth_api_mobile.dart';
import 'package:pmsbmibile3/models/produto_model.dart';
import 'package:pmsbmibile3/models/produto_texto_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:pmsbmibile3/pages/pages.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'package:pmsbmibile3/bootstrap.dart';

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

  _mapEventToState(ProdutoTextoPageEvent event) async {
    if (event is UpdateProdutoIDEvent) {
      final docRefColl = _firestore
          .collection(ProdutoModel.collection)
          .document(event.produtoID);

      final docSnap = await docRefColl.get();

      if (docSnap.exists) {
        _state.produtoID = docSnap.documentID;
        _state.produtoTextoID = docSnap.data['textoMarkdownID'];

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
    print(' >>> ProdutoTextoPageEvent <<< ${event.runtimeType}');
    print(' >>> ProdutoTextoPageEvent <<< ${_state.produtoID}');
    print(' >>> ProdutoTextoPageEvent <<< ${_state.produtoTextoID}');
    print(' >>> ProdutoTextoPageEvent <<< ${_state.produtoTextoIDTextoMarkdown}');
  }

  void dispose() {
    _stateController.close();
    _eventController.close();
  }
}

// if (event is UpdateUsuarioIDEvent) {
//   //Atualiza estado com usuario logado
//   _firestore
//       .collection(UsuarioModel.collection)
//       .document(event.usuarioID)
//       .snapshots()
//       .map((snap) => UsuarioModel(id: snap.documentID).fromMap(snap.data))
//       .listen((usuarioModel) async {
//     _produtoTextoPageState.usuarioModel = usuarioModel;
//     // print('>> usuarioModel 1 >> ${usuarioModel.toMap()}');
//     await produtoTextoPageStateSink(_produtoTextoPageState);
//     // print('>> usuarioModel 2 >> ${_produtoTextoPageState.usuarioModel.toMap()}');
//   });

//   // le todos os produtos associados e ele, setor e eixo.
//   produtoTextoPageStateStream.listen((state) {
//       // print('>> usuarioModel 3 >> ${state.usuarioModel.toMap()}');

//     _firestore
//         .collection(ProdutoModel.collection)
//         .where("eixoID.id", isEqualTo: state.usuarioModel.eixoIDAtual.id)
//         .where("setorCensitarioID.id",
//             isEqualTo: state.usuarioModel.setorCensitarioID.id)
//         .snapshots()
//         .map((snapDocs) => snapDocs.documents
//             .map(
//                 (doc) => ProdutoModel(id: doc.documentID).fromMap(doc.data))
//             .toList())
//         .listen((List<ProdutoModel> produtoModelList) {
//       produtoModelListSink(produtoModelList);
//     });
//   });
// }

// if (event.produtoID == null) {
//   print('>>> <<< Novo');
//   _produtoTextoPageState.produtoModel = ProdutoModel();
// } else {
//   _firestore
//       .collection(ProdutoTextoModel.collection)
//       .document(event.produtoID)
//       .snapshots()
//       .map((snap) =>
//           ProdutoTextoModel(id: snap.documentID).fromMap(snap.data))
//       .listen((produtoTexto) async {
//     _produtoTextoPageState.produtoTexto = produtoTexto;
//     await produtoTextoPageStateSink(_produtoTextoPageState);
//     // print('>> produtoModel >> ${produtoModel.toMap()}');
//   });
// }
// _firestore
//     .collection(ProdutoModel.collection)
//     .document(_produtoTextoPageState.produtoID)
//     .collection(ProdutoTextoModel.collection)
//     .document(_produtoTextoPageState.produtoTextoID)
//     .setData({"editando": true}, merge: true);
// _firestore
//     .collection(ProdutoModel.collection)
//     .document(_produtoTextoPageState.produtoID)
//     .collection(ProdutoTextoModel.collection)
//     .document(_produtoTextoPageState.produtoTextoID)
//     .setData({"editando": true}, merge: true);
// if (event is UpdateProdutoIDNomeEvent) {
//   _produtoTextoPageState.produtoModelIDNome = event.produtoIDNome;
//   produtoTextoPageStateSink(_produtoTextoPageState);
// }
// _produtoTextoPageState.produtoTextoIDTexto = event.produtoTextoIDTexto;
// produtoTextoPageStateSink(_produtoTextoPageState);

// //ProdutoModel
// final _produtoModelController = BehaviorSubject<ProdutoModel>();
// Stream<ProdutoModel> get produtoModelStream => _produtoModelController.stream;
// Function get produtoModelSink => _produtoModelController.sink.add;
// // Authenticacação
// final _authBloc = AuthBloc(AuthApiMobile(), Bootstrap.instance.firestore);
      // print('>>> event. <<<');
      // Map<String, dynamic> produtoTextoModelMap = Map<String, dynamic>();
      // produtoTextoModelMap['textoMarkdown'] =
      //     _state.produtoTextoIDTextoMarkdown;
      // produtoTextoModelMap['editando'] = false;

      // ProdutoTextoModel produtoTextoModel =
      //     ProdutoTextoModel().fromMap(produtoTextoModelMap);
      // produtoTextoModel.modificado = DateTime.now().toUtc();
      // final mapProdutoTextoModel = produtoTextoModel.toMap();
      // print('>>> mapProdutoTextoModel <<< ${mapProdutoTextoModel}');
      // print('>>> _produtoTextoPageState.produtoID 2 <<< ${_state.produtoID}');
      // print(
      //     '>>> _produtoTextoPageState.produtoTextoID <<< ${_state.produtoTextoID}');
