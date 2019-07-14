import 'package:pmsbmibile3/api/auth_api_mobile.dart';
import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pmsbmibile3/models/noticia_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;

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
  Map<String, Cargo> cargoMap;
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
  final fw.Firestore _firestore;

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

  //Cargo
  final _cargoModelListController = BehaviorSubject<List<CargoModel>>();
  Stream<List<CargoModel>> get cargoModelListStream =>
      _cargoModelListController.stream;

  ComunicacaoDestinatarioPageBloc(this._firestore) {
    print('ComunicacaoDestinatarioPageBloc instanciada ....');
    comunicacaoDestinatarioPageEventStream.listen(_mapEventToState);
    comunicacaoDestinatarioPageEventSink(UpDateCargoIDEvent('teste'));
    var a = _firestore
        .collection(UsuarioModel.collection)
        .document("Ln1UIA7iF3bfoh8OnWEBvRrlAwG3")
        .documentID;
    print('elennn: ${a}');

    // Firestore.instance
    _firestore
        .collection(UsuarioModel.collection)
        .where("ativo", isEqualTo: true)
        .snapshots()
        .map((querySnapshot) => querySnapshot.documents
            .map((documentSnapshot) => print(documentSnapshot.documentID)));

    //push cargos from firestores
    // _pushCargoModeltoState();
    _firestore.collection(CargoModel.collection).snapshots().map(
        (querySnapshot) => querySnapshot.documents.map((documentSnapshot) =>
            comunicacaoDestinatarioPageEventSink(
                UpDateCargoIDEvent(documentSnapshot.documentID))));
  }
  void dispose() {
    _comunicacaoDestinatarioPageEventController.close();
    _comunicacaoDestinatarioPageStateController.close();
    _cargoModelListController.close();
  }

  _pushCargoModeltoState() {
    print('_pushCargoModeltoState executando ....');
    _firestore.collection(CargoModel.collection).snapshots().map(
        (querySnapshot) => querySnapshot.documents.map((documentSnapshot) =>
            comunicacaoDestinatarioPageEventSink(
                UpDateCargoIDEvent(documentSnapshot.documentID))));
    print('_pushCargoModeltoState fim ....');
  }

  _mapEventToState(ComunicacaoDestinatarioPageEvent event) {
    print('Mapeou um evento....');

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
