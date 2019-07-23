import 'package:firebase_storage/firebase_storage.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;
import 'package:rxdart/rxdart.dart';

class PageEvent {}

class UpdateArquivoEvent extends PageEvent {
  final String arquivo;

  UpdateArquivoEvent(this.arquivo);
}

class SaveEvent extends PageEvent {}

class PageState {
  String arquivo;
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['arquivo'] = this.arquivo;
    return data;
  }
}

class DesenvolvimentoPageBloc {
  //Firestore
  final fw.Firestore _firestore;

  //Eventos
  final BehaviorSubject<PageEvent> _eventController =
      BehaviorSubject<PageEvent>();
  Stream<PageEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final PageState _state = PageState();
  final _stateController = BehaviorSubject<PageState>();
  Stream<PageState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  DesenvolvimentoPageBloc(this._firestore) {
    eventStream.listen(_mapEventToState);
  }
  _mapEventToState(PageEvent event) async {
    if (event is UpdateArquivoEvent) {
      _state.arquivo = event.arquivo;
    }
    if (event is SaveEvent) {
          print('>>> SaveEvent _state.toMap() <<< ${_state.toMap()}');
    }
    if (!_stateController.isClosed) _stateController.add(_state);
    print('>>> _state.toMap() <<< ${_state.toMap()}');
    print('>>> event.runtimeType <<< ${event.runtimeType}');
  }

  void dispose() {
    _stateController.close();
    _eventController.close();
  }
}
