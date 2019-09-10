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

class UpdatePerguntaListPerguntaHomePageBlocEvent
    extends PerguntaHomePageBlocEvent {
  final List<PerguntaModel> perguntas;

  UpdatePerguntaListPerguntaHomePageBlocEvent(this.perguntas);
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
  List<PerguntaModel> perguntas;
  Map<String, bool> ups = Map<String, bool>();
  Map<String, bool> downs = Map<String, bool>();
  Map<String, int> indexMap = Map<String, int>();
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

  StreamSubscription<List<PerguntaModel>> _perguntaSubscription;

  void dispose() async {
    await _inputController.drain();
    _inputController.close();
    await _outputController.drain();
    _outputController.close();
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
        dispatch(UpdatePerguntaListPerguntaHomePageBlocEvent(data));
      });
    }

    if (event is UpdatePerguntaListPerguntaHomePageBlocEvent) {
      _state.perguntas = event.perguntas;
      event.perguntas.asMap().forEach((index, pergunta) {
        _state.indexMap[pergunta.id] = index;
        _state.ups[pergunta.id] = index > 0;
        _state.downs[pergunta.id] = index + 1 < event.perguntas.length;
      });
    }

    if (event is OrdemPerguntaPerguntaHomePageBlocEvent) {
      final index = _state.indexMap[event.perguntaID];
      final outroIndex = event.up ? index - 1 : index + 1;

      final perguntaBID = _state.perguntas[outroIndex].id;

      final ordemA = _state.perguntas[index].ordem;
      final ordemB = _state.perguntas[outroIndex].ordem;

      final perguntasRef = _firestore.collection(PerguntaModel.collection);
      final perguntaARef = perguntasRef.document(event.perguntaID);
      final perguntaBRef = perguntasRef.document(perguntaBID);
      perguntaARef.setData({"ordem": ordemB}, merge: true);
      perguntaBRef.setData({"ordem": ordemA}, merge: true);
    }
    _outputController.add(_state);
  }
}
