import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;

class AdministracaoHomePageBloc {
  final fw.Firestore _firestore;

  final usuarioModelListController = BehaviorSubject<List<UsuarioModel>>();

  Stream<List<UsuarioModel>> get usuarioModelListStream =>
      usuarioModelListController.stream;

  AdministracaoHomePageBloc(this._firestore) {
    _firestore
        .collection(UsuarioModel.collection)
        .where("ativo", isEqualTo: true)
        .snapshots()
        .map((querySnapshot) => querySnapshot.documents
            .map((docSnap) => UsuarioModel(id: docSnap.documentID).fromMap(docSnap.data))
            .toList())
        .pipe(usuarioModelListController);
  }

  void dispose() async{
    await usuarioModelListController.drain();
    usuarioModelListController.close();
  }
}
