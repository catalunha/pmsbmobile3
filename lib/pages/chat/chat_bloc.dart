import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;
import 'package:pmsbmibile3/models/chat_mensagem_model.dart';
import 'package:pmsbmibile3/models/chat_model.dart';
import 'package:pmsbmibile3/models/chat_notificacao_model.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';
import 'package:rxdart/rxdart.dart';

class Alerta {
  final UsuarioModel usuarioModel;
  final bool alerta;

  Alerta(this.usuarioModel, this.alerta);
}

class ChatPageState {
  // objetos
  UsuarioModel usuarioModel;

  // Estados de entrada
  String chatID;
  String modulo;
  String titulo;

  // Estados secundarios
  String msgToSend;
  Map<String, UsuarioChat> usuario = Map<String, UsuarioChat>();
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
  final _stateController = BehaviorSubject<ChatPageState>();
  Stream<ChatPageState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  //Stream para ChatMensagem
  final chatMensagemListController = BehaviorSubject<List<ChatMensagemModel>>();
  Stream<List<ChatMensagemModel>> get chatMensagemListStream =>
      chatMensagemListController.stream;
  Function get chatMensagemListSink => chatMensagemListController.sink.add;

  ChatPageBloc(this._firestore, this._authBloc) {
    eventStream.listen(_mapEventToState);
  }
  void dispose() async {
    await _stateController.drain();
    _stateController.close();
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
        final chatStreamDocSnapshot = chatDocRef.snapshots();

        chatStreamDocSnapshot.listen((snapDocs) {
          Map<dynamic, dynamic> usuarios = snapDocs.data['usuario'];
          for (var item in usuarios.entries) {
            state.usuario[item.key] = UsuarioChat.fromMap(item.value);
          }
          if (!_stateController.isClosed) _stateController.add(state);
        });
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
            '${state.usuarioModel.id}':
                UsuarioChat(id: true, nome: state.usuarioModel.nome, lido: true)
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

      final snapList = collectionRef
          .snapshots()
          .map((querySnapshot) => querySnapshot.documents
              .map((docSnap) => ChatMensagemModel(id: docSnap.documentID)
                  .fromMap(docSnap.data))
              .toList())
          .pipe(chatMensagemListController);

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
        final chatMsgDocRef = _firestore
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
        List<String> usuarioListAlertar = List<String>();
        for (var item in state.usuario.entries) {
          if (state.usuario[item.key].alertar == true) {
            usuarioListAlertar.add(item.key);
          }
          state.usuario[item.key].alertar = false;
        }
        if (usuarioListAlertar.isNotEmpty) {
          final chatNotificacaoDocRef = _firestore
              .collection(ChatModel.collection)
              .document(state.chatID)
              .collection(ChatModel.subcollectionNotificacao)
              .document();
          ChatNotificacaoModel chatNotificacaoModel = ChatNotificacaoModel(
            titulo: state.modulo,
            texto: '${state.titulo}\n${state.msgToSend}',
            usuario: usuarioListAlertar,
          );
          await chatNotificacaoDocRef.setData(chatNotificacaoModel.toMap(), merge: true);
        }
        print('>>> usuarioListAlertar <<< ${usuarioListAlertar}');
      }
      state.msgToSend = null;
    }

    if (event is UpDateAlertaEvent) {
      // print('>>> event.usuarioChatID <<< ${event.usuarioChatID}');
      // print('>>> event.alertar <<< ${event.alertar}');
      state.usuario[event.usuarioChatID].alertar = event.alertar;
    }
    if (event is UpDateAlertarTodosEvent) {
      if (event.alertar == true) {
        for (var item in state.usuario.entries) {
          state.usuario[item.key].alertar = true;
        }
      }
      if (event.alertar == false) {
        for (var item in state.usuario.entries) {
          state.usuario[item.key].alertar = false;
        }
      }
      if (event.alertar == null) {
        for (var item in state.usuario.entries) {
          state.usuario[item.key].alertar = !state.usuario[item.key].alertar;
        }
      }
    }

    if (!_stateController.isClosed) _stateController.add(state);
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

class UpDateAlertaEvent extends ChatPageEvent {
  final String usuarioChatID;
  final bool alertar;

  UpDateAlertaEvent({this.usuarioChatID, this.alertar});
}

class UpDateAlertarTodosEvent extends ChatPageEvent {
  final bool alertar;

  UpDateAlertarTodosEvent(this.alertar);
}

class SendMsgEvent extends ChatPageEvent {}
