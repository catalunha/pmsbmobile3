import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/controle_acao_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;

class ControleAcaoInformarBlocEvent {}


class UpdateAcaoIDEvent extends ControleAcaoInformarBlocEvent {
  final String acaoID;

  UpdateAcaoIDEvent(this.acaoID);
}

class UpdateUrlEvent extends ControleAcaoInformarBlocEvent {
  final String url;

  UpdateUrlEvent(this.url);
}

class UpdateObsEvent extends ControleAcaoInformarBlocEvent {
  final String obs;

  UpdateObsEvent(this.obs);
}


class SaveAcaoEvent extends ControleAcaoInformarBlocEvent {}

class ControleAcaoInformarBlocState {
  ControleAcaoModel controleAcaoID;
  String url;
  String obs;

    void updateStateFromControleAcaoModel() {
    url = controleAcaoID.url;
    obs = controleAcaoID.observacao;

  }
}

class ControleAcaoInformarBloc {
  /// Firestore
  final fw.Firestore _firestore;

  /// Eventos
  final _eventController = BehaviorSubject<ControleAcaoInformarBlocEvent>();
  Stream<ControleAcaoInformarBlocEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  /// Estados
  final ControleAcaoInformarBlocState _state = ControleAcaoInformarBlocState();
  final _stateController = BehaviorSubject<ControleAcaoInformarBlocState>();
  Stream<ControleAcaoInformarBlocState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  /// Bloc
  ControleAcaoInformarBloc(this._firestore) {
    eventStream.listen(_mapEventToState);
  }

  void dispose() async {
    await _stateController.drain();
    _stateController.close();
    await _eventController.drain();
    _eventController.close();
  }

  _mapEventToState(ControleAcaoInformarBlocEvent event) async {

    if (event is UpdateAcaoIDEvent) {
      if (event.acaoID != null) {
        final docRef = _firestore
            .collection(ControleAcaoModel.collection)
            .document(event.acaoID);

        final snap = await docRef.get();
        if (snap.exists) {
          _state.controleAcaoID =
              ControleAcaoModel(id: snap.documentID).fromMap(snap.data);
_state.updateStateFromControleAcaoModel();
        }
      }
    }

    if (event is UpdateUrlEvent) {
      _state.url = event.url;
    }
    if (event is UpdateObsEvent) {
      _state.obs = event.obs;
    }

    if (event is SaveAcaoEvent) {

        final docRef = _firestore
            .collection(ControleAcaoModel.collection)
            .document(_state.controleAcaoID.id);
        
        await docRef.setData({'url': _state.url,'observacao': _state.obs,'modificada':Bootstrap.instance.fieldValue.serverTimestamp()}, merge: true);

    }
    if (!_stateController.isClosed) _stateController.add(_state);
    print('event.runtimeType em ControleAcaoInformarBloc  = ${event.runtimeType}');
  }
}
