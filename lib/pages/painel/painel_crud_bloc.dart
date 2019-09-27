import 'package:pmsbmibile3/models/setor_censitario_painel_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:rxdart/rxdart.dart';

class PainelCrudBlocEvent {}

class GetSetorCensitarioIDEvent extends PainelCrudBlocEvent {
  final String setorCensitarioId;
  GetSetorCensitarioIDEvent({this.setorCensitarioId});
}

class UpdateValorEvent extends PainelCrudBlocEvent {
  final dynamic valor;
  UpdateValorEvent(this.valor);
}

class UpdateObservacaoEvent extends PainelCrudBlocEvent {
  final String observacao;
  UpdateObservacaoEvent(this.observacao);
}

class SaveEvent extends PainelCrudBlocEvent {}

class PainelCrudBlocState {
  SetorCensitarioPainelModel setorCensitarioPainelID;
    bool isDataValid = false;
dynamic valor;
String observacao;
  void updateState() {
    valor = setorCensitarioPainelID.valor;
    observacao = setorCensitarioPainelID.observacao;
  }
}


class PainelCrudBloc {
  //Firestore
  //Firestore
  final fsw.Firestore _firestore;

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
  PainelCrudBloc(this._firestore) {
    eventStream.listen(_mapEventToState);
  }

  void dispose() async {
    await _stateController.drain();
    _stateController.close();
    await _eventController.drain();
    _eventController.close();
  }

  _validateData() {
    _state.isDataValid = true;
    // if (_state.nome == null || _state.nome.isEmpty) {
    //   _state.isDataValid = false;
    // }
  }

  _mapEventToState(PainelCrudBlocEvent event) async {
    if (event is GetSetorCensitarioIDEvent) {
        final docRef = _firestore
            .collection(SetorCensitarioPainelModel.collection)
            .document(event.setorCensitarioId);

        final snap = await docRef.get();
        if (snap.exists) {
          _state.setorCensitarioPainelID =
              SetorCensitarioPainelModel(id: snap.documentID).fromMap(snap.data);
          _state.updateState();
        }
      print(_state.setorCensitarioPainelID.toString());
      }
     
    

    if (event is UpdateValorEvent) {
      _state.valor = event.valor;
    }
    if (event is UpdateObservacaoEvent) {
      _state.observacao = event.observacao;
    }

    if (event is SaveEvent) {
      // final docRef = _firestore
      //     .collection(ControleAcaoModel.collection)
      //     .document(_state.acaoID);
      // if (_state.acaoID != null) {
      //   await docRef.setData({
      //     'nome': _state.nome,
      //     'modificada': Bootstrap.instance.FieldValue.serverTimestamp()
      //   }, merge: true);
      // } else {
      //   Map<String, dynamic> acao = Map<String, dynamic>();
      //   final uuidG = uuid.Uuid();
      //   acao['referencia'] = uuidG.v4();
      //   acao['tarefa'] = ControleTarefaID(
      //           id: _state.controleTarefaoID.id,
      //           nome: _state.controleTarefaoID.nome)
      //       .toMap();
      //   acao['nome'] = _state.nome;
      //   acao['setor'] = _state.controleTarefaoID.setor.toMap();
      //   acao['remetente'] = _state.controleTarefaoID.remetente.toMap();
      //   acao['destinatario'] = _state.controleTarefaoID.destinatario.toMap();
      //   acao['concluida'] = false;
      //   acao['modificada'] = Bootstrap.instance.FieldValue.serverTimestamp();
      //   acao['ordem'] = _state.controleTarefaoID.ultimaOrdemAcao + 1;
      //   docRef.setData(acao, merge: true);

      //   final docRefTarefa = _firestore
      //       .collection(ControleTarefaModel.collection)
      //       .document(_state.tarefaID);
      //   await docRefTarefa.setData({
      //     'acaoTotal': Bootstrap.instance.FieldValue.increment(1),
      //     'ultimaOrdemAcao': Bootstrap.instance.FieldValue.increment(1),
      //     'modificada': Bootstrap.instance.FieldValue.serverTimestamp()
      //   }, merge: true);
      // }
    }

    _validateData();

    if (!_stateController.isClosed) _stateController.add(_state);
    print('event.runtimeType em PainelCrudBloc  = ${event.runtimeType}');
  }
}
