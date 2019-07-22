import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:pmsbmibile3/pages/pergunta/editar_apagar_pergunta_page_bloc.dart';

class SelecionarRequisitoPerguntaPageBlocState {
  String eixoID;

  ///{'pergunta': 'Pergunta texto ', 'checkbox': true},
  List<Map<String, dynamic>> requisitos;
}

class SelecionarRequisitoPerguntaPageBlocEvent {}

class UpdateEixoIDSelecionarRequisitoPerguntaPageBlocEvent
    extends SelecionarRequisitoPerguntaPageBlocEvent {
  final String eixoID;

  UpdateEixoIDSelecionarRequisitoPerguntaPageBlocEvent(this.eixoID);
}

class UpdateListaRequisitosSelecionarRequisitoPerguntaPageBlocEvent
    extends SelecionarRequisitoPerguntaPageBlocEvent {}

class IndexSelecionarRequisitoPerguntaPageBlocEvent extends SelecionarRequisitoPerguntaPageBlocEvent{
  final int index;
  final bool val;
  IndexSelecionarRequisitoPerguntaPageBlocEvent(this.index, this.val);
}

class SelecionarRequisitoPerguntaPageBloc {
  final fsw.Firestore _firestore;
  final EditarApagarPerguntaBloc blocPergunta;
  final AuthBloc authBloc;

  final _state = SelecionarRequisitoPerguntaPageBlocState();

  final _inputController =
      BehaviorSubject<SelecionarRequisitoPerguntaPageBlocEvent>();

  Function get dispatch => _inputController.add;

  final _outputController =
      BehaviorSubject<SelecionarRequisitoPerguntaPageBlocState>();
  Stream<SelecionarRequisitoPerguntaPageBlocState> get state => _outputController.stream;

  SelecionarRequisitoPerguntaPageBloc(
      this._firestore, this.authBloc, this.blocPergunta) {
    _inputController.listen(_handleInput);

    authBloc.perfil.listen((perfil) {
      if (perfil.eixoIDAtual.id != null) {
        dispatch(UpdateEixoIDSelecionarRequisitoPerguntaPageBlocEvent(
            perfil.eixoIDAtual.id));
        dispatch(
            UpdateListaRequisitosSelecionarRequisitoPerguntaPageBlocEvent());
      }
    });
  }

  void dispose() {
    _inputController.close();
    _outputController.close();
  }

  void _handleInput(SelecionarRequisitoPerguntaPageBlocEvent event) async {
    if (event is UpdateEixoIDSelecionarRequisitoPerguntaPageBlocEvent) {
      _state.eixoID = event.eixoID;
    }
    if (event
        is UpdateListaRequisitosSelecionarRequisitoPerguntaPageBlocEvent) {
      final ref = _firestore.collection(PerguntaModel.collection);
      await ref.getDocuments().then((fsw.QuerySnapshot snap) {
        final perguntas = snap.documents.map((fsw.DocumentSnapshot doc) {
          return PerguntaModel(id: doc.documentID).fromMap(doc.data);
        }).toList();
        perguntas.forEach((pergunta){
          _state.requisitos = List<Map<String, dynamic>>();
          _state.requisitos.add({"pergunta":pergunta.titulo, "checkbox":false});
        });
      });

    }
    if(event is IndexSelecionarRequisitoPerguntaPageBlocEvent){
      _state.requisitos[event.index]["checkbox"] = event.val;
    }
    _outputController.add(_state);
  }
}
