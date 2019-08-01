import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;
import 'package:pmsbmibile3/models/models.dart';
import 'package:rxdart/rxdart.dart';

class PerguntaRequisitoEscolhaMarcarPageEvent {}

class UpdatePerguntaIDEvent extends PerguntaRequisitoEscolhaMarcarPageEvent {
  final String perguntaID;
  UpdatePerguntaIDEvent({this.perguntaID});
}

class UpdateReqEscolhaEvent extends PerguntaRequisitoEscolhaMarcarPageEvent {
  final String requisitoUid;
  final bool marcado;

  UpdateReqEscolhaEvent({this.requisitoUid, this.marcado});
}

class SaveEvent extends PerguntaRequisitoEscolhaMarcarPageEvent {}

class PerguntaRequisitoEscolhaMarcarPageState {
  String perguntaID;

  PerguntaModel perguntaModel;
  // Map requisitoEscolha = Map<String, Map<String, dynamic>>();
  Map<String, Requisito> requisitos;
  Map<String, Requisito> requisitoEscolha = Map<String, Requisito>();

  void updateStateFromPerguntaModel() {
    requisitos = perguntaModel.requisitos;
    requisitos.forEach((k, v) {
      if (v.escolha != null) {
        requisitoEscolha[k] = v;
      }
    });
    print(requisitos);
    print(requisitoEscolha);
  }
}

class PerguntaRequisitoEscolhaMarcarBloc {
  //Firestore
  final fw.Firestore _firestore;

  //Eventos
  final _eventController =
      BehaviorSubject<PerguntaRequisitoEscolhaMarcarPageEvent>();
  Stream<PerguntaRequisitoEscolhaMarcarPageEvent> get eventStream =>
      _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final PerguntaRequisitoEscolhaMarcarPageState _state =
      PerguntaRequisitoEscolhaMarcarPageState();
  final _stateController =
      BehaviorSubject<PerguntaRequisitoEscolhaMarcarPageState>();
  Stream<PerguntaRequisitoEscolhaMarcarPageState> get stateStream =>
      _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  //Bloc
  PerguntaRequisitoEscolhaMarcarBloc(this._firestore) {
    eventStream.listen(_mapEventToState);
  }
  void dispose() {
    _stateController.close();
    _eventController.close();
  }

  _mapEventToState(PerguntaRequisitoEscolhaMarcarPageEvent event) async {
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
    if (event is UpdateReqEscolhaEvent) {
      var reqEscolha = _state.requisitoEscolha[event.requisitoUid];
      reqEscolha.escolha.marcada = event.marcado;
      _state.requisitoEscolha[event.requisitoUid] = reqEscolha;
    }
    if (event is SaveEvent) {
      final docRef = _firestore
          .collection(PerguntaModel.collection)
          .document(_state.perguntaID);
      _state.requisitoEscolha.forEach((k, v) {
        docRef.setData({"requisitos":{k:v.toMap()}}, merge: true);
      });
    }

    if (!_stateController.isClosed) _stateController.add(_state);
    // print('>>> _state.toMap() <<< ${_state.toMap()}');
    print(
        '>>> ProdutoArquivoCRUDPageBloc event.runtimeType <<< ${event.runtimeType}');
  }
}
