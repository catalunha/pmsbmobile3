import 'package:pmsbmibile3/models/relatorio_pdf_make.dart';

import 'package:pmsbmibile3/models/painel_model.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:rxdart/rxdart.dart';

class PainelListBlocEvent {}

class UpdatePainelListEvent extends PainelListBlocEvent {}

class PainelListBlocState {
  bool isDataValid = false;

  List<PainelModel> painelList = List<PainelModel>();
}


class PainelListBloc {
  //Firestore
  final fsw.Firestore _firestore;

  //Eventos
  final _eventController = BehaviorSubject<PainelListBlocEvent>();
  Stream<PainelListBlocEvent> get eventStream =>
      _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final PainelListBlocState _state = PainelListBlocState();
  final _stateController = BehaviorSubject<PainelListBlocState>();

  Stream<PainelListBlocState> get stateStream =>
      _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  //Bloc
  PainelListBloc(this._firestore) {
    eventStream.listen(_mapEventToState);
      eventSink(UpdatePainelListEvent());
  }

  void dispose() async {
    await _stateController.drain();
    _stateController.close();
    await _eventController.drain();
    _eventController.close();
  }

  _validateData() {
    _state.isDataValid=false;
        if (_state.painelList != null) {
      _state.isDataValid = true;
    } else {
      _state.isDataValid = false;
    }

  }

  _mapEventToState(PainelListBlocEvent event) async {


    if (event is UpdatePainelListEvent) {
      _state.painelList.clear();

      final streamDocsRemetente = _firestore
          .collection(PainelModel.collection)
          .snapshots();

      final snapListRemetente = streamDocsRemetente.map((snapDocs) =>
          snapDocs.documents.map((doc) => PainelModel(id: doc.documentID).fromMap(doc.data)).toList());

      snapListRemetente.listen((List<PainelModel> painelList) {
        if (painelList.length > 1) {
          painelList.sort((a, b) => a.nome.compareTo(b.nome));
        }
        _state.painelList = painelList;
        if (!_stateController.isClosed) _stateController.add(_state);
    print(_state.painelList.length);
      });
    }

    _validateData();
    if (!_stateController.isClosed) _stateController.add(_state);
    print('event.runtimeType em PainelListBloc  = ${event.runtimeType}');

  }
}
