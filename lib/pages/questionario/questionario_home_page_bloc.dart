import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:pmsbmibile3/models/models.dart';
import 'package:pmsbmibile3/models/relatorio_pdf_make.dart';
import 'package:queries/collections.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pmsbmibile3/models/questionario_model.dart';
import 'dart:async';

class QuestionarioHomePageEvent {}

class UpdateUserInfoQuestionarioHomePageBlocEvent extends QuestionarioHomePageEvent {
  final UsuarioModel user;

  UpdateUserInfoQuestionarioHomePageBlocEvent(this.user);
}

class UpdateQuestionarioListQuestionarioHomePageEvent extends QuestionarioHomePageEvent {
  final List<QuestionarioModel> questionarios;

  UpdateQuestionarioListQuestionarioHomePageEvent(this.questionarios);
}

class OrdenarQuestionarioEvent extends QuestionarioHomePageEvent {
  final String questionarioID;
  final bool up;

  OrdenarQuestionarioEvent(this.questionarioID, this.up);
}

class UpdateRelatorioPdfMakeEvent extends QuestionarioHomePageEvent {}

class GerarRelatorioPdfMakeEvent extends QuestionarioHomePageEvent {
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

class QuestionarioHomePageBlocState {
    UsuarioModel usuarioModel;

  String questionarioID;
  String usuarioID;
  String eixoAtualID;
  bool isDataValid;

  Map<String, QuestionarioModel> questionarioMap = Map<String, QuestionarioModel>();
  RelatorioPdfMakeModel relatorioPdfMakeModel;
}

class QuestionarioHomePageBloc {
  final fsw.Firestore _firestore;
  final _authBloc;

  // Eventos
  final _eventController = BehaviorSubject<QuestionarioHomePageEvent>();

  Stream<QuestionarioHomePageEvent> get eventStream => _eventController.stream;

  Function get eventSink => _eventController.sink.add;

  // Estados
  final QuestionarioHomePageBlocState _state = QuestionarioHomePageBlocState();
  final _stateController = BehaviorSubject<QuestionarioHomePageBlocState>();

  Stream<QuestionarioHomePageBlocState> get stateStream => _stateController.stream;

  Function get stateSink => _stateController.sink.add;


  StreamSubscription<List<QuestionarioModel>> _questionarioSubscription;

  // QuestionarioModel List
  final _questionarioMapController = BehaviorSubject<Map<String, QuestionarioModel>>();

  Stream<Map<String, QuestionarioModel>> get questionarioMapStream => _questionarioMapController.stream;

  Function get questionarioMapSink => _questionarioMapController.sink.add;

  QuestionarioHomePageBloc(this._firestore, this._authBloc) {
    _eventController.listen(_mapEventToState);
    _authBloc.perfil.listen((user) {
      eventSink(UpdateUserInfoQuestionarioHomePageBlocEvent(user));
    });
  }

  void dispose() async {
    await _eventController.drain();
    _eventController?.close();
    await _stateController.drain();
    _stateController?.close();
    _questionarioSubscription?.cancel();
    await _questionarioMapController.drain();
    _questionarioMapController?.close();
  }

  _validateData() {
    if (_state.questionarioMap != null) {
      _state.isDataValid = true;
    } else {
      _state.isDataValid = false;
    }
  }

  void _mapEventToState(QuestionarioHomePageEvent event) async {
    if (event is UpdateUserInfoQuestionarioHomePageBlocEvent) {
      _state.usuarioModel = event.user;
      _state.usuarioID = event.user.id;
      _state.eixoAtualID = event.user.eixoIDAtual.id;

      final ref = _firestore.collection(QuestionarioModel.collection).where("eixo.id", isEqualTo: _state.eixoAtualID);
      final snap = ref.snapshots();
      final snapList =
          snap.map((q) => q.documents.map((d) => QuestionarioModel(id: d.documentID).fromMap(d.data)).toList());
      if (_questionarioSubscription != null) {
        await _questionarioSubscription.cancel();
      }
      _questionarioSubscription = snapList.listen((questionarioModelList) {
        eventSink(UpdateQuestionarioListQuestionarioHomePageEvent(questionarioModelList));
      });
      eventSink(UpdateRelatorioPdfMakeEvent());
    }

    if (event is UpdateQuestionarioListQuestionarioHomePageEvent) {
      _state.questionarioMap.clear();
      for (var questionario in event.questionarios) {
        _state.questionarioMap[questionario.id] = questionario;
      }

      var dicDesordenado = Dictionary.fromMap(_state.questionarioMap);
      var dicOrdenadado = dicDesordenado
          .orderBy((kv) => kv.value.ordem)
          // .orderByDescending((kv) => kv.value.ordem)
          .toDictionary$1((kv) => kv.key, (kv) => kv.value);
      _state.questionarioMap = dicOrdenadado.toMap();
    }

    if (event is OrdenarQuestionarioEvent) {
      List<QuestionarioModel> valuesList = _state.questionarioMap.values.toList();
      List<String> keyList = _state.questionarioMap.keys.toList();
      final ordemOrigem = keyList.indexOf(event.questionarioID);
      final ordemOutro = event.up ? ordemOrigem - 1 : ordemOrigem + 1;
      QuestionarioModel questionarioOrigem = valuesList[ordemOrigem];
      QuestionarioModel questionarioOutro = valuesList[ordemOutro];
      String keyOrigem = keyList[ordemOrigem];
      String keyOutra = keyList[ordemOutro];

      final collectionRef = _firestore.collection(QuestionarioModel.collection);

      final docOrigem = collectionRef.document(questionarioOrigem.id);
      final docOutro = collectionRef.document(questionarioOutro.id);

      docOrigem.setData({"ordem": questionarioOutro.ordem}, merge: true);
      docOutro.setData({"ordem": questionarioOrigem.ordem}, merge: true);
    }
    if (event is UpdateRelatorioPdfMakeEvent) {
      final streamDocRelatorio =
          _firestore.collection(RelatorioPdfMakeModel.collectionFirestore).document(_state.usuarioID).snapshots();
      streamDocRelatorio.listen((snapDoc) {
        _state.relatorioPdfMakeModel = RelatorioPdfMakeModel(id: snapDoc.documentID).fromMap(snapDoc.data);
        if (!_stateController.isClosed) _stateController.add(_state);
      });
    }

    if (event is GerarRelatorioPdfMakeEvent) {
      final docRelatorio =
          _firestore.collection(RelatorioPdfMakeModel.collectionFirestore).document(_state.usuarioID);
      await docRelatorio.setData({
        'pdfGerar': event.pdfGerar,
        'pdfGerado': event.pdfGerado,
        'tipo': event.tipo,
        'collection': event.collection,
        'document': event.document,
      }, merge: true);
    }
    _validateData();
    if (!_stateController.isClosed) stateSink(_state);
    print('event.runtimeType em QuestionarioHomePageBloc  = ${event.runtimeType}');
  }
}
