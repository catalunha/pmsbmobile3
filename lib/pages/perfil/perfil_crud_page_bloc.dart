import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:pmsbmibile3/models/usuario_perfil_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

class PerfilCRUDPageEvent {}

class UpDateUsuarioPerfilIDEvent extends PerfilCRUDPageEvent {
  final String usuarioPerfilID;

  UpDateUsuarioPerfilIDEvent(this.usuarioPerfilID);
}

class UpDateTextPlainEvent extends PerfilCRUDPageEvent {
  final String textPlain;

  UpDateTextPlainEvent(this.textPlain);
}

class SaveStateToFirebaseEvent extends PerfilCRUDPageEvent {}

class PerfilCRUDPageState {
  String textPlain;
  String usuarioPerfilID;
}

class PerfilCRUDPageBloc {
  ///  Database
  final fsw.Firestore _firestore;

  /// Estado
  PerfilCRUDPageState perfilCRUDPageState = PerfilCRUDPageState();

  /// Eventos
  final _perfilCRUDPageEventController = BehaviorSubject<PerfilCRUDPageEvent>();
  Function get perfilCRUDPageEventSink =>
      _perfilCRUDPageEventController.sink.add;
  Stream<PerfilCRUDPageEvent> get perfilCRUDPageEventStream =>
      _perfilCRUDPageEventController.stream;

  /// UsuarioPerfilModel
  final _usuarioPerfilModelController = BehaviorSubject<UsuarioPerfilModel>();
  Stream<UsuarioPerfilModel> get usuarioPerfilModelStream =>
      _usuarioPerfilModelController.stream;

  PerfilCRUDPageBloc(this._firestore) {
    perfilCRUDPageEventStream.listen(_mapEventToState);
  }

  void dispose() async {
    await _usuarioPerfilModelController.drain();
    _usuarioPerfilModelController.close();
    await _perfilCRUDPageEventController.drain();
    _perfilCRUDPageEventController.close();
  }

  void _mapEventToState(PerfilCRUDPageEvent event) {
    if (event is UpDateUsuarioPerfilIDEvent) {
      perfilCRUDPageState.usuarioPerfilID = event.usuarioPerfilID;
      _firestore
          .collection(UsuarioPerfilModel.collection)
          .document(event.usuarioPerfilID)
          .snapshots()
          .map((snapDocs) => UsuarioPerfilModel(id: snapDocs.documentID)
              .fromMap(snapDocs.data))
          .pipe(_usuarioPerfilModelController);
      usuarioPerfilModelStream.listen((usuarioPerfilModel) {
        perfilCRUDPageState.textPlain = usuarioPerfilModel.textPlain;
      });
    }

    if (event is UpDateTextPlainEvent) {
    }
    if (event is SaveStateToFirebaseEvent) {
      _firestore
          .collection(UsuarioPerfilModel.collection)
          .document(perfilCRUDPageState.usuarioPerfilID)
          .setData({"textPlain": perfilCRUDPageState.textPlain}, merge: true);
    }
  }
}
