import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:rxdart/rxdart.dart';
import 'package:pmsbmibile3/models/questionario_model.dart';
import 'package:pmsbmibile3/bootstrap.dart' as fsw;
import 'dart:async';

class QuestionarioHomePageEvent {}

class UpdateUserInfoQuestionarioHomePageBlocEvent
    extends QuestionarioHomePageEvent {
  final String userId;
  final String eixoAtualID;

  UpdateUserInfoQuestionarioHomePageBlocEvent(this.userId, this.eixoAtualID);
}

class QuestionarioHomePageBlocState {
  String userId;
  String eixoAtualID;
}

class QuestionarioHomePageBloc {
  final _state = QuestionarioHomePageBlocState();
  final fsw.Firestore _firestore;
  final _authBloc;

  final _inputController = BehaviorSubject<QuestionarioHomePageEvent>();

  Function get dispatch => _inputController.add;

  final _questionariosController = BehaviorSubject<List<QuestionarioModel>>();

  Stream<List<QuestionarioModel>> get questionarios =>
      _questionariosController.stream;

  StreamSubscription<List<QuestionarioModel>> _questionarioSubscription;

  void dispose() {
    _inputController?.close();
    _questionariosController?.close();
    _questionarioSubscription?.cancel();
  }

  QuestionarioHomePageBloc(this._firestore, this._authBloc) {
    _inputController.listen(_handleInput);
    _authBloc.perfil.listen((user) {
      dispatch(UpdateUserInfoQuestionarioHomePageBlocEvent(
        user.id,
        user.eixoIDAtual.id,
      ));
    });
  }

  void _handleInput(QuestionarioHomePageEvent event) async {
    if (event is UpdateUserInfoQuestionarioHomePageBlocEvent) {
      _state.userId = event.userId;
      _state.eixoAtualID = event.eixoAtualID;

      final ref = _firestore
          .collection(QuestionarioModel.collection)
          .where("eixo.id", isEqualTo: _state.eixoAtualID);
      final snap = ref.snapshots();
      final snapList = snap.map((q) => q.documents
          .map((d) => QuestionarioModel(id: d.documentID).fromMap(d.data))
          .toList());
      if (_questionarioSubscription != null) {
        await _questionarioSubscription.cancel();
      }
      _questionarioSubscription =
          snapList.listen((data) => _questionariosController.add(data));
    }
  }
}
