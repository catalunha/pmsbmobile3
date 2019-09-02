import 'package:pmsbmibile3/models/questionario_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;



class RespostaQuestionarioAplicadoHomeEvent {}

class QueryQuestionariosAplicadoListAplicacaoHomePageBlocEvent
    extends RespostaQuestionarioAplicadoHomeEvent {}

class UpdateUsuarioIDEvent extends RespostaQuestionarioAplicadoHomeEvent {
  final String usuarioID;

  UpdateUsuarioIDEvent(this.usuarioID);
}


class RespostaQuestionarioAplicadoHomeState {
  UsuarioModel usuarioModel;

  List<QuestionarioAplicadoModel> questionariosAplicados;
}

class RespostaQuestionarioAplicadoHomeBloc {
  final fsw.Firestore _firestore;
  final _authBloc;


  //Eventos
  final _eventController = BehaviorSubject<RespostaQuestionarioAplicadoHomeEvent>();
  Stream<RespostaQuestionarioAplicadoHomeEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final RespostaQuestionarioAplicadoHomeState _state = RespostaQuestionarioAplicadoHomeState();
  final _stateController = BehaviorSubject<RespostaQuestionarioAplicadoHomeState>();
  Stream<RespostaQuestionarioAplicadoHomeState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;


  //ProdutoModel List
  final _questionarioAplicadoListController = BehaviorSubject<List<QuestionarioAplicadoModel>>();
  Stream<List<QuestionarioAplicadoModel>> get questionarioAplicadoListStream =>
      _questionarioAplicadoListController.stream;
  Function get questionarioAplicadoListSink => _questionarioAplicadoListController.sink.add;

  RespostaQuestionarioAplicadoHomeBloc(this._authBloc, this._firestore) {
    eventStream.listen(_mapEventToState);
    _authBloc.userId.listen((userId) {
      eventSink(UpdateUsuarioIDEvent(userId));
    });
  }

  
  void dispose() async {
    await _stateController.drain();
    _stateController.close();
    await _eventController.drain();
    _eventController.close();
    await _questionarioAplicadoListController.drain();
    _questionarioAplicadoListController.close();
  }

  void _mapEventToState(RespostaQuestionarioAplicadoHomeEvent event) async {
        if (event is UpdateUsuarioIDEvent) {
      //Atualiza estado com usuario logado
      final docRef = _firestore
          .collection(UsuarioModel.collection)
          .document(event.usuarioID);
      final docSnap = await docRef.get();
      if (docSnap.exists) {
        final usuarioModel =
            UsuarioModel(id: docSnap.documentID).fromMap(docSnap.data);
        _state.usuarioModel = usuarioModel;
        if (!_stateController.isClosed) _stateController.add(_state);
      }

      // le todos os produtos associados e ele, setor e eixo.
      final streamDocs = _firestore
          .collection(QuestionarioAplicadoModel.collection)
          .where("eixo.id", isEqualTo: _state.usuarioModel.eixoIDAtual.id)
          .where("setorCensitarioID.id",
              isEqualTo: _state.usuarioModel.setorCensitarioID.id)
          .snapshots();

      final snapList = streamDocs.map((snapDocs) => snapDocs.documents
          .map((doc) => QuestionarioAplicadoModel(id: doc.documentID).fromMap(doc.data))
          .toList());

      snapList.listen((List<QuestionarioAplicadoModel> questionarioAplicadoList) {
        questionarioAplicadoListSink(questionarioAplicadoList);
      });
    }

    if (!_stateController.isClosed) _stateController.add(_state);
    print('event.runtimeType em RespostaQuestionarioAplicadoHomeBloc  = ${event.runtimeType}');
  }
}
