import 'package:pmsbmibile3/api/auth_api_mobile.dart';
import 'package:pmsbmibile3/models/produto_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:pmsbmibile3/pages/pages.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'package:pmsbmibile3/bootstrap.dart';

class ProdutoHomePageEvent {}

class UpdateUsuarioIDEvent extends ProdutoHomePageEvent {
  final String usuarioID;

  UpdateUsuarioIDEvent(this.usuarioID);
}

// class UpdateProdutoIDTextoEvent extends ProdutoHomePageEvent {
//   final String produtoIDTexto;

//   UpdateProdutoIDTextoEvent(this.produtoIDTexto);
// }

// class UpdateProdutoIDNomeEvent extends ProdutoHomePageEvent {
//   final String produtoIDNome;

//   UpdateProdutoIDNomeEvent(this.produtoIDNome);
// }

// class UpdateProdutoIDEvent extends ProdutoHomePageEvent {
//   final String produtoID;

//   UpdateProdutoIDEvent(this.produtoID);
// }

// class SaveProdutoIDEvent extends ProdutoHomePageEvent {}

class ProdutoHomePageState {
  UsuarioModel usuarioModel;
  // ProdutoModel produtoModel;
  // String produtoModelID;
  // String produtoModelIDNome;
  // String produtoModelIDTexto;
}

class ProdutoHomePageBloc {
  //Firestore
  final fw.Firestore _firestore;

  // Authenticacação
  final _authBloc = AuthBloc(AuthApiMobile(), Bootstrap.instance.firestore);

  //Eventos
  final _produtoHomePageEventController =
      BehaviorSubject<ProdutoHomePageEvent>();
  Stream<ProdutoHomePageEvent> get produtoHomePageEventStream =>
      _produtoHomePageEventController.stream;
  Function get produtoHomePageEventSink =>
      _produtoHomePageEventController.sink.add;

  //Estados
  final ProdutoHomePageState _produtoHomePageState = ProdutoHomePageState();
  final _produtoHomePageStateController =
      BehaviorSubject<ProdutoHomePageState>();
  Stream<ProdutoHomePageState> get produtoHomePageStateStream =>
      _produtoHomePageStateController.stream;
  Function get produtoHomePageStateSink =>
      _produtoHomePageStateController.sink.add;

  //ProdutoModel List
  final _produtoModelListController = BehaviorSubject<List<ProdutoModel>>();
  Stream<List<ProdutoModel>> get produtoModelListStream =>
      _produtoModelListController.stream;
  Function get produtoModelListSink => _produtoModelListController.sink.add;

  // //ProdutoModel
  // final _produtoModelController = BehaviorSubject<ProdutoModel>();
  // Stream<ProdutoModel> get produtoModelStream => _produtoModelController.stream;
  // Function get produtoModelSink => _produtoModelController.sink.add;

  //Bloc
  ProdutoHomePageBloc(this._firestore) {
    produtoHomePageEventStream.listen(_mapEventToState);
    _authBloc.userId.listen(
        (userId) => produtoHomePageEventSink(UpdateUsuarioIDEvent(userId)));
  }

  _mapEventToState(ProdutoHomePageEvent event) {
    if (event is UpdateUsuarioIDEvent) {
      //Atualiza estado com usuario logado
      _firestore
          .collection(UsuarioModel.collection)
          .document(event.usuarioID)
          .snapshots()
          .map((snap) => UsuarioModel(id: snap.documentID).fromMap(snap.data))
          .listen((usuarioModel) async {
        _produtoHomePageState.usuarioModel = usuarioModel;
        // print('>> usuarioModel 1 >> ${usuarioModel.toMap()}');
        await produtoHomePageStateSink(_produtoHomePageState);
        // print('>> usuarioModel 2 >> ${_produtoHomePageState.usuarioModel.toMap()}');
      });

      // le todos os produtos associados e ele, setor e eixo.
      produtoHomePageStateStream.listen((state) {
          // print('>> usuarioModel 3 >> ${state.usuarioModel.toMap()}');
      
        _firestore
            .collection(ProdutoModel.collection)
            .where("eixoID.id", isEqualTo: state.usuarioModel.eixoIDAtual.id)
            .where("setorCensitarioID.id",
                isEqualTo: state.usuarioModel.setorCensitarioID.id)
            .snapshots()
            .map((snapDocs) => snapDocs.documents
                .map(
                    (doc) => ProdutoModel(id: doc.documentID).fromMap(doc.data))
                .toList())
            .listen((List<ProdutoModel> produtoModelList) {
          produtoModelListSink(produtoModelList);
        });
      });
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
  }

  void dispose() {
    _produtoHomePageStateController.close();
    _produtoHomePageEventController.close();
    _authBloc.dispose();
    _produtoModelListController.close();
    // _produtoModelController.close();
  }
}
