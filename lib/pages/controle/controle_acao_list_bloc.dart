import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:pmsbmibile3/models/controle_acao_model.dart';
import 'package:pmsbmibile3/models/controle_tarefa_model.dart';
import 'package:rxdart/rxdart.dart';

class ControleAcaoListBlocEvent {}

class UpdateTarefaIDEvent extends ControleAcaoListBlocEvent {
  final String controleTarefaID;

  UpdateTarefaIDEvent(this.controleTarefaID);
}

class OrdenarAcaoEvent extends ControleAcaoListBlocEvent {
  final ControleAcaoModel acao;
  final bool up;

  OrdenarAcaoEvent(this.acao, this.up);
}

class ControleAcaoListBlocState {
  ControleTarefaModel controleTarefaID = ControleTarefaModel();
  List<ControleAcaoModel> controleAcaoList = List<ControleAcaoModel>();
  bool isDataValid;
}

class ControleAcaoListBloc {
  //Firestore
  final fsw.Firestore _firestore;
  // final _authBloc;

  //Eventos
  final _eventController = BehaviorSubject<ControleAcaoListBlocEvent>();
  Stream<ControleAcaoListBlocEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final ControleAcaoListBlocState _state = ControleAcaoListBlocState();
  final _stateController = BehaviorSubject<ControleAcaoListBlocState>();
  Stream<ControleAcaoListBlocState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  //Bloc
  ControleAcaoListBloc(this._firestore) {
    eventStream.listen(_mapEventToState);
  }

  void dispose() async {
    await _stateController.drain();
    _stateController.close();
    await _eventController.drain();
    _eventController.close();
  }

  _validateData() {
    if (_state.controleTarefaID != null) {
      _state.isDataValid = true;
    } else {
      _state.isDataValid = false;
    }
    if (_state.controleAcaoList != null) {
      _state.isDataValid = true;
    } else {
      _state.isDataValid = false;
    }
  }

  _mapEventToState(ControleAcaoListBlocEvent event) async {
    if (event is UpdateTarefaIDEvent) {
      //Atualiza estado com usuario logado
      // le todas as tarefas deste usuario como remetente/designadas neste setor.
      final docRef = _firestore
          .collection(ControleTarefaModel.collection)
          .document(event.controleTarefaID);
      final snap = await docRef.get();
      if (snap.exists) {
        _state.controleTarefaID =
            ControleTarefaModel(id: snap.documentID).fromMap(snap.data);
      }

      _state.controleAcaoList.clear();
      // le todas as tarefas deste usuario como remetente/designadas neste setor.
      final streamDocsRemetente = _firestore
          .collection(ControleAcaoModel.collection)
          .where("tarefa.id", isEqualTo: event.controleTarefaID)
          .snapshots();

      final snapListRemetente = streamDocsRemetente.map((snapDocs) => snapDocs
          .documents
          .map((doc) => ControleAcaoModel(id: doc.documentID).fromMap(doc.data))
          .toList());

      snapListRemetente.listen((List<ControleAcaoModel> controleAcaoList) {
        if (controleAcaoList.length > 1) {
          controleAcaoList
              .sort((a, b) => a.numeroCriacao.compareTo(b.numeroCriacao));
        }
        _state.controleAcaoList = controleAcaoList;

        if (!_stateController.isClosed) _stateController.add(_state);
      });
    }
    if (event is OrdenarAcaoEvent) {
      final ordemOrigem = _state.controleAcaoList.indexOf(event.acao);
      final ordemOutro = event.up ? ordemOrigem - 1 : ordemOrigem + 1;
      final numeroCriacaoOrigem =
          _state.controleAcaoList[ordemOrigem].numeroCriacao;
      final numeroCriacaoOutro =
          _state.controleAcaoList[ordemOutro].numeroCriacao;

      final docRefOrigem = _firestore
          .collection(ControleAcaoModel.collection)
          .document(_state.controleAcaoList[ordemOrigem].id);

      docRefOrigem.setData({"numeroCriacao": numeroCriacaoOutro}, merge: true);

      final docRefOutro = _firestore
          .collection(ControleAcaoModel.collection)
          .document(_state.controleAcaoList[ordemOutro].id);

      docRefOutro.setData({"numeroCriacao": numeroCriacaoOrigem}, merge: true);
    }

    _validateData();
    // print(_state.controleAcaoList.toString());
    if (!_stateController.isClosed) _stateController.add(_state);
    print(
        'event.runtimeType em ControleTarefaDestinatarioAcaoMarcarBloc  = ${event.runtimeType}');
  }
}
