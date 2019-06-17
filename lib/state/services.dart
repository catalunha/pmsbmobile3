import 'dart:async';
import 'dart:io';
import 'package:meta/meta.dart';
import 'package:mime/mime.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pmsbmibile3/state/models/usuarios.dart';
import 'package:pmsbmibile3/state/models/noticias.dart';
import 'package:pmsbmibile3/state/models/noticias_usuarios.dart';
import 'package:pmsbmibile3/state/models/administrador_variaveis.dart';

import 'models/variaveis_usuarios.dart';

class DatabaseService {
  final Firestore _firestore = Firestore.instance;

  Future<Usuario> getUsuario(String id) async {
    var snap = await _firestore.collection("usuarios").document(id).get();
    return Usuario.fromFirestore(snap);
  }

  Stream<Usuario> streamUsuario(String id) {
    return _firestore
        .collection("usuarios")
        .document(id)
        .snapshots()
        .map((snap) => Usuario.fromFirestore(snap));
  }

  Stream<List<NoticiaUsuario>> streamNoticiasUsuarios({
    @required String userId,
    @required bool visualizada,
  }) {
    return _firestore
        .collection("noticias_usuarios")
        .where("userId", isEqualTo: userId)
        .where("visualizada", isEqualTo: visualizada)
        .snapshots()
        .map((snap) => snap.documents
            .map((doc) => NoticiaUsuario.fromFirestore(doc))
            .toList());
  }

  Stream<Noticia> streamNoticiaByDocumentReference(DocumentReference ref) {
    return ref.snapshots().map((doc) => Noticia.fromFirestore(doc));
  }

  Stream<List<Future<Noticia>>> streamNoticias(
      {@required String userId, bool visualizada = false}) {
    return _firestore
        .collection("noticias_usuarios")
        .where("userId", isEqualTo: userId)
        .where("visualizada", isEqualTo: visualizada)
        .snapshots()
        .map((snap) => snap.documents
            .map((docSnap) async =>
                Noticia.fromFirestore(await docSnap['noticia'].get()))
            .toList());
  }

  Future<void> marcarNoticiaUsuarioVisualizada(String noticiaUsuarioId) {
    _firestore
        .collection("noticias_usuarios")
        .document(noticiaUsuarioId)
        .setData({
      "visualizada": true,
    }, merge: true);
    return Future.delayed(Duration.zero);
  }

  Stream<List<AdministradorVariavel>> streamAdministradorVariaveis() {
    return _firestore
        .collection("administrador_variaveis")
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((variavel) => AdministradorVariavel(
                  id: variavel.documentID,
                  nome: variavel['nome'],
                  tipo: variavel['tipo'],
                ))
            .toList());
  }

  Stream<VarivelUsuario> streamVarivelUsuarioByNomeAndUserId(
      {@required String userId, @required String nome}) {
    return _firestore
        .collection("variaveis_usuarios")
        .where("nome", isEqualTo: nome)
        .where("userId", isEqualTo: userId)
        .limit(1)
        .snapshots()
        .map((snap) {
      if (snap.documents.length > 0) {
        return VarivelUsuario(
          id: snap.documents[0].documentID,
          tipo: snap.documents[0]['tipo'],
          nome: snap.documents[0]['nome'],
          userId: snap.documents[0]['userId'],
          conteudo: snap.documents[0]['conteudo'],
        );
      } else {
        return null;
      }
    });
  }

  Stream<AdministradorVariavel> streamAdministradorVariavelById(
      String administradorVariavelId) {
    return _firestore
        .collection("administrador_variaveis")
        .document(administradorVariavelId)
        .snapshots()
        .map((snap) => AdministradorVariavel(
            id: snap.documentID,
            nome: snap.data['nome'],
            tipo: snap.data['tipo']));
  }

  Future<void> updateVariavelUsuario({
    String userId,
    String nome,
    String tipo,
    String conteudo,
  }) async {
    var query = await _firestore
        .collection("variaveis_usuarios")
        .where("userId", isEqualTo: userId)
        .where("nome", isEqualTo: nome)
        .where("tipo", isEqualTo: tipo)
        .getDocuments();
    if (query.documents.length > 0) {
      _firestore
          .collection("variaveis_usuarios")
          .document(query.documents.single.documentID)
          .setData({
        "conteudo": conteudo,
      }, merge: true);
    } else {
      _firestore.collection("variaveis_usuarios").document().setData(
          {"userId": userId, "tipo": tipo, "conteudo": conteudo, "nome": nome});
    }
  }

  Future<bool> uploadFile(File file, String filename, String userId, String titulo) async{
    final fileContentType = lookupMimeType(filename, headerBytes: file.readAsBytesSync());
    final StorageReference _storage = FirebaseStorage.instance.ref().child(filename);
    final StorageUploadTask _uploadTask = _storage.putFile(
      file,
      StorageMetadata(
        contentType: fileContentType,
      ),
    );
    final snapshot = await _uploadTask.onComplete;
    final filepath = await snapshot.ref.getPath();
    final url = await snapshot.ref.getDownloadURL();

    if(_uploadTask.isCanceled){
      return false;
    }
    _firestore.collection("arquivos_usuarios").document().setData({
      "userId":userId,
      "mimetype":fileContentType,
      "storage_path":filepath,
      "titulo": titulo,
      "url":url,
    });
    return true;
  }

}
