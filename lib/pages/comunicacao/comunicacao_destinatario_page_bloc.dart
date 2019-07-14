import 'package:pmsbmibile3/api/auth_api_mobile.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pmsbmibile3/models/noticia_model.dart';

import 'package:pmsbmibile3/state/auth_bloc.dart';

class ComunicacaoDestinatarioPageEvent {}

class UpDateCargoIDEvent extends ComunicacaoDestinatarioPageEvent {
  final String cargoID;

  UpDateCargoIDEvent(this.cargoID);
}

class UpDateEixoIDEvent extends ComunicacaoDestinatarioPageEvent {
  final String eixoID;

  UpDateEixoIDEvent(this.eixoID);
}

class UpDateUsuarioIDEvent extends ComunicacaoDestinatarioPageEvent {
  final String usuarioID;

  UpDateUsuarioIDEvent(this.usuarioID);
}

class ComunicacaoDestinatarioPageState {
  List<Cargo> cargoList;
  List<Eixo> eixoList;
  List<Usuario> usuarioList;
  List<String> destinatarioList;
}

class Cargo {
  String id;
  String nome;
  Cargo({this.id, this.nome});
}

class Eixo {
  String id;
  String nome;
  Eixo({this.id, this.nome});
}

class Usuario {
  String id;
  String nome;
  Cargo cargo;
  Eixo eixo;
  Usuario({this.id, this.nome, this.cargo, this.eixo});
}

class ComunicacaoDestinatarioPageBloc {
  // Eventos da página
  final _comunicacaoDestinatarioPageEventController =
      BehaviorSubject<ComunicacaoDestinatarioPageEvent>();
  Stream<ComunicacaoDestinatarioPageEvent>
      get comunicacaoDestinatarioPageEventStream =>
          _comunicacaoDestinatarioPageEventController.stream;
  Function get comunicacaoDestinatarioPageEventSink =>
      _comunicacaoDestinatarioPageEventController.sink.add;

  // Estados da página
  final comunicacaoDestinatarioPageState = ComunicacaoDestinatarioPageState();
  final _comunicacaoDestinatarioPageStateController =
      BehaviorSubject<ComunicacaoDestinatarioPageState>();
  Stream<ComunicacaoDestinatarioPageState>
      get comunicacaoDestinatarioPageStateStream =>
          _comunicacaoDestinatarioPageStateController.stream;

  ComunicacaoDestinatarioPageBloc() {
    comunicacaoDestinatarioPageEventStream.listen(_mapEventToState);
  }
  void dispose() {
    _comunicacaoDestinatarioPageEventController.close();
    _comunicacaoDestinatarioPageStateController.close();
  }

  _mapEventToState(ComunicacaoDestinatarioPageEvent event) {
    if (event is UpDateCargoIDEvent) {
      print('evento de cargo ${event.cargoID}');
    }
    if (event is UpDateEixoIDEvent) {
      print('evento de eixo ${event.eixoID}');
    }
    if (event is UpDateUsuarioIDEvent) {
      print('evento de usuario ${event.usuarioID}');
    }
  }
}
