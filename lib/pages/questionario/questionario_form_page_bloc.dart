import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pmsbmibile3/models/questionario_model.dart';

class QuestionarioFormPageBlocEvent {}

class UpdateNomeQuestionarioFormPageBlocEvent
    extends QuestionarioFormPageBlocEvent {
  final String nome;

  UpdateNomeQuestionarioFormPageBlocEvent(this.nome);
}

class UpdateIdQuestionarioFormPageBlocEvent
    extends QuestionarioFormPageBlocEvent {
  final String id;

  UpdateIdQuestionarioFormPageBlocEvent(this.id);
}

class UpdateUserIdQuestionarioFormPageBlocEvent
    extends QuestionarioFormPageBlocEvent {
  final String userId;

  UpdateUserIdQuestionarioFormPageBlocEvent(this.userId);
}

class SaveQuestionarioFormPageBlocEvent extends QuestionarioFormPageBlocEvent {}

class QuestionarioFormPageBlocState {
  String id;
  String nome;
  String userId;
  String userName;
}

class QuestionarioFormPageBloc {
  final _state = QuestionarioFormPageBlocState();
  final fsw.Firestore _firestore;

  final _inputController = BehaviorSubject<QuestionarioFormPageBlocEvent>();
  final _outputController = BehaviorSubject<QuestionarioFormPageBlocState>();
  final _instanceOutputController = BehaviorSubject<QuestionarioModel>();

  Stream<QuestionarioModel> get instance => _instanceOutputController.stream;

  Function get dispatch => _inputController.add;

  QuestionarioFormPageBloc(this._firestore) {
    _inputController.listen(_handleInput);
  }

  void dispose() {
    _inputController.close();
    _outputController.close();
    _instanceOutputController.close();
  }

  void _handleInput(QuestionarioFormPageBlocEvent event) {
    if (event is UpdateNomeQuestionarioFormPageBlocEvent) {
      _state.nome = event.nome;
    }
    if (event is UpdateUserIdQuestionarioFormPageBlocEvent) {
      _state.userId = event.userId;
      final userRef = _firestore
          .collection(UsuarioModel.collection)
          .document(_state.userId);
      userRef.get().then((usuarioSnap) {
        print(usuarioSnap.data);
        final usuario =
            UsuarioModel(id: usuarioSnap.documentID).fromMap(usuarioSnap.data);
        print(usuario.nomeProjeto);
        _state.userName = usuario.nomeProjeto;
      });
    }
    if (event is UpdateIdQuestionarioFormPageBlocEvent) {
      _state.id = event.id;
      final colRef = _firestore.collection(QuestionarioModel.collection);
      final docRef = colRef.document(_state.id);
      docRef.get().then((docSnap) {
        final modelInstance =
            QuestionarioModel(id: docSnap.documentID).fromMap(docSnap.data);
        _instanceOutputController.add(modelInstance);
      });
    }

    if (event is SaveQuestionarioFormPageBlocEvent) {
      final colRef = _firestore.collection(QuestionarioModel.collection);
      final docRef = colRef.document(_state.id);
      final modelInstance = QuestionarioModel(
        id: _state.id,
        nome: _state.nome,
        userId: _state.userId,
        usuarioNomeProjeto: _state.userName,
      );
      print(modelInstance.toMap());
      docRef.setData(modelInstance.toMap(), merge: true);
    }
  }
}
