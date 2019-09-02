import 'dart:async';

import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:pmsbmibile3/models/models.dart';
import 'package:pmsbmibile3/services/gerador_md_service.dart';
import 'package:rxdart/rxdart.dart';

class RespostaPerguntaAplicadaEvent {}

class UpdateQuestionarioIDEvent extends RespostaPerguntaAplicadaEvent {
  final String questionarioId;
  UpdateQuestionarioIDEvent({this.questionarioId});
}

// class UpdatePerguntaListPerguntaHomePageBlocEvent
//     extends RespostaPerguntaAplicadaEvent {
//   final List<PerguntaModel> perguntas;

//   UpdatePerguntaListPerguntaHomePageBlocEvent(this.perguntas);
// }
class RespostaPerguntaAplicadaState {
  QuestionarioModel questionarioInstance;
  String questionarioPerguntaList2Mkd;

  // List<PerguntaModel> perguntas;

  // Map<String, bool> ups = Map<String, bool>();
  // Map<String, bool> downs = Map<String, bool>();
  // Map<String, int> indexMap = Map<String, int>();


  // String questionarioId;

  // PerguntaModel perguntaModel;


  // Map<String, Requisito> requisitos;
  // Map<String, Escolha> escolhas;

  // void updateStateFromPerguntaModel() {
  //   requisitos = perguntaModel.requisitos;
  //   escolhas = perguntaModel.escolhas;
  // }
}

class RespostaPerguntaAplicadaBloc {
  //Firestore
  final fsw.Firestore _firestore;

  //Eventos
  final _eventController = BehaviorSubject<RespostaPerguntaAplicadaEvent>();
  Stream<RespostaPerguntaAplicadaEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final RespostaPerguntaAplicadaState _state = RespostaPerguntaAplicadaState();
  final _stateController = BehaviorSubject<RespostaPerguntaAplicadaState>();
  Stream<RespostaPerguntaAplicadaState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;


  // StreamSubscription<List<PerguntaModel>> _perguntaSubscription;

  //Bloc
  RespostaPerguntaAplicadaBloc(this._firestore) {
    eventStream.listen(_mapEventToState);
  }
  void dispose() async {
    await _stateController.drain();
    _stateController.close();
    await _eventController.drain();
    _eventController.close();
  }

  _mapEventToState(RespostaPerguntaAplicadaEvent event) async {
    if (event is UpdateQuestionarioIDEvent) {
      final ref = _firestore
          .collection(QuestionarioModel.collection)
          .document(event.questionarioId);
      await ref.get().then((data) {
        _state.questionarioInstance =
            QuestionarioModel(id: data.documentID).fromMap(data.data);
      });

      _state.questionarioPerguntaList2Mkd = await GeradorMdService.generateMdFromQuestionarioModel(_state.questionarioInstance);

      // final perguntasRef = _firestore
      //     .collection(PerguntaModel.collection)
      //     .where("questionario.id", isEqualTo: event.questionarioId)
      //     .orderBy("ordem", descending: false);
      // final perguntasStream = perguntasRef.snapshots().map((snp) {
      //   return snp.documents.map((doc) {
      //     return PerguntaModel(id: doc.documentID).fromMap(doc.data);
      //   }).toList();
      // });
      // await _perguntaSubscription?.cancel();
      // _perguntaSubscription = perguntasStream.listen((data) {
      //   eventSink(UpdatePerguntaListPerguntaHomePageBlocEvent(data));
      // });
    }

    // if (event is UpdatePerguntaListPerguntaHomePageBlocEvent) {
    //   _state.perguntas = event.perguntas;
    //   event.perguntas.asMap().forEach((index, pergunta) {
    //     _state.indexMap[pergunta.id] = index;
    //     _state.ups[pergunta.id] = index > 0;
    //     _state.downs[pergunta.id] = index + 1 < event.perguntas.length;
    //   });
    // }
    // if (event is UpdateQuestionarioIDEvent) {}
    if (!_stateController.isClosed) _stateController.add(_state);
    // print('>>> _state.toMap() <<< ${_state.toMap()}');

    print('event.runtimeType em PerguntaPreviewBloc  = ${event.runtimeType}');
  }
}
