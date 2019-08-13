import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;
import 'package:pmsbmibile3/models/chat_mensagem_model.dart';
import 'package:pmsbmibile3/models/chat_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:rxdart/rxdart.dart';

class ChatPageState {
  // objetos
  UsuarioModel usuarioModel;

  // Estados de entrada
  String chatID;
  String modulo;
  String titulo;

  // Estados secundarios
  String msgToSend;
}

class ChatPageBloc {
  //Firestore
  final fw.Firestore _firestore;

  // Authenticacação
  AuthBloc _authBloc;

  //Eventos
  final _eventController = BehaviorSubject<ChatPageEvent>();
  Stream<ChatPageEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final ChatPageState state = ChatPageState();
  final stateController = BehaviorSubject<ChatPageState>();
  Stream<ChatPageState> get stateStream => stateController.stream;
  Function get stateSink => stateController.sink.add;

  //Stream para ChatMensagem
  final chatMensagemListController = BehaviorSubject<List<ChatMensagemModel>>();
  Stream<List<ChatMensagemModel>> get chatMensagemListStream =>
      chatMensagemListController.stream;
  Function get chatMensagemListSink => chatMensagemListController.sink.add;

  ChatPageBloc(this._firestore, this._authBloc) {
    eventStream.listen(_mapEventToState);
  }
  void dispose() async {
    await stateController.drain();
    stateController.close();
    await _eventController.drain();
    _eventController.close();
    await chatMensagemListController.drain();
    chatMensagemListController.close();
  }

  _mapEventToState(ChatPageEvent event) async {
    if (event is UpdateChatIDModuloTituloEvent) {
      state.chatID = event.chatID;
      state.modulo = event.modulo;
      state.titulo = event.titulo;

      _authBloc.perfil.listen((usuario) async {
        state.usuarioModel = usuario;

        final chatDocRef =
            _firestore.collection(ChatModel.collection).document(state.chatID);
        final chatDocSnapshot = await chatDocRef.get();
        // bool contemUsuario;
        // if (chatDocSnapshot.exists) {
        //   print('existe');
        //   Map<dynamic, dynamic> usuarios = chatDocSnapshot.data['usuario'];
        //   contemUsuario = usuarios.containsKey(state.usuarioModel.id);
        //   // ChatModel chatModel = ChatModel(
        //   //   id: state.chatID,
        //   //   usuario: {
        //   //     '${state.usuarioModel.id}': UsuarioChat(
        //   //         id: true, nome: state.usuarioModel.nome, lido: true)
        //   //   },
        //   // );
        //   // await chatDocRef.setData(chatModel.toMap(), merge: true);
        //   await chatDocRef.setData({
        //     "usuario": {
        //       '${state.usuarioModel.id}': {"lido": true}
        //     }
        //   }, merge: true);
        // }
        // if (!chatDocSnapshot.exists || !contemUsuario) {
        //   print('nao existe doc nem usuario. criando os dois');
        ChatModel chatModel = ChatModel(
          id: state.chatID,
          usuario: {
            '${state.usuarioModel.id}': UsuarioChat(
                id: true, nome: state.usuarioModel.nome, lido: true)
          },
        );
        await chatDocRef.setData(chatModel.toMap(), merge: true);
        // }
      });

      // le todas as msgs deste chat
      final collectionRef = _firestore
          .collection(ChatModel.collection)
          .document(state.chatID)
          // .document('0W7B2AScdpfjOSmdsNk3')
          .collection(ChatModel.subcollectionMensagem);

      final snapList = collectionRef.snapshots().map((querySnapshot) =>
          querySnapshot.documents
              .map((docSnap) => ChatMensagemModel(id: docSnap.documentID)
                  .fromMap(docSnap.data))
              .toList()).pipe(chatMensagemListController);

      // snapList.listen((List<ChatMensagemModel> chatMensagemModelList) {
      //   // print('chatMensagemModelList.length: ${chatMensagemModelList.length}');
      //   // for (var item in chatMensagemModelList) {
      //   //   print('Msg: ${item.id}');
      //   // }
      //   chatMensagemListSink(chatMensagemModelList);
      // });
    }
    if (event is UpDateMsgToSendEvent) {
      state.msgToSend = event.msgToSend;
      print(event.msgToSend);
    }

    if (event is SendMsgEvent) {
      print('Send: ${state.msgToSend}');
      if (state.msgToSend != null) {
        final chatMsgDocRef =
            _firestore
            .collection(ChatModel.collection)
            .document(state.chatID)
            .collection(ChatModel.subcollectionMensagem)
            .document();
        ChatMensagemModel chatMsgModel = ChatMensagemModel(
          autor: UsuarioID(
              id: state.usuarioModel.id, nome: state.usuarioModel.nome),
          texto: state.msgToSend,
        );
        await chatMsgDocRef.setData(chatMsgModel.toMap(), merge: true);
      }
      state.msgToSend = null;
    }

    if (!stateController.isClosed) stateController.add(state);
    print('event.runtimeType em ChatPageBloc  = ${event.runtimeType}');
  }
}

class ChatPageEvent {}

class UpdateChatIDModuloTituloEvent extends ChatPageEvent {
  final String chatID;
  final String modulo;
  final String titulo;

  UpdateChatIDModuloTituloEvent({this.chatID, this.modulo, this.titulo});
}

class UpDateMsgToSendEvent extends ChatPageEvent {
  final String msgToSend;

  UpDateMsgToSendEvent(this.msgToSend);
}

class SendMsgEvent extends ChatPageEvent {}
