import 'package:pmsbmibile3/models/setor_censitario_painel_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:rxdart/rxdart.dart';

class PainelListBlocEvent {}

class UpdateUsuarioIDEvent extends PainelListBlocEvent {
  final UsuarioModel usuarioID;

  UpdateUsuarioIDEvent(this.usuarioID);
}

class PainelListBlocState {
  UsuarioModel usuarioID;
    bool isDataValid = false;
  List<SetorCensitarioPainelModel> setorCensitarioPainelList =
      List<SetorCensitarioPainelModel>();
}



class PainelListBloc {
  //Firestore
  final fsw.Firestore _firestore;
  final _authBloc;

  //Eventos
  final _eventController = BehaviorSubject<PainelListBlocEvent>();
  Stream<PainelListBlocEvent> get eventStream =>
      _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final PainelListBlocState _state = PainelListBlocState();
  final _stateController = BehaviorSubject<PainelListBlocState>();
  Stream<PainelListBlocState> get stateStream =>
      _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  //Bloc
  PainelListBloc(this._firestore, this._authBloc) {
    eventStream.listen(_mapEventToState);
    _authBloc.perfil.listen((usuarioID) {
      eventSink(UpdateUsuarioIDEvent(usuarioID));
    });
  }

  void dispose() async {
    await _stateController.drain();
    _stateController.close();
    await _eventController.drain();
    _eventController.close();
  }

  _validateData() {
    _state.isDataValid=false;
        if (_state.setorCensitarioPainelList != null) {
      _state.isDataValid = true;
    } else {
      _state.isDataValid = false;
    }
  }

  _mapEventToState(PainelListBlocEvent event) async {
    if (event is UpdateUsuarioIDEvent) {
      //Atualiza estado com usuario logado
      _state.usuarioID = event.usuarioID;

      _state.setorCensitarioPainelList.clear();
      
      final streamDocsRemetente = _firestore
          .collection(SetorCensitarioPainelModel.collection)
          .where("setorCensitarioID.id", isEqualTo: _state.usuarioID.setorCensitarioID.id)
          .snapshots();

      final snapListRemetente = streamDocsRemetente.map((snapDocs) => snapDocs
          .documents
          .map((doc) =>
              SetorCensitarioPainelModel(id: doc.documentID).fromMap(doc.data))
          .toList());

      snapListRemetente.listen((List<SetorCensitarioPainelModel> setorCensitarioPainelList) {
        if (setorCensitarioPainelList.length > 1) {
          setorCensitarioPainelList
              .sort((a, b) => a.painelID.nome.compareTo(b.painelID.nome));
        }
        _state.setorCensitarioPainelList = setorCensitarioPainelList;
        if (!_stateController.isClosed) _stateController.add(_state);
      });

    }

    _validateData();
    if (!_stateController.isClosed) _stateController.add(_state);
    print(
        'event.runtimeType em PainelListBloc  = ${event.runtimeType}');
  }
}
