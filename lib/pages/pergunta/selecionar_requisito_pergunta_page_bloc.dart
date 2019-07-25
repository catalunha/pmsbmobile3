import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:pmsbmibile3/models/pergunta_tipo_model.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:pmsbmibile3/pages/pergunta/editar_apagar_pergunta_page_bloc.dart';

Requisito a = Requisito();

class SelecionarRequisitoPerguntaPageBlocState {
  String eixoID;
  String perguntaID;

  ///"perguntaIDescolhaUID"{'pergunta': 'Pergunta texto ', 'checkbox': true},
  Map requisitos = Map<String, Map<String, dynamic>>();
}

class SelecionarRequisitoPerguntaPageBlocEvent {}

class UpdatePerguntaIDSelecionarRequisitoPerguntaPageBlocEvent
    extends SelecionarRequisitoPerguntaPageBlocEvent {
  final String id;

  UpdatePerguntaIDSelecionarRequisitoPerguntaPageBlocEvent(this.id);
}

class UpdateRequisitosSelecionarRequisitoPerguntaPageBlocEvent
    extends SelecionarRequisitoPerguntaPageBlocEvent {}

class UpdateEixoIDSelecionarRequisitoPerguntaPageBlocEvent
    extends SelecionarRequisitoPerguntaPageBlocEvent {
  final String eixoID;

  UpdateEixoIDSelecionarRequisitoPerguntaPageBlocEvent(this.eixoID);
}

class UpdateListaRequisitosSelecionarRequisitoPerguntaPageBlocEvent
    extends SelecionarRequisitoPerguntaPageBlocEvent {
  final Map<String, Requisito> requisitos;

  UpdateListaRequisitosSelecionarRequisitoPerguntaPageBlocEvent(
      this.requisitos);
}

class IndexSelecionarRequisitoPerguntaPageBlocEvent
    extends SelecionarRequisitoPerguntaPageBlocEvent {
  final String index;
  final bool val;

  IndexSelecionarRequisitoPerguntaPageBlocEvent(this.index, this.val);
}

class SelecionarRequisitoPerguntaPageBloc {
  final fsw.Firestore _firestore;
  final EditarApagarPerguntaBloc perguntaBloc;
  final AuthBloc authBloc;

  final _state = SelecionarRequisitoPerguntaPageBlocState();

  final _inputController =
      BehaviorSubject<SelecionarRequisitoPerguntaPageBlocEvent>();

  Function get dispatch => _inputController.add;

  final _outputController =
      BehaviorSubject<SelecionarRequisitoPerguntaPageBlocState>();

  Stream<SelecionarRequisitoPerguntaPageBlocState> get state =>
      _outputController.stream;

  SelecionarRequisitoPerguntaPageBloc(
      this._firestore, this.authBloc, this.perguntaBloc) {
    _inputController.listen(_handleInput);

    perguntaBloc.state.listen((state) {
      dispatch(
          UpdatePerguntaIDSelecionarRequisitoPerguntaPageBlocEvent(state.id));
      dispatch(UpdateListaRequisitosSelecionarRequisitoPerguntaPageBlocEvent(
          state.requisitos));
    });

    authBloc.perfil.listen((perfil) {
      if (perfil.eixoIDAtual.id != null) {
        dispatch(UpdateEixoIDSelecionarRequisitoPerguntaPageBlocEvent(
            perfil.eixoIDAtual.id));
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
    if (event is UpdatePerguntaIDSelecionarRequisitoPerguntaPageBlocEvent) {
      _state.perguntaID = event.id;
    }

    if (event
        is UpdateListaRequisitosSelecionarRequisitoPerguntaPageBlocEvent) {
      final ref = _firestore.collection(PerguntaModel.collection);

      await ref.getDocuments().then((fsw.QuerySnapshot snap) {
        final perguntas = snap.documents.map((fsw.DocumentSnapshot doc) {
          return PerguntaModel(id: doc.documentID).fromMap(doc.data);
        }).toList();

        perguntas.forEach((PerguntaModel pergunta) {
          if (pergunta.id != _state.perguntaID) {
            final tipoEnum = PerguntaTipoModel.ENUM[pergunta.tipo.id];
            final contains = event.requisitos.containsKey(pergunta.id);
            _state.requisitos[pergunta.id] = {
              "pergunta": pergunta.titulo,
              "requisito": contains
                  ? event.requisitos[pergunta.id]
                  : Requisito(
                      referencia: pergunta.referencia,
                      perguntaTipo: pergunta.tipo.id,
                      perguntaID: null,
                    ),
              "checkbox": contains,
            };

            if (tipoEnum == PerguntaTipoEnum.EscolhaUnica ||
                tipoEnum == PerguntaTipoEnum.EscolhaMultipla) {
              pergunta.escolhas.forEach((k, v) {
                final requisitoKey = "${pergunta.id}$k";
                final contains = event.requisitos.containsKey(requisitoKey);
                final requisito = contains
                    ? event.requisitos[requisitoKey]
                    : Requisito(
                        referencia: pergunta.referencia,
                        perguntaTipo: pergunta.tipo.id,
                        perguntaID: null,
                        escolha: EscolhaRequisito(id: k, marcada: false),
                      );
                _state.requisitos[requisitoKey] = {
                  "pergunta": "${pergunta.titulo}/${v.texto}",
                  "requisito": requisito,
                  "checkbox": contains,
                };
              });
            }
          }
        });
      });
    }
    if (event is IndexSelecionarRequisitoPerguntaPageBlocEvent) {
      _state.requisitos[event.index]["checkbox"] = event.val;
    }

    if (event is UpdateRequisitosSelecionarRequisitoPerguntaPageBlocEvent) {
      perguntaBloc.dispatch(
          UpdateRequisitosEditarApagarPerguntaBlocEvent(_state.requisitos));
    }
    _outputController.add(_state);
  }
}
