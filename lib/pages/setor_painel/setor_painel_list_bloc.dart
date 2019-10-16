import 'package:pmsbmibile3/models/relatorio_pdf_make.dart';

import 'package:pmsbmibile3/models/setor_censitario_painel_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:rxdart/rxdart.dart';

class SetorPainelListBlocEvent {}

class UpdateUsuarioIDEvent extends SetorPainelListBlocEvent {
  final UsuarioModel usuarioID;

  UpdateUsuarioIDEvent(this.usuarioID);
}

class UpdateSetorCensitarioPainelIDEvent extends SetorPainelListBlocEvent {}

class UpdateRelatorioPdfMakeEvent extends SetorPainelListBlocEvent {}
class GerarRelatorioPdfMakeEvent extends SetorPainelListBlocEvent {
    final bool pdfGerar;
    final bool pdfGerado;
    final String tipo;

  GerarRelatorioPdfMakeEvent({this.pdfGerar,this.pdfGerado,this.tipo});
}

class SetorPainelListBlocState {
  UsuarioModel usuarioID;
  bool isDataValid = false;
  List<SetorCensitarioPainelModel> setorCensitarioPainelList = List<SetorCensitarioPainelModel>();
  RelatorioPdfMakeModel relatorioPdfMakeModel;
}


class SetorPainelListBloc {
  //Firestore
  final fsw.Firestore _firestore;
  final _authBloc;

  //Eventos
  final _eventController = BehaviorSubject<SetorPainelListBlocEvent>();
  Stream<SetorPainelListBlocEvent> get eventStream =>
      _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final SetorPainelListBlocState _state = SetorPainelListBlocState();
  final _stateController = BehaviorSubject<SetorPainelListBlocState>();

  Stream<SetorPainelListBlocState> get stateStream =>
      _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  //Bloc
  SetorPainelListBloc(this._firestore, this._authBloc) {
    eventStream.listen(_mapEventToState);
    _authBloc.perfil.listen((usuarioID) {
      eventSink(UpdateUsuarioIDEvent(usuarioID));
    });
  }

  void dispose() async {
    await _stateController.drain();
    _stateController.close();
    await _eventController.drain();
    _eventController.close();
  }

  _validateData() {
    _state.isDataValid=false;
        if (_state.setorCensitarioPainelList != null) {

      _state.isDataValid = true;
    } else {
      _state.isDataValid = false;
    }
    // if (_state.relatorioPdfMakeModel != null) {
    //   _state.isDataValid = true;
    // } else {
    //   _state.isDataValid = false;
  }

  _mapEventToState(SetorPainelListBlocEvent event) async {
    if (event is UpdateUsuarioIDEvent) {
      //Atualiza estado com usuario logado
      _state.usuarioID = event.usuarioID;
      eventSink(UpdateSetorCensitarioPainelIDEvent());
      eventSink(UpdateRelatorioPdfMakeEvent());
    }

    if (event is UpdateSetorCensitarioPainelIDEvent) {
      _state.setorCensitarioPainelList.clear();

      final streamDocsRemetente = _firestore
          .collection(SetorCensitarioPainelModel.collection)
          .where("setorCensitarioID.id", isEqualTo: _state.usuarioID.setorCensitarioID.id)
          .snapshots();

      final snapListRemetente = streamDocsRemetente.map((snapDocs) =>
          snapDocs.documents.map((doc) => SetorCensitarioPainelModel(id: doc.documentID).fromMap(doc.data)).toList());

      snapListRemetente.listen((List<SetorCensitarioPainelModel> setorCensitarioPainelList) {
        if (setorCensitarioPainelList.length > 1) {
          setorCensitarioPainelList.sort((a, b) => a.painelID.nome.compareTo(b.painelID.nome));
        }
        _state.setorCensitarioPainelList = setorCensitarioPainelList;
        if (!_stateController.isClosed) _stateController.add(_state);
    print(_state.setorCensitarioPainelList.length);

      });
    }

    if (event is UpdateRelatorioPdfMakeEvent) {
      final streamDocRelatorio =
          _firestore.collection(RelatorioPdfMakeModel.collectionFirestore).document(_state.usuarioID.id).snapshots();
      streamDocRelatorio.listen((snapDoc) {
        _state.relatorioPdfMakeModel = RelatorioPdfMakeModel(id: snapDoc.documentID).fromMap(snapDoc.data);
        if (!_stateController.isClosed) _stateController.add(_state);
      });
    }


    if (event is GerarRelatorioPdfMakeEvent) {
      final docRelatorio =
          _firestore.collection(RelatorioPdfMakeModel.collectionFirestore).document(_state.usuarioID.id);
      await docRelatorio.setData({
        'pdfGerar': event.pdfGerar,
        'pdfGerado': event.pdfGerado,
        'tipo': event.tipo,
        'collection': 'Usuario',
        'document': _state.usuarioID.id,
      }, merge: true);
    }


    _validateData();
    if (!_stateController.isClosed) _stateController.add(_state);
    print('event.runtimeType em PainelListBloc  = ${event.runtimeType}');

  }
}
