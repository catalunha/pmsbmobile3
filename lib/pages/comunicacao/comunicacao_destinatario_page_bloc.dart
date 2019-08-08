import 'package:pmsbmibile3/models/models.dart';
import 'package:rxdart/rxdart.dart';
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
  List<Cargo> cargoList = List<Cargo>();
  Map<String, Cargo> cargoMap;
  List<Eixo> eixoList = List<Eixo>();
  List<Usuario> usuarioList = List<Usuario>();
}

class Cargo {
  String id;
  String nome;
  bool checked = false;
  Cargo({this.id, this.nome});
}

class Eixo {
  String id;
  String nome;
  bool checked = false;
  Eixo({this.id, this.nome});
}

class Usuario {
  String id;
  String nome;
  String cargo;
  String eixo;
  String cargoNome;
  String eixoNome;
  bool checked = false;
  int valor = 0;
  Usuario({this.id, this.nome, this.cargo, this.eixo,this.cargoNome,this.eixoNome});
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
    // print('ComunicacaoDestinatarioPageBloc instanciada ....');
    comunicacaoDestinatarioPageEventStream.listen(_mapEventToState);

    _firestore.collection(CargoModel.collection).snapshots().listen(
        (querySnapshot) => querySnapshot.documents.forEach((documentSnapshot) {
              comunicacaoDestinatarioPageState.cargoList.add(Cargo(
                  id: documentSnapshot.documentID,
                  nome: documentSnapshot.data['nome']));
              // return comunicacaoDestinatarioPageEventSink(
              //     UpDateCargoIDEvent(documentSnapshot.documentID));
            }));
    _firestore.collection(EixoModel.collection).snapshots().listen(
        (querySnapshot) => querySnapshot.documents.forEach((documentSnapshot) {
              comunicacaoDestinatarioPageState.eixoList.add(Eixo(
                  id: documentSnapshot.documentID,
                  nome: documentSnapshot.data['nome']));
              // return comunicacaoDestinatarioPageEventSink(
              //     UpDateCargoIDEvent(documentSnapshot.documentID));
            }));
    _firestore.collection(UsuarioModel.collection).snapshots().listen(
        (querySnapshot) => querySnapshot.documents.forEach((documentSnapshot) {
              Map<dynamic, dynamic> cargoMap = Map();
              Map<dynamic, dynamic> eixoMap = Map();

              cargoMap = documentSnapshot.data['cargoID'] == null
                  ? {"id": "null", "nome": "null"}
                  : documentSnapshot.data['cargoID'];
              eixoMap = documentSnapshot.data['eixoID'] == null
                  ? {"id": "null", "nome": "null"}
                  : documentSnapshot.data['eixoID'];

              comunicacaoDestinatarioPageState.usuarioList.add(Usuario(
                  id: documentSnapshot.documentID,
                  nome: documentSnapshot.data['nome'],
                  cargo: cargoMap['id'],
                  eixo: eixoMap['id'],
                  cargoNome: cargoMap['nome'],
                  eixoNome: eixoMap['nome']
                  ));
            }));
    _comunicacaoDestinatarioPageStateController.sink
        .add(comunicacaoDestinatarioPageState);
  }
  void dispose() {
    _comunicacaoDestinatarioPageEventController.close();
    _comunicacaoDestinatarioPageStateController.close();
    _cargoModelListController.close();
  }

  _mapEventToState(ComunicacaoDestinatarioPageEvent event) {
    if (event is UpDateCargoIDEvent) {
      // print('evento de cargo: ${event.cargoID}');
      _updateCargoModeltoState(event.cargoID);
    }
    if (event is UpDateEixoIDEvent) {
      // print('evento de eixo: ${event.eixoID}');
      _updateEixoModeltoState(event.eixoID);
    }
    if (event is UpDateUsuarioIDEvent) {
      // print('evento de usuario: ${event.usuarioID}');
      _updateUsuarioModeltoState(event.usuarioID);
    }
    _comunicacaoDestinatarioPageStateController.sink
        .add(comunicacaoDestinatarioPageState);
  }

  _updateCargoModeltoState(String id) {
    // print('processando cargo: ${id}');

    bool marcou = false;
    for (var item in comunicacaoDestinatarioPageState.cargoList) {
      if (item.id == id) {
        item.checked = !item.checked;
        marcou = item.checked;
      }
    }
    for (var item in comunicacaoDestinatarioPageState.usuarioList) {
      if (item.cargo == id) {
        item.valor = marcou ? ++item.valor : --item.valor;
        item.checked = item.valor > 0 ? true : false;
        item.valor = item.valor < 0 ? 0 : item.valor;
      }
    }
  }

  _updateEixoModeltoState(String id) {
    // print('processando eixo: ${id}');
    bool marcou = false;
    for (var item in comunicacaoDestinatarioPageState.eixoList) {
      if (item.id == id) {
        item.checked = !item.checked;
        marcou = item.checked;
      }
    }
    for (var item in comunicacaoDestinatarioPageState.usuarioList) {
      if (item.eixo == id) {
        item.valor = marcou ? ++item.valor : --item.valor;
        item.checked = item.valor > 0 ? true : false;
        item.valor = item.valor < 0 ? 0 : item.valor;
      }
    }
  }

  _updateUsuarioModeltoState(String id) {
    // print('processando eixo: ${id}');
    for (var item in comunicacaoDestinatarioPageState.usuarioList) {
      if (item.id == id) {
        item.checked = !item.checked;
        item.valor = 0;
      }
    }
    for (var cargo in comunicacaoDestinatarioPageState.cargoList) {
      bool marcouCargo = false;
      for (var usuario in comunicacaoDestinatarioPageState.usuarioList) {
        if (cargo.id == usuario.cargo) {
          marcouCargo = usuario.checked ? true : marcouCargo;
        }
      }
      cargo.checked = marcouCargo ? cargo.checked : false;
    }
    for (var eixo in comunicacaoDestinatarioPageState.eixoList) {
      bool marcouEixo = false;
      for (var usuario in comunicacaoDestinatarioPageState.usuarioList) {
        if (eixo.id == usuario.eixo) {
          marcouEixo = usuario.checked ? true : marcouEixo;
        }
      }
      eixo.checked = marcouEixo ? eixo.checked : false;
    }
  }

  List<Map<String, dynamic>> destinatarioList() {
    List<Map<String, dynamic>> destinatarioList=[];
    for (var usuario in comunicacaoDestinatarioPageState.usuarioList) {
      if (usuario.checked) {
        destinatarioList
            .add({'usuarioID': '${usuario.id}', 'nome':'${usuario.nome}'},);
      }
    }
    return destinatarioList;
  }
}
