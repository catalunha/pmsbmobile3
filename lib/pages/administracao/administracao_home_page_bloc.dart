import 'package:pmsbmibile3/models/relatorio_pdf_make.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

class AdministracaoHomePageBlocEvent {}

class UpdateUsuarioLogadoEvent extends AdministracaoHomePageBlocEvent {
  final UsuarioModel usuarioLogado;

  UpdateUsuarioLogadoEvent(this.usuarioLogado);
}

class UpdateUsuarioListEvent extends AdministracaoHomePageBlocEvent {}

class UpdateRelatorioPdfMakeEvent extends AdministracaoHomePageBlocEvent {}

class GerarRelatorioPdfMakeEvent extends AdministracaoHomePageBlocEvent {
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

class AdministracaoHomePageBlocState {
  UsuarioModel usuarioLogado;
  List<UsuarioModel> usuarioList=List<UsuarioModel>();
  bool isDataValid = false;

  RelatorioPdfMakeModel relatorioPdfMakeModel;
}

class AdministracaoHomePageBloc {
  //Firestore
  final fsw.Firestore _firestore;
  final _authBloc;

  //Eventos
  final _eventController = BehaviorSubject<AdministracaoHomePageBlocEvent>();
  Stream<AdministracaoHomePageBlocEvent> get eventStream =>
      _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final AdministracaoHomePageBlocState _state =
      AdministracaoHomePageBlocState();
  final _stateController = BehaviorSubject<AdministracaoHomePageBlocState>();
  Stream<AdministracaoHomePageBlocState> get stateStream =>
      _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  //Bloc
  AdministracaoHomePageBloc(this._firestore, this._authBloc) {
    eventStream.listen(_mapEventToState);
    _authBloc.perfil.listen((usuarioLogado) {
      eventSink(UpdateUsuarioLogadoEvent(usuarioLogado));
    });
    eventSink(UpdateUsuarioListEvent());
  }

  void dispose() async {
    await _stateController.drain();
    _stateController.close();
    await _eventController.drain();
    _eventController.close();
  }

  _validateData() {
    if (_state.usuarioList != null) {
      _state.isDataValid = true;
    } else {
      _state.isDataValid = false;
    }
  }

  _mapEventToState(AdministracaoHomePageBlocEvent event) async {
    if (event is UpdateUsuarioLogadoEvent) {
      //Atualiza estado com usuario logado
      _state.usuarioLogado = event.usuarioLogado;
    }

    if (event is UpdateUsuarioListEvent) {
      _state.usuarioList.clear();
      // le todas as tarefas deste usuario como remetente/designadas neste setor.
      final streamDocs = _firestore
          .collection(UsuarioModel.collection)
          .where("ativo", isEqualTo: true)
          .orderBy("nome")
          .snapshots();

      final snapList = streamDocs.map((snapDocs) => snapDocs.documents
          .map((doc) => UsuarioModel(id: doc.documentID).fromMap(doc.data))
          .toList());

      snapList.listen((List<UsuarioModel> usuarioList) {
        _state.usuarioList = usuarioList;
        if (!_stateController.isClosed) _stateController.add(_state);
      });
    }

    if (event is UpdateRelatorioPdfMakeEvent) {
      final streamDocRelatorio = _firestore
          .collection(RelatorioPdfMakeModel.collectionFirestore)
          .document(_state.usuarioLogado.id)
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
          .document(_state.usuarioLogado.id);
      await docRelatorio.setData({
        'pdfGerar': event.pdfGerar,
        'pdfGerado': event.pdfGerado,
        'tipo': event.tipo,
        'collection': event.collection,
        'document': event.document,
      }, merge: true);
    }
    _validateData();

    if (!_stateController.isClosed) _stateController.add(_state);
    print(
        'event.runtimeType em AdministracaoHomePageBloc  = ${event.runtimeType}');
  }
}
