import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:pmsbmibile3/models/variavel_usuario_model.dart';
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


  final AdministracaoPerfilPageState currentState = AdministracaoPerfilPageState();

  final _administracaoPerfilPageEventController = BehaviorSubject<AdministracaoPerfilPageEvent>();
  Stream<AdministracaoPerfilPageEvent> get input => _administracaoPerfilPageEventController.stream;
  Function get dispatch => _administracaoPerfilPageEventController.sink.add;

  final _usuarioModelController = BehaviorSubject<UsuarioModel>();
  Stream<UsuarioModel> get usuarioModelStream => _usuarioModelController.stream;

  final _variavelUsuarioModelController = BehaviorSubject<List<VariavelUsuarioModel>>();
  Stream<List<VariavelUsuarioModel>> get variavelUsuarioModelStream =>
      _variavelUsuarioModelController.stream;

  AdministracaoPerfilPageBloc(this._firestore) {
    input.listen(_mapEventToState);
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
      var userRef = _firestore
          .collection(UsuarioModel.collection)
          .document(event.usuarioId);
      userRef.snapshots().map((snap) {
        return UsuarioModel().fromMap(
            {"id": snap.documentID, ...snap.data});
      }).listen((usuario) {
        _usuarioModelController.sink.add(usuario);
      });

      //variaveis usuario
      var variaveisRef = _firestore
          .collection(VariavelUsuarioModel.collection)
          .where("userId", isEqualTo: event.usuarioId);
      variaveisRef.snapshots().map((snapDocs) {
        return snapDocs.documents
            .map((doc) => VariavelUsuarioModel.fromMap(doc.data))
            .toList();
      }).listen((List<VariavelUsuarioModel> variaveis) {
        _variavelUsuarioModelController.sink.add(variaveis);
      });
    }
  }
}
