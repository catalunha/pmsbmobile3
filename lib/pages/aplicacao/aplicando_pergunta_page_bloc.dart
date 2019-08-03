import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/state/bloc.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

class AplicandoPerguntaPageBlocState {
  String questionarioAplicadoID;
  int perguntaAtualIndex = 0;
  bool perguntasOk = false;
  String primeiraPerguntaID;
  List<PerguntaAplicadaModel> _perguntas;

  PerguntaAplicadaModel get perguntaAtual {
    if (_perguntas != null && perguntaAtualIndexValido)
      return _perguntas[perguntaAtualIndex];
    else
      return null;
  }

  bool get perguntaAtualOk {
    if (perguntaAtual != null && !perguntaAtual.temPendencias)
      return true;
    else
      return false;
  }

  set perguntas(List<PerguntaAplicadaModel> p) {
    _perguntas?.clear();
    _perguntas = p;
    if (p != null) perguntasOk = true;
  }

  List<PerguntaAplicadaModel> get perguntas {
    return _perguntas != null ? _perguntas : [];
  }

  int get totalPerguntas {
    if (_perguntas != null)
      return _perguntas.length;
    else
      return 0;
  }

  bool get isValid {
    if (perguntaAtual.tipo.nome == "texto") {
      if (perguntaAtual.texto.isEmpty) {
        return false;
      }
    }
    return true;
  }

  bool get perguntaAtualIndexValido {
    return perguntaAtualIndex >= 0 &&
        perguntaAtualIndex <= _perguntas.length - 1;
  }

  bool get questionarioFinalizado {
    if (!perguntasOk) return false;
    return perguntaAtualIndex >= _perguntas.length;
  }
}

class AplicandoPerguntaPageBlocEvent {}

class UpdateObservacaoAplicandoPerguntaPageBlocEvent
    extends AplicandoPerguntaPageBlocEvent {
  final String observacao;

  UpdateObservacaoAplicandoPerguntaPageBlocEvent(this.observacao);
}

class IniciarQuestionarioAplicadoAplicandoPerguntaPageBlocEvent
    extends AplicandoPerguntaPageBlocEvent {
  final String questionarioAplicadoID;
  final String perguntaID;

  IniciarQuestionarioAplicadoAplicandoPerguntaPageBlocEvent(
      this.questionarioAplicadoID, this.perguntaID);
}

class CarregaListaPerguntasAplicadasAplicandoPerguntaPageBlocEvent
    extends AplicandoPerguntaPageBlocEvent {}

class SalvarAplicandoPerguntaPageBlocEvent
    extends AplicandoPerguntaPageBlocEvent {
  final bool foiRespondida;

  SalvarAplicandoPerguntaPageBlocEvent(this.foiRespondida);
}

class ProximaPerguntaAplicandoPerguntaPageBlocEvent
    extends AplicandoPerguntaPageBlocEvent {
  final bool reset;
  final int index;

  ProximaPerguntaAplicandoPerguntaPageBlocEvent({
    this.reset = false,
    this.index,
  });
}

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
    if (event is ProximaPerguntaAplicandoPerguntaPageBlocEvent) {
      if (event.index != null) {
        currentState.perguntaAtualIndex = event.index;
      } else {
        if (event.reset) {
          currentState.perguntaAtualIndex = 0;
        } else {
          currentState.perguntaAtualIndex += 1;
        }
        while (true) {
          if (currentState.questionarioFinalizado ||
              (currentState.perguntaAtualOk &&
                  !(currentState.perguntaAtual.foiRespondida) &&
                  !(currentState.perguntaAtual.temPendencias))) {
            break;
          }
          currentState.perguntaAtualIndex += 1;
        }
      }
    }
    if (event is IniciarQuestionarioAplicadoAplicandoPerguntaPageBlocEvent) {
      currentState.questionarioAplicadoID = event.questionarioAplicadoID;
      currentState.primeiraPerguntaID = event.perguntaID;
      dispatch(CarregaListaPerguntasAplicadasAplicandoPerguntaPageBlocEvent());
    }

    if (event is CarregaListaPerguntasAplicadasAplicandoPerguntaPageBlocEvent) {
      final query = _firestore
          .collection(PerguntaAplicadaModel.collection)
          .where("questionario.id",
              isEqualTo: currentState.questionarioAplicadoID)
          .orderBy("ordem");
      final snap = await query.getDocuments();

      currentState.perguntas = snap.documents
          .map((doc) =>
              PerguntaAplicadaModel(id: doc.documentID).fromMap(doc.data))
          .toList();
      //verificar pendencias de requisitos
      verificarRequisitosPerguntas();

      int primeiraPerguntaIndex;
      if (currentState.primeiraPerguntaID != null) {
        for (int index = 0; index < currentState.perguntas.length; index++) {
          if (currentState.perguntas[index].id ==
              currentState.primeiraPerguntaID) {
            primeiraPerguntaIndex = index;
          }
        }
        currentState.primeiraPerguntaID = null;
      }

      dispatch(ProximaPerguntaAplicandoPerguntaPageBlocEvent(
          reset: true, index: primeiraPerguntaIndex));
    }
    if (event is SalvarAplicandoPerguntaPageBlocEvent) {
      currentState.perguntaAtual.foiRespondida = event.foiRespondida;

      if (currentState.isValid) {
        final map = currentState.perguntaAtual.toMap();
        final ref = _firestore
            .collection(PerguntaAplicadaModel.collection)
            .document(currentState.perguntaAtual.id);
        ref.setData(map, merge: true);
      }

      dispatch(ProximaPerguntaAplicandoPerguntaPageBlocEvent());
    }

    //respostas
    if (event is UpdateObservacaoAplicandoPerguntaPageBlocEvent) {
      currentState.perguntaAtual.observacao = event.observacao;
    }
  }

  void verificarRequisitosPerguntas() {
    for (var pergunta in currentState.perguntas) {
      if (pergunta.requisitos.length > 0) {
        pergunta.temPendencias = true;
        //TODO: verificação completa de requisitos
      } else {
        pergunta.temPendencias = false;
      }
      _firestore
          .collection(PerguntaAplicadaModel.collection)
          .document(pergunta.id)
          .setData({"temPendencias": pergunta.temPendencias}, merge: true);
    }
  }
}
