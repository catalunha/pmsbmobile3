import 'package:pmsbmibile3/models/relatorio_pdf_make.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:pmsbmibile3/models/usuario_perfil_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

/// Class base Eventos da Pagina ConfiguracaoPage
class AdministracaoPerfilPageEvent {}

class UpdateUsuarioModelEvent extends AdministracaoPerfilPageEvent {
  final UsuarioModel usuarioModel;

  UpdateUsuarioModelEvent(this.usuarioModel);
}

class UpdateUsuarioIdEvent extends AdministracaoPerfilPageEvent {
  final String usuarioId;

  UpdateUsuarioIdEvent(this.usuarioId);
}

class UpdateRelatorioPdfMakeEvent extends AdministracaoPerfilPageEvent {}

class GerarRelatorioPdfMakeEvent extends AdministracaoPerfilPageEvent {
  final bool pdfGerar;
  final bool pdfGerado;
  final String tipo;
  final String collection;
  final String document;

  GerarRelatorioPdfMakeEvent({
    this.pdfGerar,
    this.pdfGerado,
    this.tipo,
    this.collection,
    this.document,
  });
}

/// Class base Estado da Pagina ConfiguracaoPage
class AdministracaoPerfilPageState {
  String usuarioId;

  List<UsuarioModel> usuarioList;
  UsuarioModel usuarioModel;
  RelatorioPdfMakeModel relatorioPdfMakeModel;
}

/// class Bloc para AdministracaoPerfilPage
class AdministracaoPerfilPageBloc {
  //Firestore
  final fsw.Firestore _firestore;
  final _authBloc;

  // Eventos da Página
  final _administracaoPerfilPageEventController =
      BehaviorSubject<AdministracaoPerfilPageEvent>();

  Stream<AdministracaoPerfilPageEvent> get administracaoPerfilPageEventStream =>
      _administracaoPerfilPageEventController.stream;

  Function get administracaoPerfilPageEventSink =>
      _administracaoPerfilPageEventController.sink.add;

  // Estados da Página
  final AdministracaoPerfilPageState _state = AdministracaoPerfilPageState();
  final _stateController = BehaviorSubject<AdministracaoPerfilPageState>();

  Stream<AdministracaoPerfilPageState> get administracaoPerfilPageStateStream =>
      _stateController.stream;

  Function get administracaoPerfilPageStateSink => _stateController.sink.add;

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
  AdministracaoPerfilPageBloc(this._firestore, this._authBloc) {
    administracaoPerfilPageEventStream.listen(_mapEventToState);
    _authBloc.perfil.listen((usuarioID) {
      administracaoPerfilPageEventSink(UpdateUsuarioModelEvent(usuarioID));
    });
  }

  void dispose() async {
    await _usuarioModelController.drain();
    _usuarioModelController.close();
    await _administracaoPerfilPageEventController.drain();
    _administracaoPerfilPageEventController.close();
    await _usuarioPerfilModelController.drain();
    _usuarioPerfilModelController.close();
    await _stateController.drain();
    _stateController.close();
  }

  void _mapEventToState(AdministracaoPerfilPageEvent event) async {
    if (event is UpdateUsuarioModelEvent) {
      //Atualiza estado com usuario logado
      _state.usuarioModel = event.usuarioModel;
    }
    if (event is UpdateUsuarioIdEvent) {
      // Atualizar State with Event
      _state.usuarioId = event.usuarioId;
      //Usar State UsuarioModel
      _firestore
          .collection(UsuarioModel.collection)
          .document(_state.usuarioId)
          .snapshots()
          .map((snap) => UsuarioModel(id: snap.documentID).fromMap(snap.data))
          .listen((usuario) {
        usuarioModelSink(usuario);
      });

      //Usar State UsuarioPerfil
      final noticiasRef = _firestore
          .collection(UsuarioPerfilModel.collection)
          .where("usuarioID.id", isEqualTo: _state.usuarioId);
      noticiasRef
          .snapshots()
          .map((snapDocs) => snapDocs.documents
              .map((doc) =>
                  UsuarioPerfilModel(id: doc.documentID).fromMap(doc.data))
              .toList())
          .listen((List<UsuarioPerfilModel> usuarioPerfilModelList) {
        usuarioPerfilModelSink(usuarioPerfilModelList);
      });
      administracaoPerfilPageEventSink(UpdateRelatorioPdfMakeEvent());
    }

    if (event is UpdateRelatorioPdfMakeEvent) {
      final streamDocRelatorio = _firestore
          .collection(RelatorioPdfMakeModel.collectionFirestore)
          .document(_state.usuarioModel.id)
          .snapshots();
      streamDocRelatorio.listen((snapDoc) {
        _state.relatorioPdfMakeModel =
            RelatorioPdfMakeModel(id: snapDoc.documentID).fromMap(snapDoc.data);
        if (!_stateController.isClosed) _stateController.add(_state);
      });
    }

    if (event is GerarRelatorioPdfMakeEvent) {
      final docRelatorio = _firestore
          .collection(RelatorioPdfMakeModel.collectionFirestore)
          .document(_state.usuarioModel.id);
      await docRelatorio.setData({
        'pdfGerar': event.pdfGerar,
        'pdfGerado': event.pdfGerado,
        'tipo': event.tipo,
        'collection': event.collection,
        'document': event.document,
      }, merge: true);
    }

    if (!_stateController.isClosed) _stateController.add(_state);
    print(
        'event.runtimeType em ControleTarefaListBloc  = ${event.runtimeType}');
  }
}
