import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';
import 'package:pmsbmibile3/models/setor_censitario_painel_model.dart';
// import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;

import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:rxdart/rxdart.dart';

class SetorPainelCrudBlocEvent {}

class GetUsuarioIDEvent extends SetorPainelCrudBlocEvent {
  final UsuarioModel usuarioID;

  GetUsuarioIDEvent(this.usuarioID);
}

class GetSetorCensitarioIDEvent extends SetorPainelCrudBlocEvent {
  final String setorCensitarioId;
  GetSetorCensitarioIDEvent({this.setorCensitarioId});
}

class UpdateValorEvent extends SetorPainelCrudBlocEvent {
  final dynamic valor;
  UpdateValorEvent(this.valor);
}

class UpdateObservacaoEvent extends SetorPainelCrudBlocEvent {
  final String observacao;
  UpdateObservacaoEvent(this.observacao);
}

class UpdateBooleanoEvent extends SetorPainelCrudBlocEvent {
  final bool valor;
  UpdateBooleanoEvent(this.valor);
}

class SaveEvent extends SetorPainelCrudBlocEvent {}

class SetorPainelCrudBlocState {
  UsuarioModel usuarioID;
  SetorCensitarioPainelModel setorCensitarioPainelID;
  bool isDataValid = false;
  dynamic valor;
  String observacao;
  void updateState() {
    if (setorCensitarioPainelID.painelID.tipo == 'booleano' && setorCensitarioPainelID?.valor == null) {
      // if (setorCensitarioPainelID?.valor == null) {
        valor = false;
      // } else {
      //   valor = setorCensitarioPainelID.valor;
      // }
    } else {
      valor = setorCensitarioPainelID.valor;
    }
    observacao = setorCensitarioPainelID.observacao;
  }
}

class SetorPainelCrudBloc {
  //Firestore
  //Firestore
  // final fsw.Firestore _firestore;
    final fw.Firestore _firestore;

  final _authBloc;

  //Eventos
  final _eventController = BehaviorSubject<SetorPainelCrudBlocEvent>();
  Stream<SetorPainelCrudBlocEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final SetorPainelCrudBlocState _state = SetorPainelCrudBlocState();
  final _stateController = BehaviorSubject<SetorPainelCrudBlocState>();
  Stream<SetorPainelCrudBlocState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  //Bloc
  SetorPainelCrudBloc(
    this._authBloc,
    this._firestore,
  ) {
    eventStream.listen(_mapEventToState);
  }

  void dispose() async {
    await _stateController.drain();
    _stateController.close();
    await _eventController.drain();
    _eventController.close();
  }

  _validateData() {
    _state.isDataValid = false;
    if (_state?.setorCensitarioPainelID?.painelID != null) {
      _state.isDataValid = true;
    } else {
      _state.isDataValid = false;
    }
  }

  _mapEventToState(SetorPainelCrudBlocEvent event) async {
    if (event is GetSetorCensitarioIDEvent) {
      final docRef = _firestore.collection(SetorCensitarioPainelModel.collection).document(event.setorCensitarioId);

      final snap = await docRef.get();
      if (snap.exists) {
        _state.setorCensitarioPainelID = SetorCensitarioPainelModel(id: snap.documentID).fromMap(snap.data);
        _state.updateState();
      }
      // print(_state.setorCensitarioPainelID.toString());
      _authBloc.perfil.listen((usuarioID) {
        eventSink(GetUsuarioIDEvent(usuarioID));
      });
    }
    if (event is GetUsuarioIDEvent) {
      //Atualiza estado com usuario logado
      _state.usuarioID = event.usuarioID;
    }
    if (event is UpdateValorEvent) {
      _state.valor = event.valor;
    }
    if (event is UpdateObservacaoEvent) {
      _state.observacao = event.observacao;
    }
    if (event is UpdateBooleanoEvent) {
      _state.valor = event.valor;
    }
    if (event is SaveEvent) {
      final docRef =
          _firestore.collection(SetorCensitarioPainelModel.collection).document(_state.setorCensitarioPainelID.id);
      await docRef.setData({
        'valor': _state.valor,
        'observacao': _state.observacao,
        'modificada': Bootstrap.instance.fieldValue.serverTimestamp(),
        'usuarioID': UsuarioID(id: _state.usuarioID.id, nome: _state.usuarioID.nome).toMap()
      }, merge: true);
    }

    _validateData();
    if (!_stateController.isClosed) _stateController.add(_state);
    print('event.runtimeType em PainelCrudBloc  = ${event.runtimeType}');
  }
}
