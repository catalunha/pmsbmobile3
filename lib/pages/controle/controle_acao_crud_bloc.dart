import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/controle_acao_model.dart';
import 'package:pmsbmibile3/models/controle_tarefa_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;
import 'package:uuid/uuid.dart' as uuid;

class ControleAcaoCrudBlocEvent {}

class UpdateTarefaAcaoIDEvent extends ControleAcaoCrudBlocEvent {
  final String tarefaID;
  final String acaoID;

  UpdateTarefaAcaoIDEvent({this.tarefaID, this.acaoID});
}

class UpdateNomeEvent extends ControleAcaoCrudBlocEvent {
  final String nome;

  UpdateNomeEvent(this.nome);
}

class DeleteEvent extends ControleAcaoCrudBlocEvent {}

class SaveEvent extends ControleAcaoCrudBlocEvent {}

class ControleAcaoCrudBlocState {
  String acaoID;
  String tarefaID;
  ControleAcaoModel controleAcaoID;
  ControleTarefaModel controleTarefaoID;
  String nome;
  bool isDataValid = false;

  void updateStateFromControleAcaoModel() {
    nome = controleAcaoID.nome;
  }
}

class ControleAcaoCrudBloc {
  /// Firestore
  final fw.Firestore _firestore;

  /// Eventos
  final _eventController = BehaviorSubject<ControleAcaoCrudBlocEvent>();
  Stream<ControleAcaoCrudBlocEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  /// Estados
  final ControleAcaoCrudBlocState _state = ControleAcaoCrudBlocState();
  final _stateController = BehaviorSubject<ControleAcaoCrudBlocState>();
  Stream<ControleAcaoCrudBlocState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  /// Bloc
  ControleAcaoCrudBloc(this._firestore) {
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
    if (_state.nome == null || _state.nome.isEmpty) {
      _state.isDataValid = false;
    }
  }

  _mapEventToState(ControleAcaoCrudBlocEvent event) async {
    if (event is UpdateTarefaAcaoIDEvent) {
      _state.acaoID = event.acaoID;
      _state.tarefaID = event.tarefaID;
      if (_state.acaoID != null) {
        final docRef = _firestore
            .collection(ControleAcaoModel.collection)
            .document(_state.acaoID);

        final snap = await docRef.get();
        if (snap.exists) {
          _state.controleAcaoID =
              ControleAcaoModel(id: snap.documentID).fromMap(snap.data);
          _state.updateStateFromControleAcaoModel();
        }
      }
      if (_state.tarefaID != null) {
        final docRef = _firestore
            .collection(ControleTarefaModel.collection)
            .document(_state.tarefaID);

        final snap = await docRef.get();
        if (snap.exists) {
          _state.controleTarefaoID =
              ControleTarefaModel(id: snap.documentID).fromMap(snap.data);
        }
      }
    }

    if (event is UpdateNomeEvent) {
      _state.nome = event.nome;
    }

    if (event is SaveEvent) {
      final docRef = _firestore
          .collection(ControleAcaoModel.collection)
          .document(_state.acaoID);
      if (_state.acaoID != null) {
        await docRef.setData({
          'nome': _state.nome,
          'modificada': Bootstrap.instance.fieldValue.serverTimestamp()
        }, merge: true);
      } else {
        Map<String, dynamic> acao = Map<String, dynamic>();
        final uuidG = uuid.Uuid();
        acao['referencia'] = uuidG.v4();
        acao['tarefa'] = ControleTarefaID(
                id: _state.controleTarefaoID.id,
                nome: _state.controleTarefaoID.nome)
            .toMap();
        acao['nome'] = _state.nome;
        acao['setor'] = _state.controleTarefaoID.setor.toMap();
        acao['remetente'] = _state.controleTarefaoID.remetente.toMap();
        acao['destinatario'] = _state.controleTarefaoID.destinatario.toMap();
        acao['concluida'] = false;
        acao['modificada'] = Bootstrap.instance.fieldValue.serverTimestamp();
        acao['ordem'] = _state.controleTarefaoID.ultimaOrdemAcao + 1;
        docRef.setData(acao, merge: true);

        final docRefTarefa = _firestore
            .collection(ControleTarefaModel.collection)
            .document(_state.tarefaID);
        await docRefTarefa.setData({
          'acaoTotal': Bootstrap.instance.fieldValue.increment(1),
          'ultimaOrdemAcao': Bootstrap.instance.fieldValue.increment(1),
          'modificada': Bootstrap.instance.fieldValue.serverTimestamp()
        }, merge: true);
      }
    }

    if (event is DeleteEvent) {
      _firestore
          .collection(ControleAcaoModel.collection)
          .document(_state.controleAcaoID.id)
          .delete();

      final docRefTarefa = _firestore
          .collection(ControleTarefaModel.collection)
          .document(_state.tarefaID);
      await docRefTarefa.setData({
        'acaoTotal': Bootstrap.instance.fieldValue.increment(-1),
        'modificada': Bootstrap.instance.fieldValue.serverTimestamp()
      }, merge: true);
    }
    _validateData();

    if (!_stateController.isClosed) _stateController.add(_state);
    print('event.runtimeType em ControleAcaoCrudBloc  = ${event.runtimeType}');
  }
}
