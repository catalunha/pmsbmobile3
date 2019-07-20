import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pmsbmibile3/api/auth_api_mobile.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/usuario_arquivo_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
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
  final _authBloc = AuthBloc(AuthApiMobile(), Bootstrap.instance.firestore);

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
  final _noticiaModelListController = BehaviorSubject<List<NoticiaModel>>();
  Stream<List<NoticiaModel>> get noticiaModelListStream =>
      _noticiaModelListController.stream;

  // NoticiaModel Publicadas
  final _noticiaModelListPublicadasController = BehaviorSubject<List<NoticiaModel>>();
  Stream<List<NoticiaModel>> get noticiaModelListPublicadasStream =>
      _noticiaModelListPublicadasController.stream;


  ComunicacaoHomePageBloc(this._firestore) {
        comunicacaoHomePageEventStream.listen(_mapEventToState);

    _authBloc.userId.listen((userId)=>comunicacaoHomePageEventSink(UpdateUsuarioIDEvent(userId)));
  }
  void _mapEventToState(ComunicacaoHomePageEvent event) {

    if (event is UpdateUsuarioIDEvent) {
            // Atualizar State with Event
      _comunicacaoHomePageState.usuarioId = event.usuarioID;
          comunicacaoHomePageStateSink(_comunicacaoHomePageState);

      //Noticia nao publicadas ou em edicao
    final noticiasRef = _firestore
        .collection(NoticiaModel.collection)
        .where('publicada', isEqualTo: false)
        .where('usuarioIDEditor.id', isEqualTo: event.usuarioID);

    noticiasRef
        .snapshots()
        .map((querySnap) => querySnap.documents
            .map((docSnap) =>
                NoticiaModel(id: docSnap.documentID).fromMap(docSnap.data))
            .toList())
        .pipe(_noticiaModelListController);

      //Noticia publicadas nao pode editar.
      //Reduzir lista
    _firestore
        .collection(NoticiaModel.collection)
        .where('publicada', isEqualTo: true)
        .where('usuarioIDEditor.id', isEqualTo: event.usuarioID)
        .snapshots()
        .map((querySnap) => querySnap.documents
            .map((docSnap) =>
                NoticiaModel(id: docSnap.documentID).fromMap(docSnap.data))
            .toList())
        .pipe(_noticiaModelListPublicadasController);


      // Definir as urls dos arquivos de perfil.csv, perfil.md e perfil.pdf
      _firestore
          .collection(UsuarioArquivoModel.collection)
          .where("usuarioID",
              isEqualTo: _comunicacaoHomePageState.usuarioId)
          .where("referencia", isEqualTo: 'noticia.csv')
          .snapshots()
          .map((snapDocs) => snapDocs.documents
              .map((doc) =>
                  UsuarioArquivoModel(id: doc.documentID).fromMap(doc.data))
              .toList())
          .listen((List<UsuarioArquivoModel> usuarioArquivoModelList) {
        usuarioArquivoModelList.forEach((item) {
          print('>>> item csv<<< ${item.url}');
          _comunicacaoHomePageState.urlCSV = item.url;
          comunicacaoHomePageStateSink(_comunicacaoHomePageState);
        });
      });

      // Definir as urls dos arquivos de perfil.csv, perfil.md e perfil.pdf
      _firestore
          .collection(UsuarioArquivoModel.collection)
          .where("usuarioID",
              isEqualTo: _comunicacaoHomePageState.usuarioId)
          .where("referencia", isEqualTo: 'noticia.pdf')
          .snapshots()
          .map((snapDocs) => snapDocs.documents
              .map((doc) =>
                  UsuarioArquivoModel(id: doc.documentID).fromMap(doc.data))
              .toList())
          .listen((List<UsuarioArquivoModel> usuarioArquivoModelList) {
        usuarioArquivoModelList.forEach((item) {
          print('>>> item pdf <<< ${item.url}');
          _comunicacaoHomePageState.urlPDF = item.url;
          comunicacaoHomePageStateSink(_comunicacaoHomePageState);
        });
      });

      // Definir as urls dos arquivos de perfil.csv, perfil.md e perfil.pdf
      _firestore
          .collection(UsuarioArquivoModel.collection)
          .where("usuarioID",
              isEqualTo: _comunicacaoHomePageState.usuarioId)
          .where("referencia", isEqualTo: 'noticia.md')
          .snapshots()
          .map((snapDocs) => snapDocs.documents
              .map((doc) =>
                  UsuarioArquivoModel(id: doc.documentID).fromMap(doc.data))
              .toList())
          .listen((List<UsuarioArquivoModel> usuarioArquivoModelList) {
        usuarioArquivoModelList.forEach((item) {
          print('>>> item md <<< ${item.url}');
          _comunicacaoHomePageState.urlMD = item.url;
          comunicacaoHomePageStateSink(_comunicacaoHomePageState);
        });
      });
      


    }

  }

  void dispose() {
    _authBloc.dispose();
    _comunicacaoHomePageEventController.close();
    _comunicacaoHomePageStateController.close();
    _noticiaModelListController.close();
    _noticiaModelListPublicadasController.close();
  }
}
