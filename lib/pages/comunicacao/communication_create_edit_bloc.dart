import 'package:flutter/material.dart' show TimeOfDay;
import 'package:pmsbmibile3/api/auth_api_mobile.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pmsbmibile3/models/noticia_model.dart';

import 'package:pmsbmibile3/state/auth_bloc.dart';

class CommunicationCreateEditEvent {}

class UpdateUserIdEvent extends CommunicationCreateEditEvent {
  final String userId;

  UpdateUserIdEvent(this.userId);
}

class UpdateNoticiaIdEvent extends CommunicationCreateEditEvent {
  final String noticiaId;

  UpdateNoticiaIdEvent(this.noticiaId);
}

class UpdateNoticiaTituloEvent extends CommunicationCreateEditEvent {
  final String titulo;

  UpdateNoticiaTituloEvent(this.titulo);
}

class UpdateNoticiaDataPublicacaoEvent extends CommunicationCreateEditEvent {
  final dynamic dataPublicacao;

  UpdateNoticiaDataPublicacaoEvent(this.dataPublicacao);
}

class UpdateNoticiaConteudoEvent extends CommunicationCreateEditEvent {
  final String conteudoMarkdown;

  UpdateNoticiaConteudoEvent(this.conteudoMarkdown);
}

class SaveEvent extends CommunicationCreateEditEvent {}

class CommunicationCreateEditState {
  NoticiaModel currentModel;
  String userId;
  String noticiaId;
  String titulo;
  Timestamp dataPublicacao;
  String conteudoMarkdown;
  List<String> destinatarios;

  void updatefromModel(NoticiaModel m){
    currentModel = m;
    noticiaId = m.id;
    userId = m.userId;
    dataPublicacao = Timestamp.fromDate(m.dataPublicacao);
    titulo = m.titulo;
    conteudoMarkdown = m.conteudoMarkdown;
  }

  NoticiaModel toModel() {
    return NoticiaModel(
      userId: userId,
      titulo: titulo,
      conteudoMarkdown: conteudoMarkdown,
      dataPublicacao: dataPublicacao?.toDate(),
    );
  }
}

class CommunicationCreateEditBloc {
  final _authBloc = AuthBloc(AuthApiMobile(), Bootstrap.instance.firestore);
  final currentState = CommunicationCreateEditState();

  final _inputController = BehaviorSubject<CommunicationCreateEditEvent>();
  final _initialStateController = BehaviorSubject<CommunicationCreateEditState>();
  Stream<CommunicationCreateEditState> get initialState => _initialStateController.stream;

  Function get dispatch => _inputController.sink.add;

  CommunicationCreateEditBloc() {
    _authBloc.userId.listen(_dispatchUpdateUserId);
    _inputController.stream.listen(_mapEventToState);
  }

  void dispose() {
    _authBloc.dispose();
    _inputController.close();
    _initialStateController.close();
  }

  void _dispatchUpdateUserId(String userId) {
    dispatch(UpdateUserIdEvent(userId));
  }

  _mapEventToState(CommunicationCreateEditEvent event) {
    if (event is UpdateUserIdEvent) {
      currentState.userId = event.userId;
    }
    if (event is UpdateNoticiaIdEvent) {
      _mapUpdateNoticiaIdEvent(event);
    }
    if (event is UpdateNoticiaTituloEvent) {
      currentState.titulo = event.titulo;
    }
    if (event is UpdateNoticiaConteudoEvent) {
      currentState.conteudoMarkdown = event.conteudoMarkdown;
    }
    if (event is UpdateNoticiaDataPublicacaoEvent) {
      if (event.dataPublicacao is DateTime) {
        currentState.dataPublicacao = Timestamp.fromMillisecondsSinceEpoch(
            event.dataPublicacao.millisecondsSinceEpoch);
      } else if (event.dataPublicacao is Timestamp) {
        currentState.dataPublicacao = event.dataPublicacao;
      } else if (event.dataPublicacao is TimeOfDay) {
        if (currentState.dataPublicacao != null) {
          final date = currentState.dataPublicacao.toDate();
          final newDate = DateTime(date.year, date.month, date.day,
              event.dataPublicacao.hour, event.dataPublicacao.minute);
          currentState.dataPublicacao = Timestamp.fromMillisecondsSinceEpoch(
              newDate.millisecondsSinceEpoch);
        }
      } else {
        currentState.dataPublicacao = null;
      }
    }
    if (event is SaveEvent) {
      _save();
    }
    return currentState;
  }

  _save() {
    final map = currentState.toModel().toMap();
    final docRef = Firestore.instance
        .collection(NoticiaModel.collection)
        .document(currentState.noticiaId);
    docRef.setData(map, merge: true);
  }

  void _mapUpdateNoticiaIdEvent(UpdateNoticiaIdEvent event) {
    if (event.noticiaId == currentState.noticiaId) return;
    var ref = Firestore.instance
        .collection(NoticiaModel.collection)
        .document(event.noticiaId);
    ref.snapshots().listen((DocumentSnapshot snap) {
      var noticia = NoticiaModel(id: snap.documentID).fromMap(snap.data);
      currentState.updatefromModel(noticia);
      _initialStateController.sink.add(currentState);
    });
  }
}
