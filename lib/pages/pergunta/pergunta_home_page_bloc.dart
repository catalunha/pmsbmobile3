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

class OrdemPerguntaPerguntaHomePageBlocEvent extends PerguntaHomePageBlocEvent {
  final String perguntaID;
  final bool up;

  OrdemPerguntaPerguntaHomePageBlocEvent(
    this.perguntaID,
    this.up,
  );
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
          .where("questionario.id", isEqualTo: event.questionarioId)
          .orderBy("ordem", descending: false);
      final perguntasStream = perguntasRef.snapshots().map((snp) {
        return snp.documents.map((doc) {
          return PerguntaModel(id: doc.documentID).fromMap(doc.data);
        }).toList();
      });
      await _perguntaSubscription?.cancel();
      _perguntaSubscription = perguntasStream.listen((data) {
        _perguntasController.add(data);
      });
    }

    if (event is OrdemPerguntaPerguntaHomePageBlocEvent) {

      final _perguntasRef = _firestore.collection(PerguntaModel.collection);
      final perguntaRef = _perguntasRef.document(event.perguntaID);
      final perguntaSnap = await perguntaRef.get();
      final pergunta =
          PerguntaModel(id: perguntaSnap.documentID).fromMap(perguntaSnap.data);

      final perguntaUpRef = _perguntasRef.document(pergunta.anterior);
      final perguntaUpSnap = await perguntaUpRef.get();
      final perguntaUp = PerguntaModel(id: perguntaUpSnap.documentID)
          .fromMap(perguntaUpSnap.data);

      final perguntaDownRef = _perguntasRef.document(pergunta.posterior);
      final perguntaDownSnap = await perguntaDownRef.get();
      final perguntaDown = PerguntaModel(id: perguntaDownSnap.documentID)
          .fromMap(perguntaDownSnap.data);

      int perguntaOrdem;
      String perguntaAnterior;
      String perguntaPosterior;
      int perguntaUpOrdem;
      String perguntaUpAnterior;
      String perguntaUpPosterior;
      int perguntaDownOrdem;
      String perguntaDownAnterior;
      String perguntaDownPosterior;

      if (event.up) {
        perguntaOrdem = perguntaUp.ordem;
        perguntaUpOrdem = pergunta.ordem;
        perguntaDownOrdem = perguntaDown.ordem;

        perguntaAnterior = perguntaUp.anterior;
        perguntaPosterior = pergunta.anterior;

        perguntaUpAnterior = perguntaDown.anterior;
        perguntaUpPosterior = pergunta.posterior;

        perguntaDownAnterior = pergunta.anterior;
        perguntaDownPosterior = perguntaDown.posterior;
      } else {
        perguntaOrdem = perguntaDown.ordem;
        perguntaDownOrdem = pergunta.ordem;
        perguntaUpOrdem = perguntaUp.ordem;

        perguntaAnterior = pergunta.posterior;
        perguntaPosterior = perguntaDown.posterior;

        perguntaUpPosterior = pergunta.posterior;
        perguntaUpAnterior = perguntaUp.anterior;

        perguntaDownAnterior = pergunta.anterior;
        perguntaDownPosterior = perguntaUp.posterior;
      }

      perguntaRef.setData({
        "ordem": perguntaOrdem,
        "anterior": perguntaAnterior,
        "posterior": perguntaPosterior,
      }, merge: true);

      perguntaUpRef.setData({
        "ordem": perguntaUpOrdem,
        "anterior": perguntaUpAnterior,
        "posterior": perguntaUpPosterior,
      }, merge: true);

      perguntaDownRef.setData({
        "ordem": perguntaDownOrdem,
        "anterior": perguntaDownAnterior,
        "posterior": perguntaDownPosterior,
      }, merge: true);
    }

    _outputController.add(_state);
  }
}
