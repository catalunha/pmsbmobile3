import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;
import 'package:pmsbmibile3/models/models.dart';
import 'package:rxdart/rxdart.dart';

class PerguntaPreviewPageEvent {}

class UpdatePerguntaIDEvent extends PerguntaPreviewPageEvent {
  final String perguntaID;
  UpdatePerguntaIDEvent({this.perguntaID});
}

class PerguntaPreviewPageState {
  String perguntaID;

  PerguntaModel perguntaModel;

  Map<String, Requisito> requisitos;
  Map<String, Escolha> escolhas;

  void updateStateFromPerguntaModel() {
    requisitos = perguntaModel.requisitos;
    escolhas = perguntaModel.escolhas;
  }
}

class PerguntaPreviewBloc {
  //Firestore
  final fw.Firestore _firestore;

  //Eventos
  final _eventController = BehaviorSubject<PerguntaPreviewPageEvent>();
  Stream<PerguntaPreviewPageEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final PerguntaPreviewPageState _state = PerguntaPreviewPageState();
  final _stateController = BehaviorSubject<PerguntaPreviewPageState>();
  Stream<PerguntaPreviewPageState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  //Bloc
  PerguntaPreviewBloc(this._firestore) {
    eventStream.listen(_mapEventToState);
  }
  void dispose() {
    _stateController.close();
    _eventController.close();
  }

  _mapEventToState(PerguntaPreviewPageEvent event) async {
    if (event is UpdatePerguntaIDEvent) {
      _state.perguntaID = event.perguntaID;

      final docRef = _firestore
          .collection(PerguntaModel.collection)
          .document(_state.perguntaID);

      final docSnap = await docRef.get();

      if (docSnap.exists) {
        final perguntaModel =
            PerguntaModel(id: docSnap.documentID).fromMap(docSnap.data);
        _state.perguntaModel = perguntaModel;
        _state.updateStateFromPerguntaModel();
      }
    }
    // if (event is UpdatePerguntaIDEvent) {}
    if (!_stateController.isClosed) _stateController.add(_state);
    // print('>>> _state.toMap() <<< ${_state.toMap()}');
    print(
        '>>> PerguntaPreviewBloc event.runtimeType <<< ${event.runtimeType}');
  }
}
