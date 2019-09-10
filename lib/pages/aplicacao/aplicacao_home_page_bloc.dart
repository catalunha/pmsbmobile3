import 'package:pmsbmibile3/models/models.dart';
import 'package:pmsbmibile3/models/questionario_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

class AplicacaoHomePageBlocState {
  List<QuestionarioAplicadoModel> questionariosAplicados;

  UsuarioModel usuario;
}

class AplicacaoHomePageBlocEvent {}

class QueryQuestionariosAplicadoListAplicacaoHomePageBlocEvent
    extends AplicacaoHomePageBlocEvent {}

class UpdateUserIDAplicacaoHomePageBlocEvent
    extends AplicacaoHomePageBlocEvent {
  final UsuarioModel usuario;

  UpdateUserIDAplicacaoHomePageBlocEvent(this.usuario);
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

  void dispose() async {
    await _inputController.drain();
    _inputController?.close();
    await _outputController.drain();
    _outputController?.close();
  }

  void _HandleInput(AplicacaoHomePageBlocEvent event) async {
    if (event is UpdateUserIDAplicacaoHomePageBlocEvent) {
      _state.usuario = event.usuario;
      dispatch(QueryQuestionariosAplicadoListAplicacaoHomePageBlocEvent());
    }
    if (event is QueryQuestionariosAplicadoListAplicacaoHomePageBlocEvent) {
      _reference
          .where("aplicador.id", isEqualTo: _state.usuario.id)
          .where("eixo.id", isEqualTo: _state.usuario.eixoIDAtual.id)
          .where('setorCensitarioID.id', isEqualTo: _state.usuario.setorCensitarioID.id)
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

    if (!_outputController.isClosed) _outputController.add(_state);
    print('event.runtimeType em AplicacaoHomePageBloc  = ${event.runtimeType}');
  }
}
