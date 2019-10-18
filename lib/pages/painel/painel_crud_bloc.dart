import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/painel_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';
import 'package:pmsbmibile3/models/setor_censitario_painel_model.dart';
// import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;

import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:rxdart/rxdart.dart';

class PainelCrudBlocEvent {}
class GetUsuarioIDEvent extends PainelCrudBlocEvent {
  final UsuarioModel usuarioID;

  GetUsuarioIDEvent(this.usuarioID);
}
class GetPainelEvent extends PainelCrudBlocEvent {
  final String painelId;
  GetPainelEvent({this.painelId});
}

class UpdateNomeEvent extends PainelCrudBlocEvent {
  final String nome;
  UpdateNomeEvent(this.nome);
}

class UpdateTipoEvent extends PainelCrudBlocEvent {
  final String tipo;
  UpdateTipoEvent(this.tipo);
}

class SaveEvent extends PainelCrudBlocEvent {}
class DeleteDocumentEvent extends PainelCrudBlocEvent {}

class PainelCrudBlocState {
  String painelId;
  PainelModel painel;
  bool isDataValid = false;
  String nome;
  String tipo;
    UsuarioModel usuarioID;

  void updateState() {
    nome = painel.nome;
    tipo = painel.tipo;
  }
}

class PainelCrudBloc {
  //Firestore
  //Firestore
  // final fsw.Firestore _firestore;
  final fw.Firestore _firestore;
  final _authBloc;

  //Eventos
  final _eventController = BehaviorSubject<PainelCrudBlocEvent>();
  Stream<PainelCrudBlocEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final PainelCrudBlocState _state = PainelCrudBlocState();
  final _stateController = BehaviorSubject<PainelCrudBlocState>();
  Stream<PainelCrudBlocState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  //Bloc
  PainelCrudBloc(
    this._firestore,
        this._authBloc,

  ) {
    eventStream.listen(_mapEventToState);
          _authBloc.perfil.listen((usuarioID) {
        eventSink(GetUsuarioIDEvent(usuarioID));
      });
  }

  void dispose() async {
    await _stateController.drain();
    _stateController.close();
    await _eventController.drain();
    _eventController.close();
  }

  _validateData() {
    _state.isDataValid = true;
    // if (_state.painel == null && _state.nome != null) {
    //   _state.isDataValid = false;
    // }
  }

  _mapEventToState(PainelCrudBlocEvent event) async {
    if (event is GetPainelEvent) {
      final docRef = _firestore
          .collection(PainelModel.collection)
          .document(event.painelId);
_state.painelId=event.painelId;
      final snap = await docRef.get();
      if (snap.exists) {
        _state.painel = PainelModel(id: snap.documentID).fromMap(snap.data);
        _state.updateState();
      }
    }
        if (event is GetUsuarioIDEvent) {
      //Atualiza estado com usuario logado
      _state.usuarioID = event.usuarioID;
    }
    if (event is UpdateNomeEvent) {
      _state.nome = event.nome;
    }
    if (event is UpdateTipoEvent) {
      _state.tipo = event.tipo;
      print('radiovalue=${_state.tipo}');
    }
    if (event is SaveEvent) {
      final docRef = _firestore
          .collection(PainelModel.collection)
          .document(_state.painelId);
      await docRef.setData({
        'nome': _state.nome,
        'tipo': _state.tipo,
        'modificado': Bootstrap.instance.fieldValue.serverTimestamp(),
        'usuarioID': UsuarioID(id: _state.usuarioID.id, nome: _state.usuarioID.nome).toMap()
      }, merge: true);
    }

    if (event is DeleteDocumentEvent) {

      _firestore
          .collection(PainelModel.collection)
          .document(_state.painel.id)
          .delete();
    }

    _validateData();
    if (!_stateController.isClosed) _stateController.add(_state);
    print('event.runtimeType em PainelCrudBloc  = ${event.runtimeType}');
  }
}
