import 'dart:async';
import 'package:pmsbmibile3/models/questionario_model.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

class PerguntaHomePageBlocEvent {}

class UpdateQuestionarioIdPerguntaHomePageBlocEvent
    extends PerguntaHomePageBlocEvent {
  final String questionarioId;

  UpdateQuestionarioIdPerguntaHomePageBlocEvent(this.questionarioId);
}

class PerguntaHomePageBlocState {
  QuestionarioModel questionarioInstance;
}

class PerguntaHomePageBloc {
  PerguntaHomePageBloc(this._firestore) {
    _inputController.listen(_handleInput);
  }

  final fsw.Firestore _firestore;

  final _state = PerguntaHomePageBlocState();

  final _inputController = BehaviorSubject<PerguntaHomePageBlocEvent>();

  Function get dispatch => _inputController.add;

  final _outputController = BehaviorSubject<PerguntaHomePageBlocState>();

  Stream<PerguntaHomePageBlocState> get state => _outputController.stream;

  final _perguntasController = BehaviorSubject<List<PerguntaModel>>();
  StreamSubscription<List<PerguntaModel>> _perguntaSubscription;

  Stream<List<PerguntaModel>> get perguntas => _perguntasController.stream;

  void dispose() {
    _inputController.close();
    _outputController.close();
    _perguntasController.close();
  }

  void _handleInput(PerguntaHomePageBlocEvent event) async {
    if (event is UpdateQuestionarioIdPerguntaHomePageBlocEvent) {
      final ref = _firestore
          .collection(QuestionarioModel.collection)
          .document(event.questionarioId);
      await ref.get().then((data) {
        _state.questionarioInstance =
            QuestionarioModel(id: data.documentID).fromMap(data.data);
      });

      final perguntasRef = _firestore
          .collection(PerguntaModel.collection)
          .where("questionario.id", isEqualTo: event.questionarioId);
      final perguntasStream = perguntasRef.snapshots().map((snp) {
        return snp.documents.map((doc) {
          return PerguntaModel(id: doc.documentID).fromMap(doc.data);
        }).toList();
      });
      await _perguntaSubscription?.cancel();
      _perguntaSubscription = perguntasStream.listen((data){
        _perguntasController.add(data);
      });
    }
    _outputController.add(_state);
  }
}
