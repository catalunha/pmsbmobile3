import 'package:pmsbmibile3/models/variaveis_usuarios_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VariavelUsuarioRepository {
  static final instance = VariavelUsuarioRepository();
  CollectionReference _collectionReference =
      Firestore.instance.collection("variaveis_usuarios");

  Stream<VariavelUsuarioModel> streamGetById(String id) {
    return _collectionReference.document(id).snapshots().map((snap) {
      return VariavelUsuarioModel.fromMap({
        ...snap.data,
        ...{"id": snap.documentID},
      });
    });
  }

  VariavelUsuarioModel create(VariavelUsuarioModel variavel) {
    var doc = _collectionReference.document();
    doc.setData(variavel.toMap());
    variavel.id = doc.documentID;
    return VariavelUsuarioModel.fromMap({});
  }
}
