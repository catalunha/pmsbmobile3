import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/state/bloc.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

class AplicandoPerguntaPageBlocState {
  String questionarioAplicadoID;
  int perguntaAtualIndex = 0;
  bool perguntasOk = false;
  List<PerguntaAplicadaModel> _perguntas;

  PerguntaAplicadaModel get perguntaAtual {
    if (_perguntas != null)
      return _perguntas[perguntaAtualIndex];
    else
      return null;
  }

  set perguntas(List<PerguntaAplicadaModel> p) {
    _perguntas = p;
    if (p != null) perguntasOk = true;
  }

  int get totalPerguntas {
    if (_perguntas != null)
      return _perguntas.length;
    else
      return 0;
  }
}

class AplicandoPerguntaPageBlocEvent {}

class UpdateQuestionarioAplicadoIDAplicandoPerguntaPageBlocEvent
    extends AplicandoPerguntaPageBlocEvent {
  final String questionarioAplicadoID;

  UpdateQuestionarioAplicadoIDAplicandoPerguntaPageBlocEvent(
      this.questionarioAplicadoID);
}

class CarregaListaPerguntasAplicadasAplicandoPerguntaPageBlocEvent
    extends AplicandoPerguntaPageBlocEvent {}

class SalvarAplicandoPerguntaPageBlocEvent
    extends AplicandoPerguntaPageBlocEvent {}

class PularAplicandoPerguntaPageBlocEvent
    extends AplicandoPerguntaPageBlocEvent {}

class VoltarAplicandoPerguntaPageBlocEvent
    extends AplicandoPerguntaPageBlocEvent {}

class AplicandoPerguntaPageBloc extends Bloc<AplicandoPerguntaPageBlocEvent,
    AplicandoPerguntaPageBlocState> {
  AplicandoPerguntaPageBloc(this._firestore);

  final fsw.Firestore _firestore;

  @override
  AplicandoPerguntaPageBlocState getInitialState() {
    return AplicandoPerguntaPageBlocState();
  }

  @override
  Future<void> mapEventToState(AplicandoPerguntaPageBlocEvent event) async {
    if (event is PularAplicandoPerguntaPageBlocEvent) {
      if (currentState.perguntaAtualIndex < currentState.totalPerguntas - 1) {
        currentState.perguntaAtualIndex += 1;
      } else {
        currentState.perguntaAtualIndex = 0;
      }
    }
    if (event is VoltarAplicandoPerguntaPageBlocEvent) {
      if (currentState.perguntaAtualIndex > 0) {
        currentState.perguntaAtualIndex -= 1;
      }
    }
    if (event is UpdateQuestionarioAplicadoIDAplicandoPerguntaPageBlocEvent) {
      currentState.questionarioAplicadoID = event.questionarioAplicadoID;
      dispatch(CarregaListaPerguntasAplicadasAplicandoPerguntaPageBlocEvent());
    }

    if (event is CarregaListaPerguntasAplicadasAplicandoPerguntaPageBlocEvent) {
      final query = _firestore
          .collection(PerguntaAplicadaModel.collection)
          .where("questionario.id",
              isEqualTo: currentState.questionarioAplicadoID).orderBy("ordem");
      final snap = await query.getDocuments();
      currentState.perguntas = snap.documents
          .map((doc) =>
              PerguntaAplicadaModel(id: doc.documentID).fromMap(doc.data))
          .toList();
    }
    if (event is SalvarAplicandoPerguntaPageBlocEvent) {
      dispatch(PularAplicandoPerguntaPageBlocEvent());
    }
  }
}
