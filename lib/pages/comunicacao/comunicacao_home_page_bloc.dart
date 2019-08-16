import 'package:pmsbmibile3/bootstrap.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pmsbmibile3/models/noticia_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:pmsbmibile3/state/auth_bloc.dart';

// Eventos da Pagina
class ComunicacaoHomePageEvent {}

class UpdateUsuarioIDEvent extends ComunicacaoHomePageEvent {
  final String usuarioID;

  UpdateUsuarioIDEvent(this.usuarioID);
}

// Estado da Pagina
class ComunicacaoHomePageState {
  String usuarioId;
  String urlCSV;
  String urlMD;
  String urlPDF;
}

class ComunicacaoHomePageBloc {
  final fsw.Firestore _firestore;
  // Auth
  final _authBloc =
      AuthBloc(Bootstrap.instance.auth, Bootstrap.instance.firestore);

  // Eventos da Página
  final _comunicacaoHomePageEventController =
      BehaviorSubject<ComunicacaoHomePageEvent>();

  Stream<ComunicacaoHomePageEvent> get comunicacaoHomePageEventStream =>
      _comunicacaoHomePageEventController.stream;

  Function get comunicacaoHomePageEventSink =>
      _comunicacaoHomePageEventController.sink.add;

  // Estados da Página
  final ComunicacaoHomePageState _comunicacaoHomePageState =
      ComunicacaoHomePageState();
  final _comunicacaoHomePageStateController =
      BehaviorSubject<ComunicacaoHomePageState>();

  Stream<ComunicacaoHomePageState> get comunicacaoHomePageStateStream =>
      _comunicacaoHomePageStateController.stream;

  Function get comunicacaoHomePageStateSink =>
      _comunicacaoHomePageStateController.sink.add;

  // NoticiaModel Em Edicao
  final _noticiaModelListEdicaoController =
      BehaviorSubject<List<NoticiaModel>>();
  Stream<List<NoticiaModel>> get noticiaModelListEdicaoStream =>
      _noticiaModelListEdicaoController.stream;

  // NoticiaModel Publicadas
  final _noticiaModelListPublicadaController =
      BehaviorSubject<List<NoticiaModel>>();
  Stream<List<NoticiaModel>> get noticiaModelListPublicadaStream =>
      _noticiaModelListPublicadaController.stream;

  ComunicacaoHomePageBloc(this._firestore) {
    comunicacaoHomePageEventStream.listen(_mapEventToState);

    _authBloc.userId.listen(
        (userId) => comunicacaoHomePageEventSink(UpdateUsuarioIDEvent(userId)));
  }
  void _mapEventToState(ComunicacaoHomePageEvent event) {
    if (event is UpdateUsuarioIDEvent) {
      // Atualizar State with Event
      _comunicacaoHomePageState.usuarioId = event.usuarioID;
      comunicacaoHomePageStateSink(_comunicacaoHomePageState);

      //Noticia nao publicadas ou em edicao
      final noticiasRef = _firestore
          .collection(NoticiaModel.collection)
          // .where('publicada', isEqualTo: false)
          .where('usuarioIDEditor.id', isEqualTo: event.usuarioID)
          .where("publicar", isGreaterThan: DateTime.now().toUtc());

      noticiasRef
          .snapshots()
          .map((querySnap) => querySnap.documents
              .map((docSnap) =>
                  NoticiaModel(id: docSnap.documentID).fromMap(docSnap.data))
              .toList())
          .pipe(_noticiaModelListEdicaoController);

      //Noticia publicadas nao pode editar.
      _firestore
          .collection(NoticiaModel.collection)
          // .where('publicada', isEqualTo: true)
          .where('usuarioIDEditor.id', isEqualTo: event.usuarioID)
          .where("publicar", isLessThan: DateTime.now().toUtc())
          .snapshots()
          .map((querySnap) => querySnap.documents
              .map((docSnap) =>
                  NoticiaModel(id: docSnap.documentID).fromMap(docSnap.data))
              .toList())
          .pipe(_noticiaModelListPublicadaController);
    }
  }

  void dispose() async {
    _authBloc.dispose();
    await _comunicacaoHomePageEventController.drain();
    _comunicacaoHomePageEventController.close();
    await _comunicacaoHomePageStateController.drain();
    _comunicacaoHomePageStateController.close();
    await _noticiaModelListEdicaoController.drain();
    _noticiaModelListEdicaoController.close();
    await _noticiaModelListPublicadaController.drain();
    _noticiaModelListPublicadaController.close();
  }
}
