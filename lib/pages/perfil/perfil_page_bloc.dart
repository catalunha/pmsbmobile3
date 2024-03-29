import 'dart:async';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/usuario_perfil_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

class PerfilPageEvent {}

class UpDateUsuarioIDEvent extends PerfilPageEvent {
  final String usuarioID;

  UpDateUsuarioIDEvent({this.usuarioID});
}

class PerfilPageState {
  String usuarioID;
}

class PerfilPageBloc {
  /// Database
  final fsw.Firestore _firestore;
  /// Autenticacao
  final _authBloc =
      Bootstrap.instance.authBloc;

  /// Eventos
  final _perfilPageEventController = BehaviorSubject<PerfilPageEvent>();
  Stream<PerfilPageEvent> get perfilPageEventStream =>
      _perfilPageEventController.stream;
  Function get perfilPageEventSink => _perfilPageEventController.sink.add;

  /// Estados
  PerfilPageState perfilPageState = PerfilPageState();

  /// UsuarioPerfilModel
  final _usuarioPerfilModelListController =
      BehaviorSubject<List<UsuarioPerfilModel>>();
  Stream<List<UsuarioPerfilModel>> get usuarioPerfilModelListStream =>
      _usuarioPerfilModelListController.stream;
  Function get usuarioPerfilModelListSink =>
      _usuarioPerfilModelListController.sink.add;

  PerfilPageBloc(this._firestore) {
    perfilPageEventStream.listen(_mapEventToState);
    _authBloc.userId.listen((userId) =>
        perfilPageEventSink(UpDateUsuarioIDEvent(usuarioID: userId)));
  }

  void dispose() async {
    _authBloc.dispose();
    await _perfilPageEventController.drain();
    _perfilPageEventController.close();
    await _usuarioPerfilModelListController.drain();
    _usuarioPerfilModelListController.close();
  }

  _mapEventToState(PerfilPageEvent event) {
    if (event is UpDateUsuarioIDEvent) {
      _firestore
          .collection(UsuarioPerfilModel.collection)
          .where("usuarioID.id", isEqualTo: event.usuarioID)
          .snapshots()
          .map((snapDocs) => snapDocs.documents
              .map((doc) =>
                  UsuarioPerfilModel(id: doc.documentID).fromMap(doc.data))
              .toList())
          .pipe(_usuarioPerfilModelListController);


    }
    print('event.runtimeType em PerfilPageBloc  = ${event.runtimeType}');
  }
}
