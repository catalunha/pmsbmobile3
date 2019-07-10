import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pmsbmibile3/models/variavel_usuario_model.dart';
import 'package:pmsbmibile3/models/usuario_perfil_model.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fw;

class AdministracaoPerfilPageEvent {}

class UpdateUsuarioIdEvent extends AdministracaoPerfilPageEvent {
  final String usuarioId;

  UpdateUsuarioIdEvent(this.usuarioId);
}

class AdministracaoPerfilPageState {
  String usuarioId;
}

class AdministracaoPerfilPageBloc {
  final fw.Firestore _firestore;

  // Estados da Página
  final AdministracaoPerfilPageState currentState = AdministracaoPerfilPageState();

  // Eventos da Página
  final _administracaoPerfilPageEventController = BehaviorSubject<AdministracaoPerfilPageEvent>();

  Stream<AdministracaoPerfilPageEvent> get administracaoPerfilPageEventStream =>
      _administracaoPerfilPageEventController.stream;

  Function get administracaoPerfilPageEventSink => _administracaoPerfilPageEventController.sink.add;

  // UsuarioModel
  final _usuarioModelController = BehaviorSubject<UsuarioModel>();

  Stream<UsuarioModel> get usuarioModelStream => _usuarioModelController.stream;

  Function get usuarioModelSink => _usuarioModelController.sink.add;

  // UsuarioPerfil
  final _variavelUsuarioModelController = BehaviorSubject<List<UsuarioPerfil>>();

  Stream<List<UsuarioPerfil>> get variavelUsuarioModelStream => _variavelUsuarioModelController.stream;

  Function get variavelUsuarioModelDispatch => _variavelUsuarioModelController.sink.add;

  //Construtor da classe
  AdministracaoPerfilPageBloc(this._firestore) {
    administracaoPerfilPageEventStream.listen(_mapEventToState);
  }

  void dispose() {
    _usuarioModelController.close();
    _administracaoPerfilPageEventController.close();
    _variavelUsuarioModelController.close();
  }

  void _mapEventToState(AdministracaoPerfilPageEvent event) {
    if (event is UpdateUsuarioIdEvent) {
      currentState.usuarioId = event.usuarioId;
      //perfil usuario
      print('>>>>>> iniciando leitura de Usuario');
      print('event.usuarioId: ${event.usuarioId}');
      _firestore
          .collection(UsuarioModel.collection)
          .document(event.usuarioId)
          .snapshots()
          .map((snap) => UsuarioModel(id: snap.documentID).fromMap(snap.data))
          .listen((usuario) {
        usuarioModelSink(usuario);
      });

      print('>>>>>> iniciando leitura de UsuarioPerfil');
//
//      _firestore
//          .collection(UsuarioPerfil.collection)
//          .document('fOnFWqf9S7ZOuPkp5QTgdy3Wv2h2_K3gvgZG2rYdjJdRCpv7K')
//          .get()
//          .then((doc) {
//        if (doc.exists) {
//          print('>>> Doc UsuarioPerfil Existe');
//        } else {
//          print('>>> Doc UsuarioPerfil NAO-Existe');
//        }
//      });
//
//      _firestore
//          .collection(UsuarioPerfil.collection)
//          .where("userId", isEqualTo: event.usuarioId)
//          .snapshots()
//          .map((snapDocs) => snapDocs.documents)
//          .map((doc) {
//        print(doc.toString());
//      });

      //variaveis usuario
//      _firestore
//        .collection(UsuarioPerfil.collection)
//        .document('fOnFWqf9S7ZOuPkp5QTgdy3Wv2h2_K3gvgZG2rYdjJdRCpv7K')
//        .snapshots()
//        .map((snap) => UsuarioPerfil(id: snap.documentID).fromMap(snap.data))
//        .listen((usuarioperfil) {
//        print(usuarioperfil.toString());
//      });

//      final dados = _firestore
//          .collection(UsuarioPerfil.collection);
//      dados.
//        .document('fOnFWqf9S7ZOuPkp5QTgdy3Wv2h2_K3gvgZG2rYdjJdRCpv7K').snapshots().map((doc)=>print(doc.data['conteudo']));
//      print('dados.documentID: ${dados.documentID}');

//          .where("usuario", isEqualTo: event.usuarioId)
//          .snapshots()
//          .map((dados) {
//        return print('>>>>');
//      });
//      print(dados.snapshots().toString());

//          .snapshots()
//          .map((snapDocs) => snapDocs.documents
//              .map((doc) => UsuarioPerfil(id:doc.documentID).fromMap(doc.data))
//              .toList())
//          .listen((List<UsuarioPerfil> variavelUsuarioModelList) {
//        variavelUsuarioModelDispatch(variavelUsuarioModelList);
//      });

      //versao dev alterada para UsuarioPerfil
      //variaveis usuario
      _firestore
        .collection(UsuarioPerfil.collection)
        .where("usuario", isEqualTo: event.usuarioId)
        .snapshots()
        .map((snapDocs) => snapDocs.documents
        .map((doc) => UsuarioPerfil(id: doc.documentID).fromMap(doc.data))
        .toList())
        .listen((List<UsuarioPerfil> variavelUsuarioModelList) {
        variavelUsuarioModelDispatch(variavelUsuarioModelList);
      });

    }
  }
}
