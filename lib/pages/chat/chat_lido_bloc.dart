import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;
import 'package:pmsbmibile3/models/chat_mensagem_model.dart';
import 'package:pmsbmibile3/models/chat_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:rxdart/rxdart.dart';

class ChatLidoPageState {
  // // objetos
  // UsuarioModel usuarioModel;

  // Estados de entrada
  String chatID;
  Map<String, UsuarioChat> usuario = Map<String, UsuarioChat>();

  @override
  String toString() {
    // TODO: implement toString
    return '${usuario.toString()}';
  }
}

class ChatLidoPageBloc {
  //Firestore
  final fw.Firestore _firestore;

  // Authenticacação
  // AuthBloc _authBloc;

  //Eventos
  final _eventController = BehaviorSubject<ChatLidoPageEvent>();
  Stream<ChatLidoPageEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final ChatLidoPageState _state = ChatLidoPageState();
  final _stateController = BehaviorSubject<ChatLidoPageState>();
  Stream<ChatLidoPageState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  // //Stream para ChatMensagem
  // final chatMensagemListController = BehaviorSubject<List<ChatMensagemModel>>();
  // Stream<List<ChatMensagemModel>> get chatMensagemListStream =>
  //     chatMensagemListController.stream;
  // Function get chatMensagemListSink => chatMensagemListController.sink.add;

  // ChatLidoPageBloc(this._firestore, this._authBloc) {
  ChatLidoPageBloc(this._firestore) {
    eventStream.listen(_mapEventToState);
  }
  void dispose() {
    _stateController.close();
    _eventController.close();
    // chatMensagemListController.close();
  }

  _mapEventToState(ChatLidoPageEvent event) async {
    if (event is UpdateChatIDEvent) {
      _state.chatID = event.chatID;
      print(event.chatID);
      // _state.modulo = event.modulo;
      // _state.titulo = event.titulo;

      // _authBloc.perfil.listen((usuario) async {
      //   _state.usuarioModel = usuario;

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

    if (!_stateController.isClosed) _stateController.add(_state);
    // print('_state.toString()  = ${_state.toString()}');
    print('event.runtimeType em ChatLidoPageBloc  = ${event.runtimeType}');
  }
}

class ChatLidoPageEvent {}

class UpdateChatIDEvent extends ChatLidoPageEvent {
  final String chatID;

  UpdateChatIDEvent({this.chatID});
}
