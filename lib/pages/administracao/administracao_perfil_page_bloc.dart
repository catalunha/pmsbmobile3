import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pmsbmibile3/models/usuario_perfil_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;

class AdministracaoPerfilPageEvent {}

class UpdateUsuarioIdEvent extends AdministracaoPerfilPageEvent {
  final String usuarioId;

  UpdateUsuarioIdEvent(this.usuarioId);
}

class AdministracaoPerfilPageState {
  String usuarioId;
}

class AdministracaoPerfilPageBloc {
  final fw.Firestore _firestore;

  // Estados da Página
  final AdministracaoPerfilPageState currentState =
      AdministracaoPerfilPageState();

  // Eventos da Página
  final _administracaoPerfilPageEventController =
      BehaviorSubject<AdministracaoPerfilPageEvent>();

  Stream<AdministracaoPerfilPageEvent> get administracaoPerfilPageEventStream =>
      _administracaoPerfilPageEventController.stream;

  Function get administracaoPerfilPageEventSink =>
      _administracaoPerfilPageEventController.sink.add;

  // UsuarioModel
  final _usuarioModelController = BehaviorSubject<UsuarioModel>();

  Stream<UsuarioModel> get usuarioModelStream => _usuarioModelController.stream;

  Function get usuarioModelSink => _usuarioModelController.sink.add;

  // UsuarioPerfil
  final _usuarioPerfilModelController =
      BehaviorSubject<List<UsuarioPerfil>>();

  Stream<List<UsuarioPerfil>> get usuarioPerfilModelStream =>
      _usuarioPerfilModelController.stream;

  Function get usuarioPerfilModelSink =>
      _usuarioPerfilModelController.sink.add;

  //Construtor da classe
  AdministracaoPerfilPageBloc(this._firestore) {
    administracaoPerfilPageEventStream.listen(_mapEventToState);
  }

  void dispose() {
    _usuarioModelController.close();
    _administracaoPerfilPageEventController.close();
    _usuarioPerfilModelController.close();
  }

  void _mapEventToState(AdministracaoPerfilPageEvent event) {
    if (event is UpdateUsuarioIdEvent) {
      // Atualizar State with Event
      currentState.usuarioId = event.usuarioId;
      //Usar State UsuarioModel
      _firestore
          .collection(UsuarioModel.collection)
          .document(currentState.usuarioId)
          .snapshots()
          .map((snap) => UsuarioModel(id: snap.documentID).fromMap(snap.data))
          .listen((usuario) {
        usuarioModelSink(usuario);
      });

      //Usar State UsuarioPerfil
      _firestore
          .collection(UsuarioPerfil.collection)
          .where("usuarioID", isEqualTo: currentState.usuarioId)
          .snapshots()
          .map((snapDocs) => snapDocs.documents
              .map((doc) => UsuarioPerfil(id: doc.documentID).fromMap(doc.data))
              .toList())
          .listen((List<UsuarioPerfil> usuarioPerfilModelList) {
        usuarioPerfilModelSink(usuarioPerfilModelList);
      });
    }
  }
}
