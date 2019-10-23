import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/chat_model.dart';
import 'package:rxdart/rxdart.dart';

class ChatLidoPageState {
  String chatID;
  Map<String, UsuarioChat> usuario = Map<String, UsuarioChat>();

  @override
  String toString() {
    // TODO: implement toString
    return '${usuario.toString()}';
  }
}

class ChatLidoPageBloc {
  /// Firestore
  final fw.Firestore _firestore;

  /// Eventos
  final _eventController = BehaviorSubject<ChatLidoPageEvent>();
  Stream<ChatLidoPageEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  /// Estados
  final ChatLidoPageState _state = ChatLidoPageState();
  final _stateController = BehaviorSubject<ChatLidoPageState>();
  Stream<ChatLidoPageState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  ChatLidoPageBloc(this._firestore) {
    eventStream.listen(_mapEventToState);
  }
  void dispose() async {
    await _stateController.drain();
    _stateController.close();
    await _eventController.drain();
    _eventController.close();
  }

  _mapEventToState(ChatLidoPageEvent event) async {
    if (event is UpdateChatIDEvent) {
      _state.chatID = event.chatID;

      final chatDocRef =
          _firestore.collection(ChatModel.collection).document(_state.chatID);
      final chatStreamDocSnapshot = chatDocRef.snapshots();

      chatStreamDocSnapshot.listen((snapDocs) {
        Map<dynamic, dynamic> usuarios = snapDocs.data['usuario'];
        for (var item in usuarios.entries) {
          _state.usuario[item.key] = UsuarioChat.fromMap(item.value);
        }
        if (!_stateController.isClosed) _stateController.add(_state);
      });
    }

    if (event is DeleteUsuarioEvent) {
      final docRef =
          _firestore.collection(ChatModel.collection).document(_state.chatID);
      docRef.setData({
        "usuario": {event.usuarioID: Bootstrap.instance.fieldValue.delete()},
      }, merge: true);
    }
    if (!_stateController.isClosed) _stateController.add(_state);
    print('event.runtimeType em ChatLidoPageBloc  = ${event.runtimeType}');
  }
}

class ChatLidoPageEvent {}

class UpdateChatIDEvent extends ChatLidoPageEvent {
  final String chatID;

  UpdateChatIDEvent({this.chatID});
}

class DeleteUsuarioEvent extends ChatLidoPageEvent {
  final String usuarioID;

  DeleteUsuarioEvent(this.usuarioID);
}
