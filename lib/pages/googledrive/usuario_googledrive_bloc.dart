import 'package:pmsbmibile3/bootstrap.dart';
import 'package:pmsbmibile3/models/google_drive_model.dart';
import 'package:pmsbmibile3/models/models.dart';
import 'package:pmsbmibile3/models/propriedade_for_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;

class UsuarioGoogleDriveEvent {}

class UpdateCargoListEvent extends UsuarioGoogleDriveEvent {}

class UpdateEixoListEvent extends UsuarioGoogleDriveEvent {}

class UpdateUsuarioListEvent extends UsuarioGoogleDriveEvent {}

class ChangePermissaoEvent extends UsuarioGoogleDriveEvent {
  final String permissao;
  final String usuarioID;

  ChangePermissaoEvent(this.permissao, this.usuarioID);
}

class SaveProdutoIDEvent extends UsuarioGoogleDriveEvent {}

class UpdateGoogleDriveEvent extends UsuarioGoogleDriveEvent {
  final String googleDriveID;

  UpdateGoogleDriveEvent(this.googleDriveID);
}

class SelectCargoIDEvent extends UsuarioGoogleDriveEvent {
  final String cargoID;

  SelectCargoIDEvent(this.cargoID);
}

class SelectEixoIDEvent extends UsuarioGoogleDriveEvent {
  final String eixoID;

  SelectEixoIDEvent(this.eixoID);
}

class SelectUsuarioIDEvent extends UsuarioGoogleDriveEvent {
  final String usuarioID;

  SelectUsuarioIDEvent(this.usuarioID);
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
  // String permissao;
  UsuarioGoogleDrive usuarioGoogleDrive;
  Cargo cargo;
  Eixo eixo;
  bool checked = false;
  int valor = 0;
  Usuario({this.id, this.nome, this.email, this.cargo, this.eixo});
}

class UsuarioGoogleDriveState {
  List<Cargo> cargoList = List<Cargo>();
  List<Eixo> eixoList = List<Eixo>();
  List<Usuario> usuarioList = List<Usuario>();
  GoogleDriveModel googleDriveModel = GoogleDriveModel();
}

class UsuarioGoogleDriveBloc {
  final fsw.Firestore _firestore;

  // Eventos da página todas as perguntas para
  final _eventController = BehaviorSubject<UsuarioGoogleDriveEvent>();
  Stream<UsuarioGoogleDriveEvent> get eventStream => _eventController.stream;
  Function get eventSink => _eventController.sink.add;

  // Estados da página
  UsuarioGoogleDriveState _state = UsuarioGoogleDriveState();
  final _stateController = BehaviorSubject<UsuarioGoogleDriveState>();
  Stream<UsuarioGoogleDriveState> get stateStream => _stateController.stream;
  Function get stateSink => _stateController.sink.add;

  //Cargo
  final _cargoModelListController = BehaviorSubject<List<CargoModel>>();
  Stream<List<CargoModel>> get cargoModelListStream =>
      _cargoModelListController.stream;

  UsuarioGoogleDriveBloc(this._firestore) {
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

  _mapEventToState(UsuarioGoogleDriveEvent event) async {
    if (event is UpdateGoogleDriveEvent) {
      final docRef = _firestore
          .collection(GoogleDriveModel.collection)
          .document(event.googleDriveID);

      final snap = await docRef.get();
      if (snap.exists) {
        _state.googleDriveModel =
            GoogleDriveModel(id: snap.documentID).fromMap(snap.data);
      }
      for (var item in _state.googleDriveModel.usuario.entries) {
        eventSink(SelectUsuarioIDEvent(item.value.usuarioID));
        for (var usuarioList in _state.usuarioList) {
          if (item.value.usuarioID == usuarioList.id) {
            int index = _state.usuarioList.indexOf(usuarioList);
            _state.usuarioList[index].usuarioGoogleDrive = item.value;
            // _state.usuarioList[index].permissao = item.value.permissao;
          }
        }
      }
    }
    if (event is UpdateCargoListEvent) {
      print('UsuarioGoogleDriveBloc> 028474');

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
    if (event is ChangePermissaoEvent) {
      print('ChangePermissaoEvent: ${event.permissao}');
      print('ChangePermissaoEvent: ${event.usuarioID}');
      for (var usuarioList in _state.usuarioList) {
        if (event.usuarioID == usuarioList.id) {
//           int index = _state.usuarioList.indexOf(usuarioList);
//           if (_state.usuarioList[index].usuarioGoogleDrive == null) {
// _state.usuarioList[index].usuarioGoogleDrive[] = UsuarioGoogleDrive(
//             atualizar: false,
//             permissao: 'escrever',
//             usuarioID: item.id,
//           );
//           }
//             _state.usuarioList[index].usuarioGoogleDrive.permissao =
//                 event.permissao;

          if (usuarioList.usuarioGoogleDrive == null) {
            usuarioList.usuarioGoogleDrive = UsuarioGoogleDrive(
              atualizar: false,
              permissao: 'ler',
              usuarioID: usuarioList.id,
            );
          }
          usuarioList.usuarioGoogleDrive.permissao = event.permissao;
        }
      }
    }
    if (event is SelectCargoIDEvent) {
      // print('evento de cargo: ${event.cargoID}');
      _updateCargoModeltoState(event.cargoID);
    }
    if (event is SelectEixoIDEvent) {
      // print('evento de eixo: ${event.eixoID}');
      _updateEixoModeltoState(event.eixoID);
    }
    if (event is SelectUsuarioIDEvent) {
      // print('evento de usuario: ${event.usuarioID}');
      _updateUsuarioModeltoState(event.usuarioID);
    }

    if (event is SaveProdutoIDEvent) {
      Map<String, dynamic> usuarioGoogleDrive =
          Map<String, dynamic>();

      for (var usuario in _state.usuarioList) {
        if (usuario.checked) {
          usuarioGoogleDrive[usuario.email] = usuario.usuarioGoogleDrive.toMap();
        }
      }
      // var googleDriveModel = GoogleDriveModel(
      //   usuario: usuarioGoogleDrive,
      // );
      final docRefGoogleDrive = _firestore
          .collection(GoogleDriveModel.collection)
          .document(_state.googleDriveModel.id);
      await docRefGoogleDrive.setData({'usuario':usuarioGoogleDrive},merge: true);
    }

    if (!_stateController.isClosed) stateSink(_state);
    print(
        'event.runtimeType em QuestionarioHomePageBloc  = ${event.runtimeType}');
  }

  _updateCargoModeltoState(String id) {
    // print('processando cargo: ${id}');

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
    // print('processando eixo: ${id}');
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
    // print('processando eixo: ${id}');
    for (var item in _state.usuarioList) {
      if (item.id == id) {
        item.checked = !item.checked;
        item.valor = 0;
        if (!item.checked) {
          item.usuarioGoogleDrive?.permissao = null;
        }
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
}
