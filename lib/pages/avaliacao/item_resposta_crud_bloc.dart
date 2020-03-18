import 'package:pmsbmibile3/models/ia_item_model.dart';
import 'package:pmsbmibile3/models/ia_item_resposta_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';
import 'package:pmsbmibile3/models/setor_censitario_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

class ItemRespostaCRUDBlocEvent {}

class GetUsuarioAuthEvent extends ItemRespostaCRUDBlocEvent {
  final UsuarioModel usuarioAuth;

  GetUsuarioAuthEvent(this.usuarioAuth);
}

class GetItemEvent extends ItemRespostaCRUDBlocEvent {
  final String itemId;

  GetItemEvent(this.itemId);
}

class GetSetorListEvent extends ItemRespostaCRUDBlocEvent {}

class GetRespostaEvent extends ItemRespostaCRUDBlocEvent {
  final String respostaId;

  GetRespostaEvent(this.respostaId);
}

class UpdateAtivoEvent extends ItemRespostaCRUDBlocEvent {
  final bool ativo;
  UpdateAtivoEvent(this.ativo);
}

class UpdateTextFieldEvent extends ItemRespostaCRUDBlocEvent {
  final String campo;
  final String texto;
  UpdateTextFieldEvent(this.campo, this.texto);
}

class UpdatePrecisaAlgoritmoPSimulacaoEvent extends ItemRespostaCRUDBlocEvent {
  final bool precisa;
  UpdatePrecisaAlgoritmoPSimulacaoEvent(this.precisa);
}

class SelectPastaIDEvent extends ItemRespostaCRUDBlocEvent {
  final SetorCensitarioModel pasta;

  SelectPastaIDEvent(this.pasta);
}

class SaveEvent extends ItemRespostaCRUDBlocEvent {}

class DeleteDocumentEvent extends ItemRespostaCRUDBlocEvent {}

class ItemRespostaCRUDBlocState {
  bool isDataValid = false;
  String itemId;
  String respostaId;
  UsuarioModel usuarioAuth;

  IAItemModel item = IAItemModel();
  List<SetorCensitarioModel> setorList = List<SetorCensitarioModel>();

  IAItemRespostaModel resposta = IAItemRespostaModel();

  // dynamic data;
  String atendeTR;
  String documento;
  String descricao;
  SetorCensitarioID setorDestino;

  void updateState() {
    atendeTR = resposta.atendeTR;
    documento = resposta.documento;
    descricao = resposta.descricao;
    setorDestino = resposta?.setor;
  }
}

class ItemRespostaCRUDBloc {
  /// Firestore
  final fsw.Firestore _firestore;
  final _authBloc;

  /// Eventos
  final _eventController = BehaviorSubject<ItemRespostaCRUDBlocEvent>();
  Stream<ItemRespostaCRUDBlocEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  /// Estados
  final ItemRespostaCRUDBlocState _state = ItemRespostaCRUDBlocState();
  final _stateController = BehaviorSubject<ItemRespostaCRUDBlocState>();
  Stream<ItemRespostaCRUDBlocState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  /// Bloc
  ItemRespostaCRUDBloc(this._firestore, this._authBloc) {
    eventStream.listen(_mapEventToState);
    _authBloc.perfil.listen((usuarioAuth) {
      eventSink(GetUsuarioAuthEvent(usuarioAuth));
      if (!_stateController.isClosed) _stateController.add(_state);
    });
    eventSink(GetSetorListEvent());
  }

  void dispose() async {
    await _stateController.drain();
    _stateController.close();
    await _eventController.drain();
    _eventController.close();
  }

  _validateData() {
    _state.isDataValid = true;
    if (_state.atendeTR == null) {
      _state.isDataValid = false;
    }
    if (_state.descricao == null) {
      _state.isDataValid = false;
    }
    if (_state.documento == null) {
      _state.isDataValid = false;
    }
    if (_state.setorDestino == null) {
      _state.isDataValid = false;
    }
    if (_state.documento == null) {
      _state.isDataValid = false;
    }
  }

  _mapEventToState(ItemRespostaCRUDBlocEvent event) async {
    if (event is GetUsuarioAuthEvent) {
      _state.usuarioAuth = event.usuarioAuth;
    }
    if (event is GetSetorListEvent) {
      final streamDocsRemetente = _firestore
          .collection(SetorCensitarioModel.collection)
          .orderBy('nome')
          .snapshots();

      final snapListRemetente = streamDocsRemetente.map((snapDocs) => snapDocs
          .documents
          .map((doc) =>
              SetorCensitarioModel(id: doc.documentID).fromMap(doc.data))
          .toList());

      snapListRemetente.listen((List<SetorCensitarioModel> setorList) {
        // setorList.sort((a, b) => a.numero.compareTo(b.numero));
        _state.setorList.clear();
        _state.setorList = setorList;
        // print(_state.pastaList);
        if (!_stateController.isClosed) _stateController.add(_state);
      });
    }
    if (event is GetItemEvent) {
      _state.itemId = event.itemId;
      final docRef =
          _firestore.collection(IAItemModel.collection).document(event.itemId);
      final snap = await docRef.get();
      if (snap.exists) {
        _state.item = IAItemModel(id: snap.documentID).fromMap(snap.data);
      }
    }

    if (event is GetRespostaEvent) {
      _state.respostaId = event.respostaId;
      final docRef = _firestore
          .collection(IAItemModel.collection)
          .document(_state.itemId)
          .collection(IAItemRespostaModel.collection)
          .document(event.respostaId);
      final snap = await docRef.get();
      if (snap.exists) {
        _state.resposta =
            IAItemRespostaModel(id: snap.documentID).fromMap(snap.data);
        _state.updateState();
      }
    }

    if (event is UpdateTextFieldEvent) {
      if (event.campo == 'atendeTR') {
        _state.atendeTR = event.texto;
      } else if (event.campo == 'descricao') {
        _state.descricao = event.texto;
      } else if (event.campo == 'documento') {
        _state.documento = event.texto;
      }
    }

    if (event is SelectPastaIDEvent) {
      _state.setorDestino =
          SetorCensitarioID(id: event.pasta.id, nome: event.pasta.nome);
    }

    if (event is SaveEvent) {
      final docRef = _firestore
          .collection(IAItemModel.collection)
          .document(_state.itemId)
          .collection(IAItemRespostaModel.collection)
          .document(_state.respostaId);

      IAItemRespostaModel itemrespostaUpdate = IAItemRespostaModel(
        atendeTR: _state.atendeTR,
        descricao: _state.descricao,
        documento: _state.documento,
        modificado: DateTime.now(),
        setor: _state.setorDestino,
        usuario:
            UsuarioID(id: _state.usuarioAuth.id, nome: _state.usuarioAuth.nome),
      );

      await docRef.setData(itemrespostaUpdate.toMap(), merge: true);
    }
    if (event is DeleteDocumentEvent) {
      _firestore
          .collection(IAItemModel.collection)
          .document(_state.itemId)
          .collection(IAItemRespostaModel.collection)
          .document(_state.respostaId)
          .delete();
    }

    _validateData();
    if (!_stateController.isClosed) _stateController.add(_state);
    print('event.runtimeType em ItemRespostaCRUDBloc  = ${event.runtimeType}');
  }
}
