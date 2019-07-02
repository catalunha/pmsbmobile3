import 'dart:async';
import 'package:pmsbmibile3/models/arquivo_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConteudoVariavelUsuarioBloc{
  BehaviorSubject<DocumentReference> _arquivo = BehaviorSubject<DocumentReference>();
  BehaviorSubject<ArquivoModel> _streamArquivo = BehaviorSubject<ArquivoModel>();
  Stream<ArquivoModel> get arquivo => _streamArquivo.stream;
  Function get setArquivoReference => _arquivo.sink.add;

  ConteudoVariavelUsuarioBloc(){
    _arquivo.listen(getArquivo);
  }
  void getArquivo(DocumentReference ref){
    ArquivoModel convert(DocumentSnapshot snap) {
      return ArquivoModel(id: snap.documentID).fromMap({
        ...snap.data,
      });
    }
    ref.snapshots().map(convert).pipe(_streamArquivo);
  }

  void dispose(){
    _streamArquivo.close();
  }
}