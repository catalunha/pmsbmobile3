import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;

class AdministracaoHomePageBloc {
  final fw.Firestore _firestore;
  final _usuariosController = BehaviorSubject<List<UsuarioModel>>();

  Stream<List<UsuarioModel>> get usuarios => _usuariosController.stream;

  AdministracaoHomePageBloc(this._firestore) {
    final ref = _firestore.collection(UsuarioModel.collection);
    ref.snapshots().map(_snapshotToPerfilList).pipe(_usuariosController);
  }

  List<UsuarioModel> _snapshotToPerfilList(fw.QuerySnapshot listaPerfil) {
    return listaPerfil.documents
        .map((snap) => UsuarioModel(id: snap.documentID).fromMap(snap.data))
        .toList();
  }

  void dispose() {
    _usuariosController.close();
  }
}
