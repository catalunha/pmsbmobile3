import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;
import 'package:rxdart/rxdart.dart';
import 'package:queries/collections.dart';

class PerguntaEscolhaListPageEvent {}

class UpdatePerguntaIDEvent extends PerguntaEscolhaListPageEvent {
  final String perguntaID;

  UpdatePerguntaIDEvent(this.perguntaID);
}

class OrdenarEscolhaEvent extends PerguntaEscolhaListPageEvent {
  final String escolhaUid;
  final bool up;

  OrdenarEscolhaEvent(this.escolhaUid, this.up);
}

class PerguntaEscolhaListPageState {
  bool isDataValid;
  String perguntaID;
  Map<String, Escolha> escolhaMap = Map<String, Escolha>();
}

class PerguntaEscolhaListPageBloc {
  //Firestore
  final fw.Firestore _firestore;

  //Eventos
  final _eventController = BehaviorSubject<PerguntaEscolhaListPageEvent>();
  Stream<PerguntaEscolhaListPageEvent> get eventStream =>
      _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  //Estados
  final PerguntaEscolhaListPageState _state = PerguntaEscolhaListPageState();
  final _stateController = BehaviorSubject<PerguntaEscolhaListPageState>();
  Stream<PerguntaEscolhaListPageState> get stateStream =>
      _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  //ProdutoModel List
  final _escolhaMapController = BehaviorSubject<Map<String, Escolha>>();
  Stream<Map<String, Escolha>> get escolhaMapStream =>
      _escolhaMapController.stream;
  Function get escolhaMapSink => _escolhaMapController.sink.add;

  //Bloc
  PerguntaEscolhaListPageBloc(this._firestore) {
    eventStream.listen(_mapEventToState);
  }
  void dispose() {
    _stateController.close();
    _eventController.close();
    _escolhaMapController.close();
  }
  
  _validateData() {
    bool isValid = true;
    if (_state.escolhaMap != null) {
      _state.isDataValid = true;
    } else {
      _state.isDataValid = false;
    }
  }

  _mapEventToState(PerguntaEscolhaListPageEvent event) async {
    if (event is UpdatePerguntaIDEvent) {
      _state.perguntaID = event.perguntaID;
      final docRef = _firestore
          .collection(PerguntaModel.collection)
          .document(event.perguntaID);
      docRef.snapshots().listen((snap) {
        final perguntaModel =
            PerguntaModel(id: snap.documentID).fromMap(snap.data);
        if (perguntaModel.escolhas != null) {
          // Fonte: https://stackoverflow.com/questions/50875873/sort-maps-in-dart-by-key-or-by-value
          var dicEscolhas = Dictionary.fromMap(perguntaModel.escolhas);
          var escolhasAscOrder = dicEscolhas
              // Sort Ascending order by value ordem
              .orderBy((kv) => kv.value.ordem)
              // Sort Descending order by value ordem
              // .orderByDescending((kv) => kv.value.ordem)
              .toDictionary$1((kv) => kv.key, (kv) => kv.value);
          print(escolhasAscOrder.toMap());
          _state.escolhaMap = escolhasAscOrder.toMap();
          // _state.escolhaMap = perguntaModel.escolhas;
          stateSink(_state);
          // stateSink();
        }
      });
    }
    if (event is OrdenarEscolhaEvent) {
      // print('>>>>>>>>>>>>TTT>>> ${event.ordem} <<<<<<<<<<<<<<<<');
      List<Escolha> valuesList = _state.escolhaMap.values.toList();
      List<String> keyList = _state.escolhaMap.keys.toList();
      final ordemOrigem = keyList.indexOf(event.escolhaUid);
      final ordemOutro = event.up ? ordemOrigem - 1 : ordemOrigem + 1;
      Escolha escolhaOrigem = valuesList[ordemOrigem];
      Escolha escolhaOutra = valuesList[ordemOutro];
      String keyOrigem = keyList[ordemOrigem];
      String keyOutra = keyList[ordemOutro];

      final docRef = _firestore
          .collection(PerguntaModel.collection)
          .document(_state.perguntaID);

      docRef.setData({
        "escolhas": {
          "${keyOrigem}": {"ordem": escolhaOutra.ordem}
        }
      }, merge: true);

      docRef.setData({
        "escolhas": {
          "${keyOutra}": {"ordem": escolhaOrigem.ordem}
        }
      }, merge: true);
    }

    _validateData();
    if (!_stateController.isClosed) stateSink(_state);
    print('ccc PerguntaEscolhaListPageBloc ${event.runtimeType}');
    print('>>> _state.escolhaMap <<< ${_state.escolhaMap}');
  }


}
