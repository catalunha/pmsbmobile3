import 'package:pmsbmibile3/models/questionario_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

class AplicacaoHomePageBlocState {
  String usuarioID;
  List<QuestionarioAplicadoModel> questionariosAplicados;
  String usuarioEixoID;
}

class AplicacaoHomePageBlocEvent {}

class QueryQuestionariosAplicadoListAplicacaoHomePageBlocEvent
    extends AplicacaoHomePageBlocEvent {}

class UpdateUserIDAplicacaoHomePageBlocEvent
    extends AplicacaoHomePageBlocEvent {
  final String usuarioID;

  final String usuarioEixoID;

  UpdateUserIDAplicacaoHomePageBlocEvent(this.usuarioID, this.usuarioEixoID);
}

class UpdateQuesionarioAplicadoListAplicacaoHomePageBlocEvent
    extends AplicacaoHomePageBlocEvent {
  final fsw.QuerySnapshot snapshot;

  UpdateQuesionarioAplicadoListAplicacaoHomePageBlocEvent(this.snapshot);
}

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
    if (event is UpdateUserIDAplicacaoHomePageBlocEvent) {
      if (_state.usuarioID != event.usuarioID) {
        _state.usuarioID = event.usuarioID;
        _state.usuarioEixoID = event.usuarioEixoID;
        dispatch(QueryQuestionariosAplicadoListAplicacaoHomePageBlocEvent());
      }
    }
    if (event is QueryQuestionariosAplicadoListAplicacaoHomePageBlocEvent) {
      _reference
          .where("aplicador.id", isEqualTo: _state.usuarioID)
          .where("eixo.id", isEqualTo: _state.usuarioEixoID)
          .snapshots()
          .listen(
        (snapshot) {
          if (!_inputController.isClosed) {
            //isto não deveria acontecer, não sei porque o inputController
            //foi fechado nem onde
            dispatch(UpdateQuesionarioAplicadoListAplicacaoHomePageBlocEvent(
                snapshot));
          }
        },
      );
    }

    if (event is UpdateQuesionarioAplicadoListAplicacaoHomePageBlocEvent) {
      _state.questionariosAplicados = event.snapshot.documents
          .map((doc) =>
              QuestionarioAplicadoModel(id: doc.documentID).fromMap(doc.data))
          .toList();
    }

    _outputController.add(_state);
    print('event.runtimeType em AplicacaoHomePageBloc  = ${event.runtimeType}');
  }
}
