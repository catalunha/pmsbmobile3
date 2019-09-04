import 'package:pmsbmibile3/models/models.dart';
import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/state/bloc.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

class DefinirRequisitosPageBlocState {
  String referencia;
  UsuarioModel usuario;
  List<PerguntaAplicadaModel> perguntas;
  bool isFetching = true;
}

class DefinirRequisitosPageBlocEvent {}

class UpdateUsuarioDefinirRequisitosPageBlocEvent
    extends DefinirRequisitosPageBlocEvent {
  final UsuarioModel usuario;

  UpdateUsuarioDefinirRequisitosPageBlocEvent(this.usuario);
}

class UpdateReferenciaDefinirRequisitosPageBlocEvent
    extends DefinirRequisitosPageBlocEvent {
  final String referencia;

  UpdateReferenciaDefinirRequisitosPageBlocEvent(this.referencia);
}

class UpdateListaPerguntaAplicadaDefinirRequisitosPageBlocEvent
    extends DefinirRequisitosPageBlocEvent {}

class DefinirRequisitosPageBloc extends Bloc<DefinirRequisitosPageBlocEvent,
    DefinirRequisitosPageBlocState> {
  DefinirRequisitosPageBloc(this._firestore);

  final fsw.Firestore _firestore;

  @override
  DefinirRequisitosPageBlocState getInitialState() {
    return DefinirRequisitosPageBlocState();
  }

  @override
  Future<void> mapEventToState(DefinirRequisitosPageBlocEvent event) async {
    if (event is UpdateUsuarioDefinirRequisitosPageBlocEvent) {
      currentState.usuario = event.usuario;
      currentState.isFetching = true;
    }

    if (event is UpdateReferenciaDefinirRequisitosPageBlocEvent) {
      currentState.referencia = event.referencia;
      currentState.isFetching = true;
      dispatch(UpdateListaPerguntaAplicadaDefinirRequisitosPageBlocEvent());
    }
    if (event is UpdateListaPerguntaAplicadaDefinirRequisitosPageBlocEvent) {
      if (currentState.usuario != null && currentState.referencia != null) {
        final query = await _firestore
            .collection(PerguntaAplicadaModel.collection)
            .where("setorCensitarioID",
                isEqualTo: currentState.usuario.setorCensitarioID.id)
            .where("eixo.id", isEqualTo: currentState.usuario.eixoIDAtual.id)
            .where("referencia", isEqualTo: currentState.referencia)
            .getDocuments();
        currentState.perguntas = query.documents
            .map((doc) =>
                PerguntaAplicadaModel(id: doc.documentID).fromMap(doc.data))
            .toList();
        currentState.isFetching = false;
      }
    }
  }
}
