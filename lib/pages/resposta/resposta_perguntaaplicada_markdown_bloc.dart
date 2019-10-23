import 'dart:async';

import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:pmsbmibile3/models/models.dart';
import 'package:pmsbmibile3/services/gerador_md_service.dart';
import 'package:rxdart/rxdart.dart';

class RespostaPerguntaAplicadaMarkdownEvent {}

class UpdateQuestionarioIDEvent extends RespostaPerguntaAplicadaMarkdownEvent {
  final String questionarioId;
  UpdateQuestionarioIDEvent({this.questionarioId});
}

class RespostaPerguntaAplicadaMarkdownState {
  QuestionarioModel questionarioInstance;
  String questionarioPerguntaList2Mkd;
}

class RespostaPerguntaAplicadaMarkdownBloc {
  // Firestore
  final fsw.Firestore _firestore;

  // Eventos
  final _eventController =
      BehaviorSubject<RespostaPerguntaAplicadaMarkdownEvent>();
  Stream<RespostaPerguntaAplicadaMarkdownEvent> get eventStream =>
      _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  // Estados
  final RespostaPerguntaAplicadaMarkdownState _state =
      RespostaPerguntaAplicadaMarkdownState();
  final _stateController =
      BehaviorSubject<RespostaPerguntaAplicadaMarkdownState>();
  Stream<RespostaPerguntaAplicadaMarkdownState> get stateStream =>
      _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  // Bloc
  RespostaPerguntaAplicadaMarkdownBloc(this._firestore) {
    eventStream.listen(_mapEventToState);
  }
  void dispose() async {
    await _stateController.drain();
    _stateController.close();
    await _eventController.drain();
    _eventController.close();
  }

  _mapEventToState(RespostaPerguntaAplicadaMarkdownEvent event) async {
    if (event is UpdateQuestionarioIDEvent) {
      final ref = _firestore
          .collection(QuestionarioAplicadoModel.collection)
          .document(event.questionarioId);
      await ref.get().then((data) {
        _state.questionarioInstance =
            QuestionarioAplicadoModel(id: data.documentID).fromMap(data.data);
      });

      _state.questionarioPerguntaList2Mkd =
          await GeradorMdService.generateMdFromQuestionarioAplicadoModel(
              _state.questionarioInstance);
    }

    if (!_stateController.isClosed) _stateController.add(_state);
    print('event.runtimeType em PerguntaPreviewBloc  = ${event.runtimeType}');
  }
}
