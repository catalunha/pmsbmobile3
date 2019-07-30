import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class PerguntaEscolhaCRUDPageEvent {}

class UpdatePerguntaIDPageEvent extends PerguntaEscolhaCRUDPageEvent {
  final String perguntaID;

  UpdatePerguntaIDPageEvent(this.perguntaID);
}

class UpdateEscolhaIDPageEvent extends PerguntaEscolhaCRUDPageEvent {
  final String escolhaUID;

  UpdateEscolhaIDPageEvent(this.escolhaUID);
}

class UpdateTextoEvent extends PerguntaEscolhaCRUDPageEvent {
  final String texto;

  UpdateTextoEvent(this.texto);
}

class SaveEvent extends PerguntaEscolhaCRUDPageEvent {}

class DeleteEvent extends PerguntaEscolhaCRUDPageEvent {}

class PerguntaEscolhaCRUDPageState {
  String perguntaID;
  String escolhaUID;

  Escolha escolha;
  int ultimaOrdemEscolha;
  String texto;

  void updateStateFromEscolhaModel() {
    texto = escolha.texto;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "${perguntaID} | ${escolhaUID}";
  }
}

class PerguntaEscolhaCRUDPageBloc {
  //Firestore
  final fw.Firestore _firestore;

  //Eventos
  final _eventController = BehaviorSubject<PerguntaEscolhaCRUDPageEvent>();
  Stream<PerguntaEscolhaCRUDPageEvent> get eventStream =>
      _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final PerguntaEscolhaCRUDPageState _state = PerguntaEscolhaCRUDPageState();
  final _stateController = BehaviorSubject<PerguntaEscolhaCRUDPageState>();
  Stream<PerguntaEscolhaCRUDPageState> get stateStream =>
      _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  //Bloc
  PerguntaEscolhaCRUDPageBloc(this._firestore) {
    eventStream.listen(_mapEventToState);
  }
  void dispose() {
    _stateController.close();
    _eventController.close();
  }

  _mapEventToState(PerguntaEscolhaCRUDPageEvent event) async {
    if (event is UpdatePerguntaIDPageEvent) {
      _state.perguntaID = event.perguntaID;
    }

    if (event is UpdateEscolhaIDPageEvent) {
      _state.escolhaUID = event.escolhaUID;
      final docRef = _firestore
          .collection(PerguntaModel.collection)
          .document(_state.perguntaID);
      final docSnap = await docRef.get();
      PerguntaModel perguntaModel;
      if (docSnap.exists) {
        perguntaModel =
            PerguntaModel(id: docSnap.documentID).fromMap(docSnap.data);
      }
        _state.ultimaOrdemEscolha = perguntaModel.ultimaOrdemEscolha;
      if (event.escolhaUID != null) {
         // print('>>> perguntaModel <<< ${perguntaModel.toMap()}');
        perguntaModel.escolhas.forEach((k, v) {
          if (k == _state.escolhaUID) {
            _state.escolha = v;
          }
        });
        _state.updateStateFromEscolhaModel();
      }
    }
    if (event is UpdateTextoEvent) {
      _state.texto = event.texto;
    }
    if (event is SaveEvent) {
      Escolha escolha;
      if (_state.escolhaUID == null) {
        _state.ultimaOrdemEscolha = 1;
        escolha = Escolha(
          key: true,
          marcada: false,
          ordem: _state.ultimaOrdemEscolha,
          texto: _state.texto,
        );
      } else {
        escolha = Escolha(
          texto: _state.texto,
        );
      }
      if (_state.escolhaUID == null) {
        final uuid = Uuid();
        _state.escolhaUID = uuid.v4();
      }
      final docRef = _firestore
          .collection(PerguntaModel.collection)
          .document(_state.perguntaID);
      await docRef.setData({
        "escolhas": {_state.escolhaUID: escolha.toMap()},
        "ultimaOrdemEscolha": _state.ultimaOrdemEscolha
      }, merge: true);
    }
    if (event is DeleteEvent) {
      final docRef = _firestore
          .collection(PerguntaModel.collection)
          .document(_state.perguntaID);
      docRef.setData({
        "escolhas": {_state.escolhaUID: Bootstrap.instance.FieldValue.delete()},
      }, merge: true);
    }
    if (!_stateController.isClosed) stateSink(_state);
    print('ccc PerguntaEscolhaCRUDPageBloc ${event.runtimeType}');
    print('>>> _state.texto <<< ${_state.texto}');
    print('>>> _state.toString <<< ${_state.toString()}');
  }
}
