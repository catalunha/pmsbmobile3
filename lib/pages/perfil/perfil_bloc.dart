import 'dart:async';
import 'package:pmsbmibile3/models/arquivo_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

class ConteudoVariavelUsuarioBloc{
  final fsw.Firestore _firestore;
  BehaviorSubject<String> _arquivoIdController = BehaviorSubject<String>();
  BehaviorSubject<ArquivoModel> _streamArquivo = BehaviorSubject<ArquivoModel>();
  Stream<ArquivoModel> get arquivo => _streamArquivo.stream;
  Function get setArquivoId => _arquivoIdController.sink.add;

  ConteudoVariavelUsuarioBloc(this._firestore){
    _arquivoIdController.listen(getArquivo);
  }
  void getArquivo(String arquivoId){
    ArquivoModel convert(fsw.DocumentSnapshot snap) {
      return ArquivoModel(id: snap.documentID).fromMap({
        ...snap.data,
      });
    }
    var ref = _firestore.collection(ArquivoModel.collection).document(arquivoId);
    ref.snapshots().map(convert).pipe(_streamArquivo);
  }

  void dispose(){
    _streamArquivo.close();
  }
}