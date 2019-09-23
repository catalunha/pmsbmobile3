import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/controle_acao_model.dart';
import 'package:pmsbmibile3/models/controle_tarefa_model.dart';
import 'package:rxdart/rxdart.dart';

class ControleAcaoMarcarBlocEvent {}

class UpdateTarefaIDEvent extends ControleAcaoMarcarBlocEvent {
  final String controleTarefaID;

  UpdateTarefaIDEvent(this.controleTarefaID);
}

class UpdateAcaoEvent extends ControleAcaoMarcarBlocEvent {
  final String controleAcaoID;
  final bool concluida;

  UpdateAcaoEvent(this.controleAcaoID, this.concluida);
}

class ControleAcaoMarcarBlocState {
  ControleTarefaModel controleTarefaDestinatario = ControleTarefaModel();
  List<ControleAcaoModel> controleAcaoList = List<ControleAcaoModel>();
  bool isDataValid;
}

class ControleAcaoMarcarBloc {
  //Firestore
  final fsw.Firestore _firestore;
  // final _authBloc;

  //Eventos
  final _eventController = BehaviorSubject<ControleAcaoMarcarBlocEvent>();
  Stream<ControleAcaoMarcarBlocEvent> get eventStream =>
      _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final ControleAcaoMarcarBlocState _state = ControleAcaoMarcarBlocState();
  final _stateController = BehaviorSubject<ControleAcaoMarcarBlocState>();
  Stream<ControleAcaoMarcarBlocState> get stateStream =>
      _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  //Bloc
  ControleAcaoMarcarBloc(this._firestore) {
    eventStream.listen(_mapEventToState);
  }

  void dispose() async {
    await _stateController.drain();
    _stateController.close();
    await _eventController.drain();
    _eventController.close();
  }

  _validateData() {
    if (_state.controleTarefaDestinatario != null) {
      _state.isDataValid = true;
    } else {
      _state.isDataValid = false;
    }
    if (_state.controleAcaoList != null) {
      _state.isDataValid = true;
    } else {
      _state.isDataValid = false;
    }
  }

  _mapEventToState(ControleAcaoMarcarBlocEvent event) async {
    if (event is UpdateTarefaIDEvent) {
      //Atualiza estado com usuario logado
      print('event.controleTarefaID:' + event.controleTarefaID);
      // le todas as tarefas deste usuario como remetente/designadas neste setor.
      final streamDocsTarefa = _firestore
          .collection(ControleTarefaModel.collection)
          .document(event.controleTarefaID)
          .snapshots();

      final snapTarefa = streamDocsTarefa.map((snapDocs) =>
          ControleTarefaModel(id: snapDocs.documentID).fromMap(snapDocs.data));
      //       .toList());

      snapTarefa.listen((ControleTarefaModel controleTarefa) {
        _state.controleTarefaDestinatario = controleTarefa;
        if (!_stateController.isClosed) _stateController.add(_state);
      });
      // final snap = await docRef.get();
      // if (snap.exists) {
      //   _state.controleTarefaDestinatario =
      //       ControleTarefaModel(id: snap.documentID).fromMap(snap.data);
      // }

      _state.controleAcaoList.clear();
      // le todas as tarefas deste usuario como remetente/designadas neste setor.
      final streamDocsRemetente = _firestore
          .collection(ControleAcaoModel.collection)
          .where("tarefa.id", isEqualTo: event.controleTarefaID)
          .snapshots();

      final snapListRemetente = streamDocsRemetente.map((snapDocs) => snapDocs
          .documents
          .map((doc) => ControleAcaoModel(id: doc.documentID).fromMap(doc.data))
          .toList());

      snapListRemetente.listen((List<ControleAcaoModel> controleAcaoList) {
        if (controleAcaoList.length > 1) {
          controleAcaoList
              .sort((a, b) => a.numeroCriacao.compareTo(b.numeroCriacao));
        }
        _state.controleAcaoList = controleAcaoList;
        if (!_stateController.isClosed) _stateController.add(_state);
      });
    }
    if (event is UpdateAcaoEvent) {
      final ref = _firestore
          .collection(ControleAcaoModel.collection)
          .document(event.controleAcaoID);
      await ref.setData({
        'concluida': !event.concluida,
        'modificada': Bootstrap.instance.FieldValue.serverTimestamp()
      }, merge: true);
      final ref2 = _firestore
          .collection(ControleTarefaModel.collection)
          .document(_state.controleTarefaDestinatario.id);
      if (!event.concluida) {
        await ref2.setData({
          'acaoCumprida': Bootstrap.instance.FieldValue.increment(1),
          'modificada': Bootstrap.instance.FieldValue.serverTimestamp()
        }, merge: true);
      } else {
        await ref2.setData({
          'acaoCumprida': Bootstrap.instance.FieldValue.increment(-1),
          'modificada': Bootstrap.instance.FieldValue.serverTimestamp()
        }, merge: true);
      }
      final ref3 = _firestore
          .collection(ControleTarefaModel.collection)
          .document(_state.controleTarefaDestinatario.id);
      final snap = await ref3.get();
      ControleTarefaModel controleTarefaModel =
          ControleTarefaModel(id: snap.documentID).fromMap(snap.data);
      if (controleTarefaModel.acaoCumprida == controleTarefaModel.acaoTotal) {
        await ref3.setData({
          'concluida': true,
          'modificada': Bootstrap.instance.FieldValue.serverTimestamp()
        }, merge: true);
      }
    }

    _validateData();
    print(_state.controleAcaoList.toString());
    if (!_stateController.isClosed) _stateController.add(_state);
    print(
        'event.runtimeType em ControleTarefaDestinatarioAcaoMarcarBloc  = ${event.runtimeType}');
  }
}
