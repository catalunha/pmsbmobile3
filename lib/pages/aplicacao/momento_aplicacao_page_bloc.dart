import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/models/questionario_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
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

class UpdateUsuarioMomentoAplicacaoPageBlocEvent
    extends MomentoAplicacaoPageBlocEvent {
  final UsuarioModel usuario;

  UpdateUsuarioMomentoAplicacaoPageBlocEvent(this.usuario);
}

class SelecionarRequisitoMomentoAplicacaoPageBlocEvent
    extends MomentoAplicacaoPageBlocEvent {
  final String requisitoId;
  final String perguntaId;

  SelecionarRequisitoMomentoAplicacaoPageBlocEvent(
      this.requisitoId, this.perguntaId);
}

class MomentoAplicacaoPageBlocState {
  String questionarioAplicadoID;
  String referencia;
  String usuarioID;
  String usuarioNome;
  String usuarioEixoID;
  String setorCensitarioID;
  String setorCensitarioNome;
  bool isBound = false;
  bool isValid = false;

  List<QuestionarioModel> questionarios;
  List<PerguntaModel> perguntas;

  ///RequisitoID, PerguntaAplicadaID
  Map<String, String> requisitosSelecionados = Map<String, String>();
  Map<String, Requisito> requisitos = Map<String, Requisito>();
  Map<String, String> requisitoPergunta = Map<String, String>();
  QuestionarioModel questionario;

  MomentoAplicacaoPageBlocState({
    this.questionarioAplicadoID,
    this.referencia,
    this.usuarioID,
    this.usuarioNome,
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

  void validateState() {
    bool valid = true;

    if (!currentState.isBound && currentState.questionario == null) {
      valid = false;
    }

    if (currentState.referencia == null ||
        currentState.referencia.trim().isEmpty) {
      valid = false;
    }

    currentState.isValid = valid;
  }

  @override
  Future<void> mapEventToState(MomentoAplicacaoPageBlocEvent event) async {
    if (event is UpdateUsuarioMomentoAplicacaoPageBlocEvent) {
      currentState.usuarioNome = event.usuario.nome;
      currentState.usuarioID = event.usuario.id;
      currentState.usuarioEixoID = event.usuario.eixoIDAtual.id;
      currentState.setorCensitarioID = event.usuario.setorCensitarioID.id;
      currentState.setorCensitarioNome = event.usuario.setorCensitarioID.nome;
    }
    if (event is UpdateIDMomentoAplicacaoPageBlocEvent) {
      if (event.questionarioAplicadoID != null) {
        final questionarioAplicadoRef = _firestore
            .collection(QuestionarioAplicadoModel.collection)
            .document(event.questionarioAplicadoID);
        final questionarioAplicadoSnap = await questionarioAplicadoRef.get();
        if (questionarioAplicadoSnap.exists) {
          currentState.isBound = true;
          currentState.questionario =
              QuestionarioAplicadoModel(id: questionarioAplicadoSnap.documentID)
                  .fromMap(questionarioAplicadoSnap.data);

          dispatch(CarregarListaPerguntasMomentoAplicacaoPageBlocEvent());

          final QuestionarioAplicadoModel q = currentState.questionario;
          dispatch(UpdateReferenciaMomentoAplicacaoPageBlocEvent(q.referencia));
        } else {
          currentState.isBound = false;
        }
      }
    }

    if (event is UpdateReferenciaMomentoAplicacaoPageBlocEvent) {
      currentState.referencia = event.referencia;
    }

    if (event is CarregarListaQuestionarioMomentoAplicacaoPageBlocEvent) {
      final questionariosSnap = await _firestore
          .collection(QuestionarioModel.collection)
          .where("eixo.id", isEqualTo: currentState.usuarioEixoID)
          .getDocuments();
      currentState.questionarios = questionariosSnap.documents
          .map((doc) => QuestionarioModel(id: doc.documentID).fromMap(doc.data))
          .toList();
    }

    if (event is SelecionarQuestionarioMomentoAplicacaoPageBlocEvent) {
      currentState.questionario = event.questionario;
      currentState.isBound = false;
      dispatch(CarregarListaPerguntasMomentoAplicacaoPageBlocEvent());
    }

    if (event is CarregarListaPerguntasMomentoAplicacaoPageBlocEvent) {
      final String collection = currentState.isBound
          ? PerguntaAplicadaModel.collection
          : PerguntaModel.collection;

      final perguntasSnap = await _firestore
          .collection(collection)
          .where("questionario.id", isEqualTo: currentState.questionario.id)
          .getDocuments();

      currentState.perguntas = perguntasSnap.documents.map((doc) {
        if (currentState.isBound)
          return PerguntaAplicadaModel(id: doc.documentID).fromMap(doc.data);
        else
          return PerguntaModel(id: doc.documentID).fromMap(doc.data);
      }).toList();
      if (currentState.isBound) {
        currentState.requisitos.clear();
        currentState.requisitosSelecionados.clear();
        currentState.requisitoPergunta.clear();
        final q = currentState.questionario as QuestionarioAplicadoModel;

        for (var pergunta in currentState.perguntas) {
          for (var item in pergunta.requisitos.entries) {
            final requisito = item.value;
            final id = item.key;

            currentState.requisitoPergunta[id] = pergunta.id;
            if (!q.referencias.containsKey(requisito.referencia)) {
              currentState.requisitos[requisito.referencia] = requisito;
            }
            if (requisito.perguntaID != null) {
              currentState.requisitosSelecionados[requisito.referencia] =
                  requisito.perguntaID;
            }
          }
        }
      }
    }

    if (event is SelecionarRequisitoMomentoAplicacaoPageBlocEvent) {
      currentState.requisitosSelecionados[event.requisitoId] = event.perguntaId;
    }

    if (event is DeleteMomentoAplicacaoPageBlocEvent) {
      final ref = _firestore
          .collection(QuestionarioAplicadoModel.collection)
          .document(currentState.questionario.id);
      await ref.delete();
      //deleta perguntas aplicadas
      final perguntasAplicadasRef = _firestore
          .collection(PerguntaAplicadaModel.collection)
          .where("questionario.id", isEqualTo: currentState.questionario.id);
      perguntasAplicadasRef.getDocuments().then((query) {
        query.documents.forEach((doc) {
          doc.reference.delete();
        });
      });
    }
    if (event is SaveMomentoAplicacaoPageBlocEvent) {
      if (!currentState.isBound) {
        final ref = _firestore
            .collection(QuestionarioAplicadoModel.collection)
            .document();
        criar_questionario_aplicado(ref);
      } else {
        final ref = _firestore
            .collection(QuestionarioAplicadoModel.collection)
            .document(currentState.questionario.id);
        await editar_questionario_aplicado(ref);
      }
    }
    validateState();
  }

  void criar_questionario_aplicado(fsw.DocumentReference ref) {
    //criar questionario aplicado
    QuestionarioAplicadoModel qmodel =
        QuestionarioAplicadoModel().fromMap(currentState.questionario.toMap());
    final usuario = UsuarioQuestionario(
        id: currentState.usuarioID, nome: currentState.usuarioNome);

    qmodel.referencia = currentState.referencia;
    qmodel.aplicador = usuario;
    qmodel.aplicado = DateTime.now();
    qmodel.setorCensitarioID = SetorCensitario(
      id: currentState.setorCensitarioID,
      nome: currentState.setorCensitarioNome,
    );

    ref.setData(qmodel.toMap(), merge: true);
    final referencias = Map<String, String>();
    //cria pergutnas aplicadas
    final perguntasAplicadasRef =
        _firestore.collection(PerguntaAplicadaModel.collection);
    currentState.perguntas.forEach((pergunta) {
      PerguntaAplicadaModel pmodel =
          PerguntaAplicadaModel(id: pergunta.id).fromMap(pergunta.toMap());
      pmodel.questionario.id = ref.documentID;
      pmodel.questionario.referencia = currentState.referencia;
      final perguntaAplicadaRef = perguntasAplicadasRef.document();
      perguntaAplicadaRef.setData(pmodel.toMap());
      referencias[pmodel.referencia] = perguntaAplicadaRef.documentID;
    });
    qmodel.referencias = referencias;
    ref.setData(qmodel.toMap(), merge: true);
    requisitosInternos(ref);
  }

  Future<void> editar_questionario_aplicado(fsw.DocumentReference ref) async {
    final model =
        QuestionarioAplicadoModel(referencia: currentState.referencia);
    ref.setData(model.toMap(), merge: true);

    final q = currentState.questionario as QuestionarioAplicadoModel;

    //atualiza requisitos
    for (var pergunta in currentState.perguntas) {
      for (var requisitoItem in pergunta.requisitos.entries) {
        final requisito = requisitoItem.value;
        final requisitoId = requisitoItem.key;
        String perguntaRequisitadaId;
        if (currentState.requisitosSelecionados
            .containsKey(requisito.referencia)) {
          //requisito externo
          perguntaRequisitadaId =
              currentState.requisitosSelecionados[requisito.referencia];
        } else if (q.referencias.containsKey(requisito.referencia)) {
          //requisito interno

          perguntaRequisitadaId = q.referencias[requisito.referencia];
        }
        pergunta.requisitos[requisitoId].perguntaID = perguntaRequisitadaId;
      }
      //salva requisito
      final ref = _firestore
          .collection(PerguntaAplicadaModel.collection)
          .document(pergunta.id);
      ref.setData(pergunta.toMap(), merge: true);
    }
  }

  void requisitosInternos(fsw.DocumentReference ref) async {
    final qsnap = await ref.get();
    final q =
        QuestionarioAplicadoModel(id: qsnap.documentID).fromMap(qsnap.data);
    final perguntasSnap = await _firestore
        .collection(PerguntaAplicadaModel.collection)
        .where("questionario.id", isEqualTo: ref.documentID)
        .getDocuments();
    final perguntas = perguntasSnap.documents
        .map((doc) =>
            PerguntaAplicadaModel(id: doc.documentID).fromMap(doc.data))
        .toList();

    //atualiza requisitos
    for (var pergunta in perguntas) {
      for (var requisitoItem in pergunta.requisitos.entries) {
        final requisito = requisitoItem.value;
        final requisitoId = requisitoItem.key;
        if (q.referencias.containsKey(requisito.referencia)) {
          //requisito interno
          pergunta.requisitos[requisitoId].perguntaID =
              q.referencias[requisito.referencia];
        }
      }
      //salva requisitos
      final ref = _firestore
          .collection(PerguntaAplicadaModel.collection)
          .document(pergunta.id);
      ref.setData(pergunta.toMap(), merge: true);
    }
  }
}
