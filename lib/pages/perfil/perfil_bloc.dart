import 'dart:async';
import 'package:pmsbmibile3/models/arquivo_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConteudoVariavelUsuarioBloc{
  BehaviorSubject<String> _arquivoIdController = BehaviorSubject<String>();
  BehaviorSubject<ArquivoModel> _streamArquivo = BehaviorSubject<ArquivoModel>();
  Stream<ArquivoModel> get arquivo => _streamArquivo.stream;
  Function get setArquivoId => _arquivoIdController.sink.add;

  ConteudoVariavelUsuarioBloc(){
    _arquivoIdController.listen(getArquivo);
  }
  void getArquivo(String arquivoId){
    ArquivoModel convert(DocumentSnapshot snap) {
      return ArquivoModel(id: snap.documentID).fromMap({
        ...snap.data,
      });
    }
    var ref = Firestore.instance.collection(ArquivoModel.collection).document(arquivoId);
    ref.snapshots().map(convert).pipe(_streamArquivo);
  }

  void dispose(){
    _streamArquivo.close();
  }
}