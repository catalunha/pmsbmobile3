import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pmsbmibile3/models/arquivos_usuarios_model.dart';

class ArquivoUsuariosRepository {
  CollectionReference _arquivosUsuariosRef =
      Firestore.instance.collection("arquivos_usuarios");

  Future<ArquivoUsuarioModel> getById(String id) async {
    var doc = await _arquivosUsuariosRef.document(id).get();
    var data = doc.data;
    data.addAll({"id": doc.documentID});
    return ArquivoUsuarioModel.fromMap(doc.data);
  }

  Stream<ArquivoUsuarioModel> streamCreate(ArquivoUsuarioModel arquivo) {
    var doc = _arquivosUsuariosRef.document();
    doc.setData(arquivo.toMap());
    return doc.snapshots().map((snap) {
      var data = snap.data;
      data.addAll({"id": snap.documentID});
      ArquivoUsuarioModel.fromMap(data);
    });
  }

  Future<ArquivoUsuarioModel> create(ArquivoUsuarioModel arquivo) async{
    var doc = _arquivosUsuariosRef.document();
    doc.setData(arquivo.toMap());
    var dataSnap = await doc.get();
    var data = dataSnap.data;
    data.addAll({"id": dataSnap.documentID});
    return ArquivoUsuarioModel.fromMap(data);
  }

}
