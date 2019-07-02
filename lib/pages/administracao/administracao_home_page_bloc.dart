import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdministracaoHomePageBloc {
  final _usuariosController = BehaviorSubject<List<UsuarioModel>>();

  Stream<List<UsuarioModel>> get usuarios => _usuariosController.stream;

  AdministracaoHomePageBloc() {
    final ref = Firestore.instance.collection(UsuarioModel.collection);
    ref.snapshots().map(_snapshotToPerfilList).pipe(_usuariosController);
  }

  List<UsuarioModel> _snapshotToPerfilList(QuerySnapshot listaPerfil) {
    return listaPerfil.documents
        .map((snap) => UsuarioModel(id: snap.documentID).fromMap(snap.data))
        .toList();
  }

  void dispose() {
    _usuariosController.close();
  }
}
