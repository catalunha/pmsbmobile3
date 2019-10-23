import 'package:pmsbmibile3/models/models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

class ComunicacaoDestinatarioPageEvent {}

class UpdateCargoListEvent extends ComunicacaoDestinatarioPageEvent {}

class UpdateEixoListEvent extends ComunicacaoDestinatarioPageEvent {}

class UpdateUsuarioListEvent extends ComunicacaoDestinatarioPageEvent {}

class SelectCargoIDEvent extends ComunicacaoDestinatarioPageEvent {
  final String cargoID;

  SelectCargoIDEvent(this.cargoID);
}

class SelectEixoIDEvent extends ComunicacaoDestinatarioPageEvent {
  final String eixoID;

  SelectEixoIDEvent(this.eixoID);
}

class SelectUsuarioIDEvent extends ComunicacaoDestinatarioPageEvent {
  final String usuarioID;

  SelectUsuarioIDEvent(this.usuarioID);
}

class ComunicacaoDestinatarioPageState {
  List<Cargo> cargoList = List<Cargo>();
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
  String email;
  Cargo cargo;
  Eixo eixo;
  bool checked = false;    
  int valor = 0;
  Usuario({this.id, this.nome, this.email, this.cargo, this.eixo});
}

class ComunicacaoDestinatarioPageBloc {
  final fsw.Firestore _firestore;

  /// Eventos da página todas as perguntas para
  final _eventController = BehaviorSubject<ComunicacaoDestinatarioPageEvent>();
  Stream<ComunicacaoDestinatarioPageEvent> get eventStream =>
      _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  /// Estados da página
  ComunicacaoDestinatarioPageState _state = ComunicacaoDestinatarioPageState();
  final _stateController = BehaviorSubject<ComunicacaoDestinatarioPageState>();
  Stream<ComunicacaoDestinatarioPageState> get stateStream =>
      _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  /// Cargo
  final _cargoModelListController = BehaviorSubject<List<CargoModel>>();
  Stream<List<CargoModel>> get cargoModelListStream =>
      _cargoModelListController.stream;

  ComunicacaoDestinatarioPageBloc(this._firestore) {
    eventStream.listen(_mapEventToState);
    eventSink(UpdateCargoListEvent());
    eventSink(UpdateEixoListEvent());
    eventSink(UpdateUsuarioListEvent());
  }
  void dispose() async {
    await _eventController.drain();
    _eventController.close();
    await _stateController.drain();
    _stateController.close();
    await _cargoModelListController.drain();
    _cargoModelListController.close();
  }

  _mapEventToState(ComunicacaoDestinatarioPageEvent event) async {
    if (event is UpdateCargoListEvent) {

      final streamDocs =
          _firestore.collection(CargoModel.collection).snapshots();

      final snapList = streamDocs.map((snapDocs) => snapDocs.documents
          .map((doc) => Cargo(id: doc.documentID, nome: doc.data['nome']))
          .toList());

      snapList.listen((List<Cargo> cargoList) {
        cargoList.sort((a, b) => a.nome.compareTo(b.nome));
        _state.cargoList = cargoList;
      });
    }
    if (event is UpdateEixoListEvent) {
      _firestore
          .collection(EixoModel.collection)
          .snapshots()
          .listen((querySnapshot) {
        for (var documentSnapshot in querySnapshot.documents) {
          _state.eixoList.add(Eixo(
              id: documentSnapshot.documentID,
              nome: documentSnapshot.data['nome']));
        }
        _state.eixoList.sort((a, b) => a.nome.compareTo(b.nome));
      });
    }

    if (event is UpdateUsuarioListEvent) {
      _firestore
          .collection(UsuarioModel.collection)
          .snapshots()
          .listen((querySnapshot) {
        for (var documentSnapshot in querySnapshot.documents) {
          _state.usuarioList.add(Usuario(
            id: documentSnapshot.documentID,
            nome: documentSnapshot.data['nome'],
            email: documentSnapshot.data['email'],
            cargo: documentSnapshot.data['cargoID'] == null
                ? Cargo(id: null, nome: null)
                : Cargo(
                    id: documentSnapshot.data['cargoID']['id'],
                    nome: documentSnapshot.data['cargoID']['nome']),
            eixo: documentSnapshot.data['eixoID'] == null
                ? Eixo(id: null, nome: null)
                : Eixo(
                    id: documentSnapshot.data['eixoID']['id'],
                    nome: documentSnapshot.data['eixoID']['nome']),
          ));
        }
        _state.usuarioList.sort((a, b) => a.nome.compareTo(b.nome));
      });
    }

    if (event is SelectCargoIDEvent) {
      _updateCargoModeltoState(event.cargoID);
    }
    if (event is SelectEixoIDEvent) {
      _updateEixoModeltoState(event.eixoID);
    }
    if (event is SelectUsuarioIDEvent) {
      _updateUsuarioModeltoState(event.usuarioID);
    }
    if (!_stateController.isClosed) stateSink(_state);
    print(
        'event.runtimeType em QuestionarioHomePageBloc  = ${event.runtimeType}');
  }

  _updateCargoModeltoState(String id) {

    bool marcou = false;
    for (var item in _state.cargoList) {
      if (item.id == id) {
        item.checked = !item.checked;
        marcou = item.checked;
      }
    }
    for (var item in _state.usuarioList) {
      if (item.cargo.id == id) {
        item.valor = marcou ? ++item.valor : --item.valor;
        item.checked = item.valor > 0 ? true : false;
        item.valor = item.valor < 0 ? 0 : item.valor;
      }
    }
  }

  _updateEixoModeltoState(String id) {
    bool marcou = false;
    for (var item in _state.eixoList) {
      if (item.id == id) {
        item.checked = !item.checked;
        marcou = item.checked;
      }
    }
    for (var item in _state.usuarioList) {
      if (item.eixo.id == id) {
        item.valor = marcou ? ++item.valor : --item.valor;
        item.checked = item.valor > 0 ? true : false;
        item.valor = item.valor < 0 ? 0 : item.valor;
      }
    }
  }

  _updateUsuarioModeltoState(String id) {
    for (var item in _state.usuarioList) {
      if (item.id == id) {
        item.checked = !item.checked;
        item.valor = 0;
      }
    }
    for (var cargo in _state.cargoList) {
      bool marcouCargo = false;
      for (var usuario in _state.usuarioList) {
        if (cargo.id == usuario.cargo.id) {
          marcouCargo = usuario.checked ? true : marcouCargo;
        }
      }
      cargo.checked = marcouCargo ? cargo.checked : false;
    }
    for (var eixo in _state.eixoList) {
      bool marcouEixo = false;
      for (var usuario in _state.usuarioList) {
        if (eixo.id == usuario.eixo.id) {
          marcouEixo = usuario.checked ? true : marcouEixo;
        }
      }
      eixo.checked = marcouEixo ? eixo.checked : false;
    }
  }

  List<Map<String, dynamic>> destinatarioList() {
    List<Map<String, dynamic>> destinatarioList = [];
    for (var usuario in _state.usuarioList) {
      if (usuario.checked) {
        destinatarioList.add(
          {'usuarioID': '${usuario.id}', 'nome': '${usuario.nome}'},
        );
      }
    }
    return destinatarioList;
  }
}
