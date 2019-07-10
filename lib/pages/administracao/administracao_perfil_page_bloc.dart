import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pmsbmibile3/models/variavel_usuario_model.dart';
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

  // VariavelUsuarioModel
  final _variavelUsuarioModelController =
      BehaviorSubject<List<VariavelUsuarioModel>>();

  Stream<List<VariavelUsuarioModel>> get variavelUsuarioModelStream =>
      _variavelUsuarioModelController.stream;

  Function get variavelUsuarioModelDispatch =>
      _variavelUsuarioModelController.sink.add;

  //Construtor da classe
  AdministracaoPerfilPageBloc(this._firestore) {
    administracaoPerfilPageEventStream.listen(_mapEventToState);
  }

  void dispose() {
    _usuarioModelController.close();
    _administracaoPerfilPageEventController.close();
    _variavelUsuarioModelController.close();
  }

  void _mapEventToState(AdministracaoPerfilPageEvent event) {
    if (event is UpdateUsuarioIdEvent) {
      currentState.usuarioId = event.usuarioId;
      //perfil usuario
      _firestore
          .collection(UsuarioModel.collection)
          .document(event.usuarioId)
          .snapshots()
          .map((snap) => UsuarioModel(id: snap.documentID).fromMap(snap.data))
          .listen((usuario) {
        usuarioModelSink(usuario);
      });

      //variaveis usuario
      _firestore
          .collection(VariavelUsuarioModel.collection)
          .where("userId", isEqualTo: event.usuarioId)
          .snapshots()
          .map((snapDocs) => snapDocs.documents
              .map((doc) => VariavelUsuarioModel.fromMap(doc.data))
              .toList())
          .listen((List<VariavelUsuarioModel> variavelUsuarioModelList) {
        variavelUsuarioModelDispatch(variavelUsuarioModelList);
      });
    }
  }
}
