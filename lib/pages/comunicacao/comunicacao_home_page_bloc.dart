import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pmsbmibile3/api/auth_api_mobile.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pmsbmibile3/models/noticia_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:pmsbmibile3/state/auth_bloc.dart';

class ComunicacaoHomePageEvent {}

class ComunicacaoHomePageBloc {
  final fsw.Firestore _firestore;
  // Auth
  final _authBloc = AuthBloc(AuthApiMobile(), Bootstrap.instance.firestore);

  // NoticiaModel Em Edicao
  final _noticiaModelListController = BehaviorSubject<List<NoticiaModel>>();
  Stream<List<NoticiaModel>> get noticiaModelListStream =>
      _noticiaModelListController.stream;

  // NoticiaModel Publicadas
  final _noticiaModelListPublicadasController = BehaviorSubject<List<NoticiaModel>>();
  Stream<List<NoticiaModel>> get noticiaModelListpublicadasStream =>
      _noticiaModelListPublicadasController.stream;


  ComunicacaoHomePageBloc(this._firestore) {
    _authBloc.userId.listen(_getNoticiasDoUsuario);
  }

  void _getNoticiasDoUsuario(String userId) {
    final noticiasRef = _firestore
        .collection(NoticiaModel.collection)
        .where('distribuida', isEqualTo: false)
        .where('usuarioIDEditor.id', isEqualTo: userId);

    noticiasRef
        .snapshots()
        .map((querySnap) => querySnap.documents
            .map((docSnap) =>
                NoticiaModel(id: docSnap.documentID).fromMap(docSnap.data))
            .toList())
        .pipe(_noticiaModelListController);

    _firestore
        .collection(NoticiaModel.collection)
        .where('distribuida', isEqualTo: true)
        .where('usuarioIDEditor.id', isEqualTo: userId)
        .snapshots()
        .map((querySnap) => querySnap.documents
            .map((docSnap) =>
                NoticiaModel(id: docSnap.documentID).fromMap(docSnap.data))
            .toList())
        .pipe(_noticiaModelListPublicadasController);


  }

  void dispose() {
    _noticiaModelListController.close();
    _authBloc.dispose();
    _noticiaModelListPublicadasController.close();
  }
}
