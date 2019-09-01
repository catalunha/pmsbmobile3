import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:pmsbmibile3/models/pergunta_model.dart';
import 'package:rxdart/rxdart.dart';

class RequisitoListItemBloc {
  final fsw.Firestore _firebase;
  final Requisito _requisito;
  final _stateController = BehaviorSubject<PerguntaAplicadaModel>();
  Stream<PerguntaAplicadaModel> get state => _stateController.stream;

  RequisitoListItemBloc(this._firebase, this._requisito) {
    final ref = _firebase
        .collection(PerguntaAplicadaModel.collection)
        .document(_requisito.perguntaID);
    ref
        .snapshots()
        .map((snap) =>
            PerguntaAplicadaModel(id: snap.documentID).fromMap(snap.data))
        .pipe(_stateController);
  }

  void dispose() {
    _stateController.drain();
    _stateController.close();
  }
}
