import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:rxdart/rxdart.dart';

class GeralBlocEvent {}

class GetUsuarioIDEvent extends GeralBlocEvent {
  final UsuarioModel usuarioID;

  GetUsuarioIDEvent(this.usuarioID);
}

class GeralBlocState {
  bool isDataValid = false;

  UsuarioModel usuarioID;
}

class GeralBloc {
  final _authBloc;

  /// Eventos
  final _eventController = BehaviorSubject<GeralBlocEvent>();
  Stream<GeralBlocEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  /// Estados
  final GeralBlocState _state = GeralBlocState();
  final _stateController = BehaviorSubject<GeralBlocState>();
  Stream<GeralBlocState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  /// Bloc
  GeralBloc(
    this._authBloc
  ) {
    eventStream.listen(_mapEventToState);
    _authBloc.perfil.listen((usuarioID) {
      eventSink(GetUsuarioIDEvent(usuarioID));
    });
  }

  void dispose() async {
    await _stateController.drain();
    _stateController.close();
    await _eventController.drain();
    _eventController.close();
  }

  _validateData() {
    _state.isDataValid = false;
    if (_state?.usuarioID != null) {
      _state.isDataValid = true;
    }
  }

  _mapEventToState(GeralBlocEvent event) async {
    if (event is GetUsuarioIDEvent) {
      _state.usuarioID = event.usuarioID;
    }

    _validateData();
    if (!_stateController.isClosed) _stateController.add(_state);
    print('event.runtimeType em GeralBloc  = ${event.runtimeType}');
  }
}
