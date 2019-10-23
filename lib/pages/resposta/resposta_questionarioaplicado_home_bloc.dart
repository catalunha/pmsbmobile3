import 'package:pmsbmibile3/models/questionario_model.dart';
import 'package:pmsbmibile3/models/relatorio_pdf_make.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

class RespostaQuestionarioAplicadoHomeEvent {}

class UpdateUsuarioIDEvent extends RespostaQuestionarioAplicadoHomeEvent {
  final UsuarioModel usuarioID;

  UpdateUsuarioIDEvent(this.usuarioID);
}

class UpdateQuestionarioAplicadoListEvent
    extends RespostaQuestionarioAplicadoHomeEvent {}

class UpdateRelatorioPdfMakeEvent
    extends RespostaQuestionarioAplicadoHomeEvent {}

class GerarRelatorioPdfMakeEvent extends RespostaQuestionarioAplicadoHomeEvent {
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

class RespostaQuestionarioAplicadoHomeState {
  UsuarioModel usuarioID;
  List<QuestionarioAplicadoModel> questionarioAplicadoList = List<QuestionarioAplicadoModel>();
  RelatorioPdfMakeModel relatorioPdfMakeModel;
  bool isDataValid = false;
}

class RespostaQuestionarioAplicadoHomeBloc {
  final fsw.Firestore _firestore;
  final _authBloc;

  //Eventos
  final _eventController =
      BehaviorSubject<RespostaQuestionarioAplicadoHomeEvent>();
  Stream<RespostaQuestionarioAplicadoHomeEvent> get eventStream =>
      _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final RespostaQuestionarioAplicadoHomeState _state =
      RespostaQuestionarioAplicadoHomeState();
  final _stateController =
      BehaviorSubject<RespostaQuestionarioAplicadoHomeState>();
  Stream<RespostaQuestionarioAplicadoHomeState> get stateStream =>
      _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  RespostaQuestionarioAplicadoHomeBloc(this._authBloc, this._firestore) {
    eventStream.listen(_mapEventToState);
    _authBloc.perfil.listen((usuarioID) {
      eventSink(UpdateUsuarioIDEvent(usuarioID));
    eventSink(UpdateQuestionarioAplicadoListEvent());
    });
  }

  void dispose() async {
    await _stateController.drain();
    _stateController.close();
    await _eventController.drain();
    _eventController.close();
  }

  _validateData() {
    if (_state.questionarioAplicadoList != null) {
      _state.isDataValid = true;
    } else {
      _state.isDataValid = false;
    }
  }

  void _mapEventToState(RespostaQuestionarioAplicadoHomeEvent event) async {
    if (event is UpdateUsuarioIDEvent) {
      _state.usuarioID = event.usuarioID;
    }
    if (event is UpdateQuestionarioAplicadoListEvent) {
      _state.questionarioAplicadoList.clear();
      final streamDocs = _firestore
          .collection(QuestionarioAplicadoModel.collection)
          .where("eixo.id", isEqualTo: _state.usuarioID.eixoIDAtual.id)
          .where("setorCensitarioID.id",
              isEqualTo: _state.usuarioID.setorCensitarioID.id)
          .snapshots();

      final snapList = streamDocs.map((snapDocs) => snapDocs.documents
          .map((doc) =>
              QuestionarioAplicadoModel(id: doc.documentID).fromMap(doc.data))
          .toList());

      snapList
          .listen((List<QuestionarioAplicadoModel> questionarioAplicadoList) {
        _state.questionarioAplicadoList = questionarioAplicadoList;
        if (!_stateController.isClosed) _stateController.add(_state);
      });
      eventSink(UpdateRelatorioPdfMakeEvent());
    }

    if (event is UpdateRelatorioPdfMakeEvent) {
      final streamDocRelatorio = _firestore
          .collection(RelatorioPdfMakeModel.collectionFirestore)
          .document(_state.usuarioID.id)
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
          .document(_state.usuarioID.id);
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
        'event.runtimeType em RespostaQuestionarioAplicadoHomeBloc  = ${event.runtimeType}');
  }
}
