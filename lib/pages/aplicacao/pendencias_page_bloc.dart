import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/state/bloc.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

class PendenciasPageBlocEvent {}

class UpdateQuestionarioIDPendenciasPageBlocEvent
    extends PendenciasPageBlocEvent {
  final String questionarioAplicadoID;

  UpdateQuestionarioIDPendenciasPageBlocEvent(this.questionarioAplicadoID);
}

class UpdateListaPerguntasAplicadasPendenciasPageBlocEvent
    extends PendenciasPageBlocEvent {
  final fsw.QuerySnapshot snapshot;

  UpdateListaPerguntasAplicadasPendenciasPageBlocEvent(this.snapshot);
}

class QueryPerguntasAplicadasPendenciasPageBlocEvent
    extends PendenciasPageBlocEvent {}

class PendenciasPageBlocState {
  String questionarioAplicadoID;
  List<PerguntaAplicadaModel> _perguntas;

  set perguntas(List<PerguntaAplicadaModel> p) {
    _perguntas = p;
  }

  List<PerguntaAplicadaModel> get perguntas {
    if (_perguntas != null)
      return _perguntas;
    else
      return [];
  }
}

class PendenciasPageBloc
    extends Bloc<PendenciasPageBlocEvent, PendenciasPageBlocState> {
  PendenciasPageBloc(this._firestore);

  final fsw.Firestore _firestore;

  @override
  PendenciasPageBlocState getInitialState() {
    return PendenciasPageBlocState();
  }

  @override
  Future<void> mapEventToState(PendenciasPageBlocEvent event) async {
    if (event is UpdateQuestionarioIDPendenciasPageBlocEvent) {
      currentState.questionarioAplicadoID = event.questionarioAplicadoID;
      dispatch(QueryPerguntasAplicadasPendenciasPageBlocEvent());
    }
    if (event is QueryPerguntasAplicadasPendenciasPageBlocEvent) {
      _firestore
          .collection(PerguntaAplicadaModel.collection)
          .where("questionario.id",
              isEqualTo: currentState.questionarioAplicadoID)
          .snapshots()
          .listen((snapshot) {
        dispatch(
            UpdateListaPerguntasAplicadasPendenciasPageBlocEvent(snapshot));
      });
    }
    if (event is UpdateListaPerguntasAplicadasPendenciasPageBlocEvent) {
      currentState.perguntas = event.snapshot.documents
          .map((doc) =>
              PerguntaAplicadaModel(id: doc.documentID).fromMap(doc.data))
          .toList();
    }
  }
}
