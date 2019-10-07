import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/controle_tarefa_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:rxdart/rxdart.dart';

class ControleTarefaConcluidaListBlocEvent {}

class UpdateTarefaUsuarioIDEvent extends ControleTarefaConcluidaListBlocEvent {
  final UsuarioModel usuarioID;

  UpdateTarefaUsuarioIDEvent(this.usuarioID);
}
class AtivarTarefaIDEvent extends ControleTarefaConcluidaListBlocEvent {
  final String tarefaID;

  AtivarTarefaIDEvent(this.tarefaID);
}

class ControleTarefaConcluidaListBlocState {
  UsuarioModel usuarioID;
  List<ControleTarefaModel> controleTarefaListDestinatario =
      List<ControleTarefaModel>();
  List<ControleTarefaModel> controleTarefaListRemetente =
      List<ControleTarefaModel>();
  bool isDataValidDestinatario;
  bool isDataValidRemetente;
}

class ControleTarefaConcluidaListBloc {
  //Firestore
  final fsw.Firestore _firestore;
  final _authBloc;

  //Eventos
  final _eventController = BehaviorSubject<ControleTarefaConcluidaListBlocEvent>();
  Stream<ControleTarefaConcluidaListBlocEvent> get eventStream =>
      _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final ControleTarefaConcluidaListBlocState _state = ControleTarefaConcluidaListBlocState();
  final _stateController = BehaviorSubject<ControleTarefaConcluidaListBlocState>();
  Stream<ControleTarefaConcluidaListBlocState> get stateStream =>
      _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  //Bloc
  ControleTarefaConcluidaListBloc(this._firestore, this._authBloc) {
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

  _mapEventToState(ControleTarefaConcluidaListBlocEvent event) async {
    if (event is UpdateTarefaUsuarioIDEvent) {
      //Atualiza estado com usuario logado
      _state.usuarioID = event.usuarioID;

      _state.controleTarefaListRemetente.clear();
      // le todas as tarefas deste usuario como remetente/designadas neste setor.
      final streamDocsRemetente = _firestore
          .collection(ControleTarefaModel.collection)
          .where("remetente.id", isEqualTo: _state.usuarioID.id)
          .where("setor.id", isEqualTo: _state.usuarioID.setorCensitarioID.id)
          .where("concluida", isEqualTo: true)
          .snapshots();

      final snapListRemetente = streamDocsRemetente.map((snapDocs) => snapDocs
          .documents
          .map((doc) =>
              ControleTarefaModel(id: doc.documentID).fromMap(doc.data))
          .toList());

      snapListRemetente.listen((List<ControleTarefaModel> controleTarefaList) {
        _state.controleTarefaListRemetente = controleTarefaList;
        if (!_stateController.isClosed) _stateController.add(_state);
      });

      _state.controleTarefaListDestinatario.clear();
      // le todas as tarefas deste usuario como destinatario/recebida neste setor.
      final streamDocsDestinatario = _firestore
          .collection(ControleTarefaModel.collection)
          .where("destinatario.id", isEqualTo: _state.usuarioID.id)
          .where("setor.id", isEqualTo: _state.usuarioID.setorCensitarioID.id)
          .where("concluida", isEqualTo: true)
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
    if (event is AtivarTarefaIDEvent) {
            final ref3 = _firestore
          .collection(ControleTarefaModel.collection)
          .document(event.tarefaID);
        await ref3.setData({
          'concluida': false,
          'modificada': Bootstrap.instance.fieldValue.serverTimestamp()
        }, merge: true);
      
    }
    
    _validateDataDestinatario();
    _validateDataRemetente();
    if (!_stateController.isClosed) _stateController.add(_state);
    print(
        'event.runtimeType em ControleTarefaConcluidaListBloc  = ${event.runtimeType}');
  }
}
