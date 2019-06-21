import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:meta/meta.dart';
import 'package:mime/mime.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pmsbmibile3/models/models.dart';
class DatabaseService {
  final Firestore _firestore = Firestore.instance;

  Future<UsuarioModel> getUsuario(String id) async {
    var snap = await _firestore.collection("usuarios").document(id).get();
    return UsuarioModel.fromFirestore(snap);
  }

  Stream<UsuarioModel> streamUsuario(String id) {
    return _firestore
        .collection("usuarios")
        .document(id)
        .snapshots()
        .map((snap) => UsuarioModel.fromFirestore(snap));
  }

  Stream<List<NoticiaUsuarioModel>> streamNoticiasUsuarios({
    @required String userId,
    @required bool visualizada,
  }) {
    return _firestore
        .collection("noticias_usuarios")
        .where("userId", isEqualTo: userId)
        .where("visualizada", isEqualTo: visualizada)
        .snapshots()
        .map((snap) => snap.documents
            .map((doc) => NoticiaUsuarioModel.fromFirestore(doc))
            .toList());
  }

  Stream<NoticiaModel> streamNoticiaByDocumentReference(DocumentReference ref) {
    return ref.snapshots().map((doc) => NoticiaModel.fromFirestore(doc));
  }

  Stream<List<Future<NoticiaModel>>> streamNoticias(
      {@required String userId, bool visualizada = false}) {
    return _firestore
        .collection("noticias_usuarios")
        .where("userId", isEqualTo: userId)
        .where("visualizada", isEqualTo: visualizada)
        .snapshots()
        .map((snap) => snap.documents
            .map((docSnap) async =>
                NoticiaModel.fromFirestore(await docSnap['noticia'].get()))
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

  Stream<List<AdministradorVariavelModel>> streamAdministradorVariaveis() {
    return _firestore
        .collection("administrador_variaveis")
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((variavel) => AdministradorVariavelModel(
                  id: variavel.documentID,
                  nome: variavel['nome'],
                  tipo: variavel['tipo'],
                ))
            .toList());
  }

  Stream<VariavelUsuarioModel> streamVarivelUsuarioByNomeAndUserId(
      {@required String userId, @required String nome}) {
    return _firestore
        .collection("variaveis_usuarios")
        .where("nome", isEqualTo: nome)
        .where("userId", isEqualTo: userId)
        .limit(1)
        .snapshots()
        .map((snap) {
      if (snap.documents.length > 0) {
        return VariavelUsuarioModel(
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

  Stream<AdministradorVariavelModel> streamAdministradorVariavelById(
      String administradorVariavelId) {
    return _firestore
        .collection("administrador_variaveis")
        .document(administradorVariavelId)
        .snapshots()
        .map((snap) => AdministradorVariavelModel(
            id: snap.documentID,
            nome: snap.data['nome'],
            tipo: snap.data['tipo']));
  }

  Future<void> updateVariavelUsuario({
    String userId,
    String nome,
    String tipo,
    dynamic conteudo,
  }) async {
    if (tipo == "arquivo") {
      File file = File(conteudo);
      var arquivoUsuario = await uploadFile(
        file,
        Random().nextInt(99999).toString(),
        userId,
        nome,
      );
      conteudo = arquivoUsuario.ref;
    }
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

  Future<ArquivoUsuarioModel> uploadFile(
    File file,
    String filename,
    String userId,
    String titulo,
  ) async {
    final fileContentType =
        lookupMimeType(filename, headerBytes: file.readAsBytesSync());
    final StorageReference _storage =
        FirebaseStorage.instance.ref().child(filename);
    final StorageUploadTask _uploadTask = _storage.putFile(
      file,
      StorageMetadata(
        contentType: fileContentType,
      ),
    );
    final snapshot = await _uploadTask.onComplete;
    final filepath = await snapshot.ref.getPath();
    final url = await snapshot.ref.getDownloadURL();

    if (_uploadTask.isCanceled) {
      return null;
    }
    var doc = _firestore.collection("arquivos_usuarios").document();
    var arquivo = ArquivoUsuarioModel(
      contentType: fileContentType,
      titulo: titulo,
      userId: userId,
      storagePath: filepath,
      url: url,
    );
    doc.setData(arquivo.toMap());
    arquivo.ref = doc;
    arquivo.id = doc.documentID;
    return arquivo;
  }
}
