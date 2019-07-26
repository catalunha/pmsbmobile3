import 'package:pmsbmibile3/models/questionario_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

class AplicacaoHomePageBlocState {
  String usuarioID;
  List<QuestionarioAplicadoModel> questionariosAplicados;
}

class AplicacaoHomePageBlocEvent {}

class UpdateUserIDEvent extends AplicacaoHomePageBlocEvent {
  final String usuarioID;

  UpdateUserIDEvent(this.usuarioID);
}

class UpdateQuesionarioAplicadoListEvent extends AplicacaoHomePageBlocEvent {}

class AplicacaoHomePageBloc {
  final fsw.Firestore _firestore;
  final fsw.CollectionReference _reference;
  final _state = AplicacaoHomePageBlocState();

  final _inputController = BehaviorSubject<AplicacaoHomePageBlocEvent>();

  Function get dispatch => _inputController.add;

  final _outputController = BehaviorSubject<AplicacaoHomePageBlocState>();

  Stream<AplicacaoHomePageBlocState> get state => _outputController.stream;

  AplicacaoHomePageBloc(this._firestore)
      : _reference =
            _firestore.collection(QuestionarioAplicadoModel.collection) {
    _inputController.listen(_HandleInput);
  }

  void dispose() {
    _inputController?.close();
    _outputController?.close();
  }

  void _HandleInput(AplicacaoHomePageBlocEvent event) async {
    if (event is UpdateUserIDEvent) {
      _state.usuarioID = event.usuarioID;
      dispatch(UpdateQuesionarioAplicadoListEvent());
    }
    if (event is UpdateQuesionarioAplicadoListEvent) {
      final querySnapshot =
          await _reference.where("aplicador.id", isEqualTo: _state.usuarioID).getDocuments();
      _state.questionariosAplicados = querySnapshot.documents
          .map((doc) =>
              QuestionarioAplicadoModel(id: doc.documentID).fromMap(doc.data))
          .toList();
    }

    _outputController.add(_state);
    print(event.runtimeType);
  }
}
