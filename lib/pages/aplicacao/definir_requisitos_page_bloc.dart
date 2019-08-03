import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/state/bloc.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

class DefinirRequisitosPageBlocState {
  String referencia;
  List<PerguntaAplicadaModel> perguntas;
}

class DefinirRequisitosPageBlocEvent {}

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
    if (event is UpdateReferenciaDefinirRequisitosPageBlocEvent) {
      currentState.referencia = event.referencia;
      dispatch(UpdateListaPerguntaAplicadaDefinirRequisitosPageBlocEvent());
    }
    if (event is UpdateListaPerguntaAplicadaDefinirRequisitosPageBlocEvent) {

      final query = await _firestore
          .collection(PerguntaAplicadaModel.collection)
          .where("referencia", isEqualTo: currentState.referencia)
          .getDocuments();
      currentState.perguntas = query.documents
          .map((doc) =>
              PerguntaAplicadaModel(id: doc.documentID).fromMap(doc.data))
          .toList();
    }
  }
}
