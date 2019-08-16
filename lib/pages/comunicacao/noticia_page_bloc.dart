import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pmsbmibile3/models/noticia_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:pmsbmibile3/state/auth_bloc.dart';
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

  // Database
  final fsw.Firestore firestore;

  // Authenticacação
  final _authBloc = AuthBloc(Bootstrap.instance.auth, Bootstrap.instance.firestore);

  //Evento
  final _noticiaPageEventController = BehaviorSubject<NoticiaPageEvent>();

  Stream<NoticiaPageEvent> get noticiaPageEventStream =>
      _noticiaPageEventController.stream;

  Function get noticiaPageEventSink => _noticiaPageEventController.sink.add;

  //Estado
  final _noticiaPageState = NoticiaPageState();
  final _noticiaPageStateController = BehaviorSubject<NoticiaPageState>();

  Stream<NoticiaPageState> get noticiaPageStateStream =>
      _noticiaPageStateController.stream;

  Function get noticiaPageStateSink => _noticiaPageStateController.sink.add;

  StreamSubscription firestoreSubscription;

  // //UsuarioNoticiaModel
  // final _usuarioNoticiaModelListController =
  //     BehaviorSubject<List<UsuarioNoticiaModel>>();
  // Stream<List<UsuarioNoticiaModel>> get usuarioNoticiaModelListStream =>
  //     _usuarioNoticiaModelListController.stream;
  // Function get usuarioNoticiaModelListSink =>
  //     _usuarioNoticiaModelListController.sink.add;

  //NoticiaModel
  final _noticiaModelListController = BehaviorSubject<List<NoticiaModel>>();

  Stream<List<NoticiaModel>> get noticiaModelListStream =>
      _noticiaModelListController.stream;

  Function get noticiaModelListSink => _noticiaModelListController.sink.add;

  NoticiaPageBloc({this.firestore, this.visualizada}) {
    noticiaPageEventStream.listen(_mapEventToState);
    _authBloc.userId
        .listen((userId) => noticiaPageEventSink(UpdateUsuarioIDEvent(userId)));
  }

  void dispose() {
    _noticiaPageEventController.close();
    _noticiaPageStateController.close();
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
        // print('>> usuario.nome >> ${usuario.nome}');
        noticiaPageStateSink(_noticiaPageState);
      });
      noticiaPageStateStream.listen((event) {
        // print('>> event >> ${event.usuarioID}');
        // print('>> event >> ${event.usuarioIDNome}');
      });
      final stream = firestore
          .collection(NoticiaModel.collection)
          .where("usuarioIDDestino.${_noticiaPageState.usuarioID}.id",
              isEqualTo: true)
          .where("usuarioIDDestino.${_noticiaPageState.usuarioID}.visualizada",
              isEqualTo: visualizada)
          .where("publicar",
              isLessThan: DateTime.now().toUtc())
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
        noticia.forEach((item) {
          // print('>> item. >> ${item.titulo}');
          // print('>> item. >> ${item.publicar}');
          // print('>> item. >> ${item.publicada}');
        });
      });
    }
    if (event is UpdateNoticiaVisualizadaEvent) {
      _noticiaPageState.noticiaID = event.noticiaID;
      noticiaPageStateSink(_noticiaPageState);

      print('usuarioIDDestino.${_noticiaPageState.usuarioID}.visualizada');
      firestore
          .collection(NoticiaModel.collection)
          .document(_noticiaPageState.noticiaID)
          .setData({
        "usuarioIDDestino": {
          "${_noticiaPageState.usuarioID}": {"visualizada": !visualizada}
        }
      }, merge: true);
    }

    // noticiaPageStateSink(_noticiaPageState);
  }
}
