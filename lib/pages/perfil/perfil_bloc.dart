import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:pmsbmibile3/models/arquivos_usuarios_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConteudoVariavelUsuarioBloc{
  BehaviorSubject<DocumentReference> _arquivo = BehaviorSubject<DocumentReference>();
  BehaviorSubject<ArquivoUsuarioModel> _streamArquivo = BehaviorSubject<ArquivoUsuarioModel>();
  Stream<ArquivoUsuarioModel> get arquivo => _streamArquivo.stream;
  Function get setArquivoReference => _arquivo.sink.add;

  ConteudoVariavelUsuarioBloc(){
    _arquivo.listen(getArquivo);
  }
  void getArquivo(DocumentReference ref){
    ArquivoUsuarioModel convert(DocumentSnapshot snap) {
      return ArquivoUsuarioModel.fromMap({
        "id":snap.documentID,
        ...snap.data,
      });
    }
    ref.snapshots().map(convert).pipe(_streamArquivo);
  }
}