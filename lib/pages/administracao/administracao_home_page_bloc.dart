import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pmsbmibile3/models/perfis_usuarios_model.dart';

class AdministracaoHomePageBloc {
  final _usuariosController = BehaviorSubject<List<PerfilUsuarioModel>>();

  Stream<List<PerfilUsuarioModel>> get usuarios => _usuariosController.stream;

  AdministracaoHomePageBloc() {
    final ref = Firestore.instance.collection(PerfilUsuarioModel.collection);
    ref.snapshots().map(_snapshotToPerfilList).pipe(_usuariosController);
  }

  List<PerfilUsuarioModel> _snapshotToPerfilList(QuerySnapshot listaPerfil) {
    return listaPerfil.documents
        .map((snap) => PerfilUsuarioModel.fromMap({
              "id": snap.documentID,
              ...snap.data,
            }))
        .toList();
  }

  void dispose() {
    _usuariosController.close();
  }
}
