import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pmsbmibile3/models/arquivo_model.dart';

class ArquivoUsuariosRepository {
  CollectionReference _arquivosUsuariosRef =
      Firestore.instance.collection(ArquivoModel.collection);

  Future<ArquivoModel> getById(String id) async {
    var doc = await _arquivosUsuariosRef.document(id).get();
    var data = doc.data;
    data.addAll({"id": doc.documentID});
    return ArquivoModel().fromMap(doc.data);
  }

  Stream<ArquivoModel> streamCreate(ArquivoModel arquivo) {
    var doc = _arquivosUsuariosRef.document();
    doc.setData(arquivo.toMap());
    return doc.snapshots().map((snap) {
      var data = snap.data;
      data.addAll({"id": snap.documentID});
      ArquivoModel().fromMap(data);
    });
  }

  Future<ArquivoModel> create(ArquivoModel arquivo) async{
    var doc = _arquivosUsuariosRef.document();
    doc.setData(arquivo.toMap());
    var dataSnap = await doc.get();
    var data = dataSnap.data;
    data.addAll({"id": dataSnap.documentID});
    return ArquivoModel().fromMap(data);
  }

}
