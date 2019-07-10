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

  final _inputController = BehaviorSubject<AdministracaoPerfilPageEvent>();
  Stream<AdministracaoPerfilPageEvent> get input => _inputController.stream;
  Function get dispatch => _inputController.sink.add;

  final _perfilController = BehaviorSubject<UsuarioModel>();
  Stream<UsuarioModel> get perfil => _perfilController.stream;

  final _variaveisController = BehaviorSubject<List<VariavelUsuarioModel>>();
  Stream<List<VariavelUsuarioModel>> get variaveis =>
      _variaveisController.stream;

  AdministracaoPerfilPageBloc(this._firestore) {
    input.listen(_mapEventToState);
  }

  void dispose() {
    _perfilController.close();
    _inputController.close();
    _variaveisController.close();
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
        _perfilController.sink.add(usuario);
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
        _variaveisController.sink.add(variaveis);
      });
    }
  }
}
