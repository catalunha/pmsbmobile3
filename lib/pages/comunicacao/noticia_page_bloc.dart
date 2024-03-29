import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pmsbmibile3/models/noticia_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'dart:async';

class NoticiaPageEvent {}

class UpdateUsuarioIDEvent extends NoticiaPageEvent {
  final String usuarioID;

  UpdateUsuarioIDEvent(this.usuarioID);
}

class UpdateNoticiaVisualizadaEvent extends NoticiaPageEvent {
  final String noticiaID;
  final String usuarioID;

  UpdateNoticiaVisualizadaEvent({this.noticiaID, this.usuarioID});
}

class NoticiaPageState {
  String usuarioID;
  String usuarioIDNome;
  String noticiaID;
}

class NoticiaPageBloc {
  final bool visualizada;

  /// Database
  final fsw.Firestore firestore;

  /// Authenticacação
  final _authBloc = Bootstrap.instance.authBloc;

  /// Evento
  final _noticiaPageEventController = BehaviorSubject<NoticiaPageEvent>();

  Stream<NoticiaPageEvent> get noticiaPageEventStream =>
      _noticiaPageEventController.stream;

  Function get noticiaPageEventSink => _noticiaPageEventController.sink.add;

  /// Estado
  final _noticiaPageState = NoticiaPageState();
  final _noticiaPageStateController = BehaviorSubject<NoticiaPageState>();

  Stream<NoticiaPageState> get noticiaPageStateStream =>
      _noticiaPageStateController.stream;

  Function get noticiaPageStateSink => _noticiaPageStateController.sink.add;

  StreamSubscription firestoreSubscription;

  /// NoticiaModel
  final _noticiaModelListController = BehaviorSubject<List<NoticiaModel>>();

  Stream<List<NoticiaModel>> get noticiaModelListStream =>
      _noticiaModelListController.stream;

  Function get noticiaModelListSink => _noticiaModelListController.sink.add;

  NoticiaPageBloc({this.firestore, this.visualizada}) {
    noticiaPageEventStream.listen(_mapEventToState);
    _authBloc.userId
        .listen((userId) => noticiaPageEventSink(UpdateUsuarioIDEvent(userId)));
  }

  void dispose() async {
    await _noticiaPageEventController.drain();
    _noticiaPageEventController.close();
    await _noticiaPageStateController.drain();
    _noticiaPageStateController.close();
    await _noticiaModelListController.drain();
    _noticiaModelListController.close();
    firestoreSubscription?.cancel();
  }

  void _mapEventToState(NoticiaPageEvent event) async {
    if (event is UpdateUsuarioIDEvent) {
      _noticiaPageState.usuarioID = event.usuarioID;
      firestore
          .collection(UsuarioModel.collection)
          .document(_noticiaPageState.usuarioID)
          .snapshots()
          .map((snap) => UsuarioModel(id: snap.documentID).fromMap(snap.data))
          .listen((usuario) {
        _noticiaPageState.usuarioIDNome = usuario.nome;
        noticiaPageStateSink(_noticiaPageState);
      });
      noticiaPageStateStream.listen((event) {});
      final stream = firestore
          .collection(NoticiaModel.collection)
          .where("usuarioIDDestino.${_noticiaPageState.usuarioID}.id",
              isEqualTo: true)
          .where("usuarioIDDestino.${_noticiaPageState.usuarioID}.visualizada",
              isEqualTo: visualizada)
          .where("publicar", isLessThan: DateTime.now().toUtc())
          .snapshots()
          .map((snap) => snap.documents
              .map((doc) => NoticiaModel(id: doc.documentID).fromMap(doc.data))
              .toList());

      if (firestoreSubscription != null) {
        try {
          await firestoreSubscription.cancel();
          firestoreSubscription = null;
        } catch (e) {}
      }
      firestoreSubscription = stream.listen((data) {
        _noticiaModelListController.add(data);
      });

      noticiaModelListStream.listen((noticia) {
        noticia.forEach((item) {});
      });
    }
    if (event is UpdateNoticiaVisualizadaEvent) {
      _noticiaPageState.noticiaID = event.noticiaID;
      noticiaPageStateSink(_noticiaPageState);

      firestore
          .collection(NoticiaModel.collection)
          .document(_noticiaPageState.noticiaID)
          .setData({
        "usuarioIDDestino": {
          "${_noticiaPageState.usuarioID}": {"visualizada": !visualizada}
        }
      }, merge: true);
    }
  }
}
