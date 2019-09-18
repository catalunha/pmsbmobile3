import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:pmsbmibile3/models/controle_tarefa_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:rxdart/rxdart.dart';

class ControleTarefaListBlocEvent {}

class UpdateTarefaUsuarioIDEvent extends ControleTarefaListBlocEvent {
  final UsuarioModel usuarioID;

  UpdateTarefaUsuarioIDEvent(this.usuarioID);
}

class ControleTarefaListBlocState {
  UsuarioModel usuarioID;
  List<ControleTarefaModel> controleTarefaListDestinatario =
      List<ControleTarefaModel>();
  List<ControleTarefaModel> controleTarefaListRemetente =
      List<ControleTarefaModel>();
  bool isDataValidDestinatario;
  bool isDataValidRemetente;
}

class ControleTarefaListBloc {
  //Firestore
  final fsw.Firestore _firestore;
  final _authBloc;

  //Eventos
  final _eventController = BehaviorSubject<ControleTarefaListBlocEvent>();
  Stream<ControleTarefaListBlocEvent> get eventStream =>
      _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final ControleTarefaListBlocState _state = ControleTarefaListBlocState();
  final _stateController = BehaviorSubject<ControleTarefaListBlocState>();
  Stream<ControleTarefaListBlocState> get stateStream =>
      _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  //Bloc
  ControleTarefaListBloc(this._firestore, this._authBloc) {
    eventStream.listen(_mapEventToState);
    _authBloc.perfil.listen((usuarioID) {
      eventSink(UpdateTarefaUsuarioIDEvent(usuarioID));
    });
  }

  void dispose() async {
    await _stateController.drain();
    _stateController.close();
    await _eventController.drain();
    _eventController.close();
  }

  _validateDataDestinatario() {
    if (_state.controleTarefaListDestinatario != null) {
      _state.isDataValidDestinatario = true;
    } else {
      _state.isDataValidDestinatario = false;
    }

  }
  _validateDataRemetente() {
    if (_state.controleTarefaListRemetente != null) {
      _state.isDataValidRemetente = true;
    } else {
      _state.isDataValidRemetente = false;
    }

  }
  _mapEventToState(ControleTarefaListBlocEvent event) async {
    if (event is UpdateTarefaUsuarioIDEvent) {
      //Atualiza estado com usuario logado
      _state.usuarioID = event.usuarioID;

      _state.controleTarefaListRemetente.clear();
      // le todas as tarefas deste usuario como remetente/designadas neste setor.
      final streamDocsRemetente = _firestore
          .collection(ControleTarefaModel.collection)
          .where("remetente.id", isEqualTo: _state.usuarioID.id)
          .where("setor.id", isEqualTo: _state.usuarioID.setorCensitarioID.id)
          .where("concluida", isEqualTo: false)
          .snapshots();

      final snapListRemetente = streamDocsRemetente.map((snapDocs) => snapDocs
          .documents
          .map((doc) =>
              ControleTarefaModel(id: doc.documentID).fromMap(doc.data))
          .toList());

      snapListRemetente.listen((List<ControleTarefaModel> controleTarefaList) {
        _state.controleTarefaListRemetente = controleTarefaList;
      });

      _state.controleTarefaListDestinatario.clear();
      // le todas as tarefas deste usuario como destinatario/recebida neste setor.
      final streamDocsDestinatario = _firestore
          .collection(ControleTarefaModel.collection)
          .where("destinatario.id", isEqualTo: _state.usuarioID.id)
          .where("setor.id", isEqualTo: _state.usuarioID.setorCensitarioID.id)
          .where("concluida", isEqualTo: false)
          .snapshots();

      final snapListDestinatario = streamDocsDestinatario.map((snapDocs) =>
          snapDocs
              .documents
              .map((doc) =>
                  ControleTarefaModel(id: doc.documentID).fromMap(doc.data))
              .toList());

      snapListDestinatario
          .listen((List<ControleTarefaModel> controleTarefaList) {
        _state.controleTarefaListDestinatario = controleTarefaList;
      });
    }
    _validateDataDestinatario();
    _validateDataRemetente();
    if (!_stateController.isClosed) _stateController.add(_state);
    print(
        'event.runtimeType em ControleTarefaListBloc  = ${event.runtimeType}');
  }
}
