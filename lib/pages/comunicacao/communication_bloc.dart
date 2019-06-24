import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pmsbmibile3/models/noticias_model.dart';

import 'package:pmsbmibile3/state/auth_bloc.dart';

class CommunicationEvent{

}

class DeleteCommunicationEvent extends CommunicationEvent{
  final String noticiaId;
  DeleteCommunicationEvent(this.noticiaId);
}


class CommunicationBloc {
  final _firestore = Firestore.instance;
  final _authBloc = AuthBloc();
  final _noticiasController = BehaviorSubject<List<NoticiaModel>>();
  final _inputController = BehaviorSubject<CommunicationEvent>();
  Function get dispatch => _inputController.sink.add;

  Stream<List<NoticiaModel>> get noticias => _noticiasController.stream;

  CommunicationBloc() {
    _authBloc.userId.listen(_getNoticiasDoUsuario);
    _inputController.stream.listen(_mapInputToEvent);
  }

  void dispose() {
    _noticiasController.close();
    _authBloc.dispose();
    _inputController.close();
  }

  void _getNoticiasDoUsuario(String userId) {
    final noticiasRef = _firestore
        .collection(NoticiaModel.collection)
        .where("userId", isEqualTo: userId);

    noticiasRef
        .snapshots()
        .map((querySnap) =>
            querySnap.documents.map((docSnap) => NoticiaModel.fromFirestore(docSnap)).toList())
        .pipe(_noticiasController);
  }

  void _mapInputToEvent(CommunicationEvent event) {
    if(event is DeleteCommunicationEvent){
      Firestore.instance.collection(NoticiaModel.collection).document(event.noticiaId).delete();
    }
  }
}
