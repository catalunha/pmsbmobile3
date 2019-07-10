import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:rxdart/rxdart.dart';
import 'package:pmsbmibile3/models/questionario_model.dart';
import 'package:pmsbmibile3/bootstrap.dart' as fsw;

class QuestionarioHomePageEvent {}

class DeleteQuestionarioHomePageEvent extends QuestionarioHomePageEvent {
  final String questionarioId;

  DeleteQuestionarioHomePageEvent(this.questionarioId);
}

class UpdateUserIdQuestionarioHomePageBlocEvent extends QuestionarioHomePageEvent{
  final String userId;
  UpdateUserIdQuestionarioHomePageBlocEvent(this.userId);
}

class QuestionarioHomePageBlocState{
  String userId;
}

class QuestionarioHomePageBloc {
  final _state = QuestionarioHomePageBlocState();
  final fsw.Firestore _firestore;

  final _inputController = BehaviorSubject<QuestionarioHomePageEvent>();

  Function get dispatch => _inputController.add;

  final _questionariosController = BehaviorSubject<List<QuestionarioModel>>();

  Stream<List<QuestionarioModel>> get questionarios =>
      _questionariosController.stream;

  void dispose() {
    _inputController.close();
    _questionariosController.close();
  }

  QuestionarioHomePageBloc(this._firestore) {}

  void _handleInput(QuestionarioHomePageEvent event) {
    if(event is UpdateUserIdQuestionarioHomePageBlocEvent){
      _state.userId = event.userId;
      //TODO: adiciona logica de filtragem por eixo mostrando somente questionarios de somente do eixoAtual do usuario
      final ref = _firestore.collection(QuestionarioModel.collection);
      final snap = ref.snapshots();
      final snapList = snap.map((q) => q.documents
          .map((d) => QuestionarioModel(id: d.documentID).fromMap(d.data))
          .toList());
      snapList.pipe(_questionariosController);
      _inputController.listen(_handleInput);
    }
    if (event is DeleteQuestionarioHomePageEvent) {
      _firestore
          .collection(QuestionarioModel.collection)
          .document(event.questionarioId)
          .delete();
    }
  }
}
