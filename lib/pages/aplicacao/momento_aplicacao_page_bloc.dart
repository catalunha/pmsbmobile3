import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/models/questionario_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:pmsbmibile3/state/bloc.dart';

class MomentoAplicacaoPageBlocEvent {}

class UpdateIDMomentoAplicacaoPageBlocEvent
    extends MomentoAplicacaoPageBlocEvent {
  final String questionarioAplicadoID;

  UpdateIDMomentoAplicacaoPageBlocEvent(this.questionarioAplicadoID);
}

class CarregarListaPerguntasMomentoAplicacaoPageBlocEvent
    extends MomentoAplicacaoPageBlocEvent {}

class SaveMomentoAplicacaoPageBlocEvent extends MomentoAplicacaoPageBlocEvent {}

class DeleteMomentoAplicacaoPageBlocEvent
    extends MomentoAplicacaoPageBlocEvent {}

class UpdateReferenciaMomentoAplicacaoPageBlocEvent
    extends MomentoAplicacaoPageBlocEvent {
  final String referencia;

  UpdateReferenciaMomentoAplicacaoPageBlocEvent(this.referencia);
}

class CarregarListaQuestionarioMomentoAplicacaoPageBlocEvent
    extends MomentoAplicacaoPageBlocEvent {}

class SelecionarQuestionarioMomentoAplicacaoPageBlocEvent
    extends MomentoAplicacaoPageBlocEvent {
  final QuestionarioModel questionario;

  SelecionarQuestionarioMomentoAplicacaoPageBlocEvent(this.questionario);
}

class MomentoAplicacaoPageBlocState {
  String questionarioAplicadoID;
  String referencia;
  String usuarioID;
  String usuarioNome;
  String questionarioID;

  bool isBound = false;
  bool isValid = false;

  List<QuestionarioModel> questionarios;
  List<PerguntaModel> perguntas;

  ///RequisitoID, PerguntaAplicadaID
  Map<String, String> requisitosSelecionados = Map<String, String>();
  Map<String, Requisito> requisitos = Map<String, Requisito>();
  QuestionarioModel questionario;

  MomentoAplicacaoPageBlocState({
    this.questionarioAplicadoID,
    this.referencia,
    this.usuarioID,
    this.usuarioNome,
    this.questionarioID,
  });
}

class MomentoAplicacaoPageBloc
    extends Bloc<MomentoAplicacaoPageBlocEvent, MomentoAplicacaoPageBlocState> {
  final fsw.Firestore _firestore;

  MomentoAplicacaoPageBloc(this._firestore) : super();

  @override
  MomentoAplicacaoPageBlocState getInitialState() {
    return MomentoAplicacaoPageBlocState();
  }

  @override
  Future<void> mapEventToState(MomentoAplicacaoPageBlocEvent event) async {
    if (event is UpdateReferenciaMomentoAplicacaoPageBlocEvent) {
      currentState.referencia = event.referencia;
    }
    if (event is CarregarListaQuestionarioMomentoAplicacaoPageBlocEvent) {
      final questionariosSnap = await _firestore
          .collection(QuestionarioModel.collection)
          .getDocuments();
      currentState.questionarios = questionariosSnap.documents
          .map((doc) => QuestionarioModel(id: doc.documentID).fromMap(doc.data))
          .toList();
    }

    if (event is SelecionarQuestionarioMomentoAplicacaoPageBlocEvent) {
      currentState.questionario = event.questionario;
      dispatch(CarregarListaPerguntasMomentoAplicacaoPageBlocEvent());
    }

    if (event is CarregarListaPerguntasMomentoAplicacaoPageBlocEvent) {
      final perguntasSnap = await _firestore
          .collection(PerguntaModel.collection)
          .where("questionario.id",
              isEqualTo: currentState.questionario.id)
          .getDocuments();
      currentState.perguntas = perguntasSnap.documents
          .map((doc) => PerguntaModel(id: doc.documentID).fromMap(doc.data))
          .toList();
      currentState.requisitos.clear();
      currentState.requisitosSelecionados.clear();
      currentState.perguntas.forEach((pergunta) {
        pergunta.requisitos.forEach((id, requisito) {
          currentState.requisitos[id] = requisito;
        });
      });
    }

    if (event is DeleteMomentoAplicacaoPageBlocEvent) {
      final ref = _firestore
          .collection(QuestionarioAplicadoModel.collection)
          .document(currentState.questionarioAplicadoID);
      await ref.delete();
    }

    if (event is SaveMomentoAplicacaoPageBlocEvent) {
      final ref = _firestore
          .collection(QuestionarioAplicadoModel.collection)
          .document(currentState.questionarioAplicadoID);
      final model = QuestionarioAplicadoModel(
        referencia: currentState.referencia,
        aplicador: UsuarioQuestionario(
            id: currentState.usuarioID, nome: currentState.usuarioNome),
        aplicado: DateTime.now(),
      );
      ref.setData(model.toMap(), merge: true);
    }
  }
}
