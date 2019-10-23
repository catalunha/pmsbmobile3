import 'dart:async';

import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:pmsbmibile3/models/models.dart';
import 'package:pmsbmibile3/services/gerador_md_service.dart';
import 'package:rxdart/rxdart.dart';

class PerguntaListPreviewPageEvent {}

class UpdateQuestionarioIDEvent extends PerguntaListPreviewPageEvent {
  final String questionarioId;
  UpdateQuestionarioIDEvent({this.questionarioId});
}

class PerguntaListPreviewPageState {
  QuestionarioModel questionarioInstance;
  String questionarioPerguntaList2Mkd;
}

class PerguntaListPreviewBloc {
  //Firestore
  final fsw.Firestore _firestore;

  //Eventos
  final _eventController = BehaviorSubject<PerguntaListPreviewPageEvent>();
  Stream<PerguntaListPreviewPageEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final PerguntaListPreviewPageState _state = PerguntaListPreviewPageState();
  final _stateController = BehaviorSubject<PerguntaListPreviewPageState>();
  Stream<PerguntaListPreviewPageState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  //Bloc
  PerguntaListPreviewBloc(this._firestore) {
    eventStream.listen(_mapEventToState);
  }
  void dispose() async {
    await _stateController.drain();
    _stateController.close();
    await _eventController.drain();
    _eventController.close();
  }

  _mapEventToState(PerguntaListPreviewPageEvent event) async {
    if (event is UpdateQuestionarioIDEvent) {
      final ref = _firestore
          .collection(QuestionarioModel.collection)
          .document(event.questionarioId);
      await ref.get().then((data) {
        _state.questionarioInstance =
            QuestionarioModel(id: data.documentID).fromMap(data.data);
      });

      _state.questionarioPerguntaList2Mkd = await GeradorMdService.generateMdFromQuestionarioModel(_state.questionarioInstance);

    }

    if (!_stateController.isClosed) _stateController.add(_state);

    print('event.runtimeType em PerguntaPreviewBloc  = ${event.runtimeType}');
  }
}
