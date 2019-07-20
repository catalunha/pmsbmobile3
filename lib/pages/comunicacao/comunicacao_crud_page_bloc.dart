import 'package:flutter/material.dart' show TimeOfDay;
import 'package:pmsbmibile3/api/auth_api_mobile.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pmsbmibile3/models/noticia_model.dart';

import 'package:pmsbmibile3/state/auth_bloc.dart';

class ComunicacaoCRUDPageEvent {}

class UpDateUsuarioIDEditorEvent extends ComunicacaoCRUDPageEvent {
  final String usuarioIDEditorId;

  UpDateUsuarioIDEditorEvent(this.usuarioIDEditorId);
}

class UpdateNoticiaIDEvent extends ComunicacaoCRUDPageEvent {
  final String noticiaID;

  UpdateNoticiaIDEvent(this.noticiaID);
}

class DeleteNoticiaIDEvent extends ComunicacaoCRUDPageEvent {
  DeleteNoticiaIDEvent();
}

class UpdateTituloEvent extends ComunicacaoCRUDPageEvent {
  final String titulo;

  UpdateTituloEvent(this.titulo);
}

class UpdateDestinatarioListEvent extends ComunicacaoCRUDPageEvent {
  List<Map<dynamic, dynamic>> destinatarioList = List<Map<dynamic, dynamic>>();

  UpdateDestinatarioListEvent(this.destinatarioList);
}

class UpdatePublicarEvent extends ComunicacaoCRUDPageEvent {
  final DateTime data;
  final TimeOfDay hora;

  UpdatePublicarEvent({this.data, this.hora});
}

class UpdateTextoMarkdownEvent extends ComunicacaoCRUDPageEvent {
  final String textoMarkdown;

  UpdateTextoMarkdownEvent(this.textoMarkdown);
}

class SaveStateToFirebaseEvent extends ComunicacaoCRUDPageEvent {}

class ComunicacaoCRUDPageState {
  NoticiaModel currentNoticiaModel;

  String noticiaID;

  UsuarioIDEditor usuarioIDEditor;
  String titulo;
  String textoMarkdown;
  DateTime publicar = DateTime.now();
  DateTime data;
  TimeOfDay hora;
  List<Map<String, dynamic>> destinatarioListMap =
      List<Map<String, dynamic>>();
/*
[
  {
    usuarioID:usuarioID
    nome:usuarioID->nome
  },
]
*/
  void fromNoticiaModel(NoticiaModel noticiaModel) {
    currentNoticiaModel = noticiaModel;
    noticiaID = noticiaModel.id;
    usuarioIDEditor = noticiaModel.usuarioIDEditor;
    titulo = noticiaModel.titulo;
    textoMarkdown = noticiaModel.textoMarkdown;
    publicar = noticiaModel.publicar;
    // print('>>> noticiaModel.id >>> ${noticiaModel.id}');
    // print(
    //     '>>> noticiaModel.usuarioIDDestino >>> ${noticiaModel.usuarioIDDestino}');
    // destinatarioListMap =
    //     noticiaModel.usuarioIDDestino.map((v) => v.toMap()).toList();
    noticiaModel.usuarioIDDestino.forEach((k, v) {
// print('>> k >> ${k}');
// print('>> v >> ${v}');
      destinatarioListMap.add(
        {'usuarioID': '${k}', 'nome': '${v.nome}'},
      );
    });
  }

  NoticiaModel toNoticiaModel() {
    // List<Destinatario> usuarioIDDestino = [];
    Map<String, Destinatario> usuarioIDDestino = Map<String, Destinatario>();
    // print('>>>>>> ${destinatarioListMap}');
    // destinatarioListMap.map((item) => destinatarioList.add(item['usuarioID']));

    destinatarioListMap.forEach((item) {
      // print(item['usuarioID']);
      // print(item['nome']);
      usuarioIDDestino[item['usuarioID']] = Destinatario(
          uid: item['usuarioID'],
          id: true,
          nome: item['nome'],
          visualizada: false);
      // print('>> usuarioIDDestino >> ${usuarioIDDestino.toString()}');
    });
    // print('>>>>>> ${destinatarioList}');
    return NoticiaModel(
      usuarioIDEditor: usuarioIDEditor,
      titulo: titulo,
      distribuida: false,
      textoMarkdown: textoMarkdown,
      usuarioIDDestino: usuarioIDDestino,
      publicar: publicar ?? null,
    );
  }
}

class ComunicacaoCRUDPageBloc {
  final _authBloc = AuthBloc(AuthApiMobile(), Bootstrap.instance.firestore);

  //Eventos da página
  final _comunicacaoCRUDPageEventController =
      BehaviorSubject<ComunicacaoCRUDPageEvent>();
  Stream<ComunicacaoCRUDPageEvent> get comunicacaoCRUDPageEventStream =>
      _comunicacaoCRUDPageEventController.stream;
  Function get comunicacaoCRUDPageEventSink =>
      _comunicacaoCRUDPageEventController.sink.add;

  //Estados da página
  final comunicacaoCRUDPageState = ComunicacaoCRUDPageState();
  final _comunicacaoCRUDPageStateController =
      BehaviorSubject<ComunicacaoCRUDPageState>();
  Stream<ComunicacaoCRUDPageState> get comunicacaoCRUDPageStateStream =>
      _comunicacaoCRUDPageStateController.stream;

  ComunicacaoCRUDPageBloc() {
    // _authBloc.userId.listen(_dispatchUpdateUserId);
    _authBloc.userId.listen((userId) =>
        comunicacaoCRUDPageEventSink(UpDateUsuarioIDEditorEvent(userId)));
    comunicacaoCRUDPageEventStream.listen(_mapEventToState);
  }

  void dispose() {
    _authBloc.dispose();
    _comunicacaoCRUDPageEventController.close();
    _comunicacaoCRUDPageStateController.close();
  }

  // void _dispatchUpdateUserId(String userId) {
  //   comunicacaoCRUDPageEventSink(UpDateUsuarioIDEditorEvent(userId));
  // }

  _mapEventToState(ComunicacaoCRUDPageEvent event) {
    if (event is UpDateUsuarioIDEditorEvent) {
      Firestore.instance
          .collection(UsuarioModel.collection)
          .document(event.usuarioIDEditorId)
          .snapshots()
          .listen((documentSnapshot) {
        UsuarioIDEditor usuarioIDEditor = UsuarioIDEditor(
            id: documentSnapshot.documentID,
            nome: documentSnapshot.data['nome']);
        comunicacaoCRUDPageState.usuarioIDEditor = usuarioIDEditor;
        _comunicacaoCRUDPageStateController.sink.add(comunicacaoCRUDPageState);
      });
    }
    if (event is UpdateNoticiaIDEvent) {
      _mapUpdateNoticiaIdEvent(event);
    }
    if (event is DeleteNoticiaIDEvent) {
      _deleteNoticiaIdEvent();
    }
    if (event is UpdateTituloEvent) {
      comunicacaoCRUDPageState.titulo = event.titulo;
    }
    if (event is UpdateDestinatarioListEvent) {
      comunicacaoCRUDPageState.destinatarioListMap = event.destinatarioList;
    }
    if (event is UpdateTextoMarkdownEvent) {
      comunicacaoCRUDPageState.textoMarkdown = event.textoMarkdown;
    }
    if (event is UpdatePublicarEvent) {
      if (event.data != null) {
        comunicacaoCRUDPageState.data = event.data;
      }
      if (event.hora != null) {
        comunicacaoCRUDPageState.hora = event.hora;
      }

      // print('No event.data: ${event.data.toString()}');
      // print('No event.hora: ${event.hora.toString()}');
      // print(
      // 'No comunicacaoCRUDPageState data: ${comunicacaoCRUDPageState.data.toString()}');
      // print(
      // 'No comunicacaoCRUDPageState.hora: ${comunicacaoCRUDPageState.hora.toString()}');
      // print(
      // 'No comunicacaoCRUDPageState.publicar: ${comunicacaoCRUDPageState.publicar.toString()}');
      final newDate = DateTime(
          comunicacaoCRUDPageState.data != null
              ? comunicacaoCRUDPageState.data.year
              : comunicacaoCRUDPageState.publicar.year,
          comunicacaoCRUDPageState.data != null
              ? comunicacaoCRUDPageState.data.month
              : comunicacaoCRUDPageState.publicar.month,
          comunicacaoCRUDPageState.data != null
              ? comunicacaoCRUDPageState.data.day
              : comunicacaoCRUDPageState.publicar.day,
          comunicacaoCRUDPageState.hora != null
              ? comunicacaoCRUDPageState.hora.hour
              : comunicacaoCRUDPageState.publicar.hour,
          comunicacaoCRUDPageState.hora != null
              ? comunicacaoCRUDPageState.hora.minute
              : comunicacaoCRUDPageState.publicar.minute);
      comunicacaoCRUDPageState.publicar = newDate;
      // print(
      // 'Após comunicacaoCRUDPageState.publicar: ${comunicacaoCRUDPageState.publicar.toString()}'); // }
      _comunicacaoCRUDPageStateController.sink.add(comunicacaoCRUDPageState);
    }
    if (event is SaveStateToFirebaseEvent) {
      _saveStateToFirebase();
    }
    return comunicacaoCRUDPageState;
  }

  _saveStateToFirebase() {
    final map = comunicacaoCRUDPageState.toNoticiaModel().toMap();
    // // print(map);
    final docRef = Firestore.instance
        .collection(NoticiaModel.collection)
        .document(comunicacaoCRUDPageState.noticiaID);
    // docRef.setData(map, merge: true); // se deixar merge ele amplia a lista e nao exclui.
    docRef.setData(map);
  }

  _deleteNoticiaIdEvent() {
    Firestore.instance
        .collection(NoticiaModel.collection)
        .document(comunicacaoCRUDPageState.noticiaID)
        .delete();
  }

  void _mapUpdateNoticiaIdEvent(UpdateNoticiaIDEvent event) {
    if (event.noticiaID == comunicacaoCRUDPageState.noticiaID) return;
    var ref = Firestore.instance
        .collection(NoticiaModel.collection)
        .document(event.noticiaID);
    ref.snapshots().listen((DocumentSnapshot snap) {
      var noticia = NoticiaModel(id: snap.documentID).fromMap(snap.data);
      comunicacaoCRUDPageState.fromNoticiaModel(noticia);
      _comunicacaoCRUDPageStateController.sink.add(comunicacaoCRUDPageState);
    });
  }
}
