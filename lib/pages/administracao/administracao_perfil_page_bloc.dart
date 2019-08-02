import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:pmsbmibile3/models/usuario_perfil_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;

/// Class base Eventos da Pagina ConfiguracaoPage
class AdministracaoPerfilPageEvent {}

class UpdateUsuarioIdEvent extends AdministracaoPerfilPageEvent {
  final String usuarioId;

  UpdateUsuarioIdEvent(this.usuarioId);
}

/// Class base Estado da Pagina ConfiguracaoPage
class AdministracaoPerfilPageState {
  String usuarioId;
  // String urlCSV;
  // String urlMD;
  // String urlPDF;
}

/// class Bloc para AdministracaoPerfilPage
class AdministracaoPerfilPageBloc {
  final fw.Firestore _firestore;

  // Eventos da Página
  final _administracaoPerfilPageEventController =
      BehaviorSubject<AdministracaoPerfilPageEvent>();

  Stream<AdministracaoPerfilPageEvent> get administracaoPerfilPageEventStream =>
      _administracaoPerfilPageEventController.stream;

  Function get administracaoPerfilPageEventSink =>
      _administracaoPerfilPageEventController.sink.add;

  // Estados da Página
  final AdministracaoPerfilPageState _administracaoPerfilPageState =
      AdministracaoPerfilPageState();
  final _administracaoPerfilPageStateController =
      BehaviorSubject<AdministracaoPerfilPageState>();

  Stream<AdministracaoPerfilPageState> get administracaoPerfilPageStateStream =>
      _administracaoPerfilPageStateController.stream;

  Function get administracaoPerfilPageStateSink =>
      _administracaoPerfilPageStateController.sink.add;

  // UsuarioModel
  final _usuarioModelController = BehaviorSubject<UsuarioModel>();

  Stream<UsuarioModel> get usuarioModelStream => _usuarioModelController.stream;

  Function get usuarioModelSink => _usuarioModelController.sink.add;

  // UsuarioPerfil
  final _usuarioPerfilModelController =
      BehaviorSubject<List<UsuarioPerfilModel>>();

  Stream<List<UsuarioPerfilModel>> get usuarioPerfilModelStream =>
      _usuarioPerfilModelController.stream;

  Function get usuarioPerfilModelSink => _usuarioPerfilModelController.sink.add;

  //Construtor da classe
  AdministracaoPerfilPageBloc(this._firestore) {
    administracaoPerfilPageEventStream.listen(_mapEventToState);
  }

  void dispose() {
    _usuarioModelController.close();
    _administracaoPerfilPageEventController.close();
    _usuarioPerfilModelController.close();
    _administracaoPerfilPageStateController.close();
  }

  void _mapEventToState(AdministracaoPerfilPageEvent event) {
    if (event is UpdateUsuarioIdEvent) {
      // Atualizar State with Event
      _administracaoPerfilPageState.usuarioId = event.usuarioId;
      //Usar State UsuarioModel
      _firestore
          .collection(UsuarioModel.collection)
          .document(_administracaoPerfilPageState.usuarioId)
          .snapshots()
          .map((snap) => UsuarioModel(id: snap.documentID).fromMap(snap.data))
          .listen((usuario) {
        usuarioModelSink(usuario);
      });

      //Usar State UsuarioPerfil
      final noticiasRef = _firestore
          .collection(UsuarioPerfilModel.collection)
          .where("usuarioID.id",
              isEqualTo: _administracaoPerfilPageState.usuarioId);
      noticiasRef
          .snapshots()
          .map((snapDocs) => snapDocs.documents
              .map((doc) =>
                  UsuarioPerfilModel(id: doc.documentID).fromMap(doc.data))
              .toList())
          .listen((List<UsuarioPerfilModel> usuarioPerfilModelList) {
        usuarioPerfilModelSink(usuarioPerfilModelList);
      });

      // // Definir as urls dos arquivos de perfil.csv, perfil.md e perfil.pdf
      // _firestore
      //     .collection(UsuarioArquivoModel.collection)
      //     .where("usuarioID",
      //         isEqualTo: _administracaoPerfilPageState.usuarioId)
      //     .where("referencia", isEqualTo: 'perfil.csv')
      //     .snapshots()
      //     .map((snapDocs) => snapDocs.documents
      //         .map((doc) =>
      //             UsuarioArquivoModel(id: doc.documentID).fromMap(doc.data))
      //         .toList())
      //     .listen((List<UsuarioArquivoModel> usuarioArquivoModelList) {
      //   usuarioArquivoModelList.forEach((item) {
      //     print('>>> item csv<<< ${item.url}');
      //     _administracaoPerfilPageState.urlCSV = item.url;
      //     administracaoPerfilPageStateSink(_administracaoPerfilPageState);
      //   });
      // });

      // // Definir as urls dos arquivos de perfil.csv, perfil.md e perfil.pdf
      // _firestore
      //     .collection(UsuarioArquivoModel.collection)
      //     .where("usuarioID",
      //         isEqualTo: _administracaoPerfilPageState.usuarioId)
      //     .where("referencia", isEqualTo: 'perfil.pdf')
      //     .snapshots()
      //     .map((snapDocs) => snapDocs.documents
      //         .map((doc) =>
      //             UsuarioArquivoModel(id: doc.documentID).fromMap(doc.data))
      //         .toList())
      //     .listen((List<UsuarioArquivoModel> usuarioArquivoModelList) {
      //   usuarioArquivoModelList.forEach((item) {
      //     print('>>> item pdf <<< ${item.url}');
      //     _administracaoPerfilPageState.urlPDF = item.url;
      //     administracaoPerfilPageStateSink(_administracaoPerfilPageState);
      //   });
      // });

      // // Definir as urls dos arquivos de perfil.csv, perfil.md e perfil.pdf
      // _firestore
      //     .collection(UsuarioArquivoModel.collection)
      //     .where("usuarioID",
      //         isEqualTo: _administracaoPerfilPageState.usuarioId)
      //     .where("referencia", isEqualTo: 'perfil.md')
      //     .snapshots()
      //     .map((snapDocs) => snapDocs.documents
      //         .map((doc) =>
      //             UsuarioArquivoModel(id: doc.documentID).fromMap(doc.data))
      //         .toList())
      //     .listen((List<UsuarioArquivoModel> usuarioArquivoModelList) {
      //   usuarioArquivoModelList.forEach((item) {
      //     print('>>> item md <<< ${item.url}');
      //     _administracaoPerfilPageState.urlMD = item.url;
      //     administracaoPerfilPageStateSink(_administracaoPerfilPageState);
      //   });
      // });
      
    }
  }
}
