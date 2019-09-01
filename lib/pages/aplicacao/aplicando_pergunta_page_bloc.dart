import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/state/bloc.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

class AplicandoPerguntaPageBlocState {
  String questionarioAplicadoID;
  String usuarioID;
  int perguntaAtualIndex = 0;
  bool perguntasOk = false;
  String primeiraPerguntaID;
  bool carregando = true;
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

class UpdateUserIDAplicandoPerguntaPageBlocEvent
    extends AplicandoPerguntaPageBlocEvent {
  final String usuarioID;

  UpdateUserIDAplicandoPerguntaPageBlocEvent(this.usuarioID);
}

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

class IniciarProximaPerguntaAplicandoPerguntaPageBlocEvent
    extends AplicandoPerguntaPageBlocEvent {
  final bool reset;
  final int index;

  IniciarProximaPerguntaAplicandoPerguntaPageBlocEvent({
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
    if (event is UpdateUserIDAplicandoPerguntaPageBlocEvent) {
      currentState.usuarioID = event.usuarioID;
    }

    if (event is IniciarProximaPerguntaAplicandoPerguntaPageBlocEvent) {
      currentState.carregando = true;
      await verificarRequisitosPerguntas();
      dispatch(ProximaPerguntaAplicandoPerguntaPageBlocEvent(
          reset: event.reset, index: event.index));
    }

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
      currentState.carregando = false;
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
      await verificarRequisitosPerguntas();

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

      dispatch(IniciarProximaPerguntaAplicandoPerguntaPageBlocEvent(
          reset: true, index: primeiraPerguntaIndex));
    }
    if (event is SalvarAplicandoPerguntaPageBlocEvent) {
      currentState.perguntaAtual.foiRespondida = event.foiRespondida;

      if (currentState.isValid) {
        final map = currentState.perguntaAtual.toMap();
        final ref = _firestore
            .collection(PerguntaAplicadaModel.collection)
            .document(currentState.perguntaAtual.id);
        ref.setData(map, merge: false);
      }

      dispatch(IniciarProximaPerguntaAplicandoPerguntaPageBlocEvent());
    }

    //respostas
    if (event is UpdateObservacaoAplicandoPerguntaPageBlocEvent) {
      currentState.perguntaAtual.observacao = event.observacao;
    }
  }

  Future<void> verificarRequisitosPerguntas() async {
    for (var pergunta in currentState.perguntas) {
      pergunta.temPendencias = false;
      if (pergunta.requisitos.length > 0) {
        for (var item in pergunta.requisitos.entries) {
          final requisitoId = item.key;
          final requisito = item.value;
          if (requisito.perguntaID == null) {
            //requisito não foi definido

            pergunta.temPendencias = true;
            break;
          } else {}
          final perguntaRef = _firestore
              .collection(PerguntaAplicadaModel.collection)
              .document(requisito.perguntaID);
          final perguntaSnap = await perguntaRef.get();

          if (!perguntaSnap.exists) {
            //requisito foi definido mas deletado

            pergunta.temPendencias = true;
            pergunta.requisitos[requisitoId].perguntaID = null;
            break;
          } else {}

          final perguntaInstance =
              PerguntaAplicadaModel(id: perguntaSnap.documentID)
                  .fromMap(perguntaSnap.data);

          if (requisito.escolha != null) {
            //requisito para escolha

            final escolha = requisito.escolha;
            if (perguntaInstance.escolhas[escolha.id].marcada !=
                escolha.marcada) {
              //não tem a marca correta

              pergunta.temPendencias = true;
              break;
            } else {}
          } else if (!perguntaInstance.foiRespondida) {
            pergunta.temPendencias = true;
            break;
          }
        }
      }
      _firestore
          .collection(PerguntaAplicadaModel.collection)
          .document(pergunta.id)
          .setData(pergunta.toMap(), merge: true);
    }
  }
}
