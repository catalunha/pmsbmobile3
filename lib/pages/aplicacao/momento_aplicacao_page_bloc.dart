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

class MomentoAplicacaoPageBlocState {
  String questionarioAplicadoID;
  String referencia;
  String usuarioID;
  String usuarioNome;

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

    if(!currentState.isBound && currentState.questionario == null){
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

        currentState.perguntas.forEach((pergunta) {
          pergunta.requisitos.forEach((id, requisito) {
            currentState.requisitos[id] = requisito;
          });
        });
      }
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
        editar_questionario_aplicado(ref);
      }
    }
    validateState();
  }

  void criar_questionario_aplicado(fsw.DocumentReference ref) {
    //criar questionario aplicado
    QuestionarioAplicadoModel model =
        QuestionarioAplicadoModel().fromMap(currentState.questionario.toMap());
    final usuario = UsuarioQuestionario(
        id: currentState.usuarioID, nome: currentState.usuarioNome);

    model.referencia = currentState.referencia;
    model.aplicador = usuario;
    model.aplicado = DateTime.now();

    ref.setData(model.toMap(), merge: true);

    //cria pergutnas aplicadas
    final perguntasAplicadasRef =
        _firestore.collection(PerguntaAplicadaModel.collection);
    currentState.perguntas.forEach((pergunta) {
      final model =
          PerguntaAplicadaModel(id: pergunta.id).fromMap(pergunta.toMap());
      model.questionario.id = ref.documentID;
      final perguntaAplicadaRef = perguntasAplicadasRef.document();
      perguntaAplicadaRef.setData(model.toMap());
    });
  }

  void editar_questionario_aplicado(fsw.DocumentReference ref) {
    final model =
        QuestionarioAplicadoModel(referencia: currentState.referencia);
    ref.setData(model.toMap(), merge: true);
  }
}
