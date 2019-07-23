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

class ProdutoCRUDPageEvent {}

class UpdateUsuarioIDEvent extends ProdutoCRUDPageEvent {
  final String usuarioID;

  UpdateUsuarioIDEvent(this.usuarioID);
}

class UpdateProdutoIDEvent extends ProdutoCRUDPageEvent {
  final String produtoID;

  UpdateProdutoIDEvent(this.produtoID);
}

class UpdateProdutoIDNomeEvent extends ProdutoCRUDPageEvent {
  final String produtoIDNome;

  UpdateProdutoIDNomeEvent(this.produtoIDNome);
}

class SaveProdutoIDEvent extends ProdutoCRUDPageEvent {}

class DeleteProdutoIDEvent extends ProdutoCRUDPageEvent {}

class ProdutoCRUDPageState {
  UsuarioModel usuarioModel;
  ProdutoModel produtoModel;
  String produtoModelID;
  String produtoModelIDNome;

  void updateStateFromProdutoModel() {
    produtoModelIDNome = produtoModel.nome;
  }
}

class ProdutoCRUDPageBloc {
  //Firestore
  final fw.Firestore _firestore;

  // Authenticacação
  final _authBloc = AuthBloc(AuthApiMobile(), Bootstrap.instance.firestore);

  //Eventos
  final _eventController = BehaviorSubject<ProdutoCRUDPageEvent>();
  Stream<ProdutoCRUDPageEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final ProdutoCRUDPageState _state = ProdutoCRUDPageState();
  final _stateController = BehaviorSubject<ProdutoCRUDPageState>();
  Stream<ProdutoCRUDPageState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  //ProdutoModel
  final _produtoModelController = BehaviorSubject<ProdutoModel>();
  Stream<ProdutoModel> get produtoModelStream => _produtoModelController.stream;
  Function get produtoModelSink => _produtoModelController.sink.add;

  //Bloc
  ProdutoCRUDPageBloc(this._firestore) {
    eventStream.listen(_mapEventToState);
    _authBloc.userId
        .listen((userId) => eventSink(UpdateUsuarioIDEvent(userId)));
  }

  _mapEventToState(ProdutoCRUDPageEvent event) async {
    if (event is UpdateUsuarioIDEvent) {
      //Atualiza estado com usuario logado
      final docRef = _firestore
          .collection(UsuarioModel.collection)
          .document(event.usuarioID);

      final snap = await docRef.get();
      
      if (snap.exists) {
        _state.usuarioModel =
            UsuarioModel(id: snap.documentID).fromMap(snap.data);
      }
    }

    if (event is UpdateProdutoIDEvent) {
      if (event.produtoID != null) {
        _state.produtoModelID = event.produtoID;
        //Atualiza estado com produto
        final docRef = _firestore
            .collection(ProdutoModel.collection)
            .document(event.produtoID);

        final snap = await docRef.get();
        if (snap.exists) {
          _state.produtoModel =
              ProdutoModel(id: snap.documentID).fromMap(snap.data);
          _state.updateStateFromProdutoModel();
        }
      }
    }

    if (event is UpdateProdutoIDNomeEvent) {
      _state.produtoModelIDNome = event.produtoIDNome;
    }

    if (event is SaveProdutoIDEvent) {
      final produtoModelSave = ProdutoModel(
        nome: _state.produtoModelIDNome,
        eixoID: _state.usuarioModel.eixoIDAtual,
        setorCensitarioID: _state.usuarioModel.setorCensitarioID,
        usuarioID: UsuarioID(
            id: _state.usuarioModel.id, nome: _state.usuarioModel.nome),
        modificado: DateTime.now().toUtc(),
      );

      final docRefColl = _firestore
          .collection(ProdutoModel.collection)
          .document(_state.produtoModelID);
      docRefColl.setData(produtoModelSave.toMap(), merge: true);

      final produtoTextoModelSave = ProdutoTextoModel(
        textoMarkdown: "Pronto para iniciar edição.",
        editando: false,
        usuarioID: UsuarioID(
            id: _state.usuarioModel.id, nome: _state.usuarioModel.nome),
      );

      final docRefSubColl = docRefColl
          .collection(ProdutoTextoModel.collection)
          .document(_state.produtoModel.textoMarkdownID);
      docRefSubColl.setData(produtoTextoModelSave.toMap(), merge: true);

      docRefSubColl.get().then((docSnap) {
        docRefColl
            .setData({"textoMarkdownID": docSnap.documentID}, merge: true);
      });
    }

    if (event is DeleteProdutoIDEvent) {
      final docRef = _firestore
          .collection(ProdutoModel.collection)
          .document(_state.produtoModelID);
      docRef.delete();
    }
    if (!_stateController.isClosed) _stateController.add(_state);
    print(event.runtimeType);
  }

  void dispose() {
    _stateController.close();
    _eventController.close();
    _authBloc.dispose();
    _produtoModelController.close();
  }
}

//     .snapshots()
//     .map((snap) => ProdutoModel(id: snap.documentID).fromMap(snap.data))
//     .listen((produtoModel) async {
//   _state.produtoModel = produtoModel;
//   _state.produtoModelIDNome = produtoModel.nome;
//   _state.produtoModelID = produtoModel.id;
//   await stateSink(_state);
// });
// ProdutoTextoModel produtoTextoModel =
//     ProdutoTextoModel().fromMap(produtoTextoModelMap);
// produtoTextoModel.modificado = DateTime.now().toUtc();
// final mapProdutoTextoModel = produtoTextoModel.toMap();

// ProdutoModel produtoModel = ProdutoModel().fromMap(produtoModelMap);
// produtoModel.modificado = DateTime.now().toUtc();
// final mapProdutoModel = produtoModel.toMap();

// Map<String, dynamic> produtoTextoModelMap = Map<String, dynamic>();
// produtoTextoModelMap['textoMarkdown'] = "Pronto para iniciar edição.";
// produtoTextoModelMap['editando'] = false;
// produtoTextoModelMap['usuarioIDEditou'] = {
//   "id": _state.usuarioModel.id,
//   "nome": _state.usuarioModel.nome
// };
// Map<String, dynamic> produtoModelMap = Map<String, dynamic>();
// produtoModelMap['nome'] = _state.produtoModelIDNome;
// produtoModelMap['eixoID'] = _state.usuarioModel.eixoIDAtual.toMap();
// produtoModelMap['setorCensitarioID'] =
//     _state.usuarioModel.setorCensitarioID.toMap();
// produtoModelMap['usuarioIDEditou'] = {
//   "id": _state.usuarioModel.id,
//   "nome": _state.usuarioModel.nome
// };
