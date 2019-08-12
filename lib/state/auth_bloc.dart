import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pmsbmibile3/models/usuario_model.dart';
import 'package:pmsbmibile3/services/notificacao_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:firebaseauth_wrapper/firebaseauth_wrapper.dart' as fba;
enum AuthStatus {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
}

class AuthBlocEvent {}

class UpdateEmailAuthBlocEvent extends AuthBlocEvent {
  final String email;

  UpdateEmailAuthBlocEvent(this.email);
}

class UpdatePasswordAuthBlocEvent extends AuthBlocEvent {
  final String password;

  UpdatePasswordAuthBlocEvent(this.password);
}

class LoginAuthBlocEvent extends AuthBlocEvent {}
class LogoutAuthBlocEvent extends AuthBlocEvent {}

class AuthBlocState {
  String usuarioID;
  String email;
  String passord;
}

class AuthBloc {
  // Database
  final fsw.Firestore _firestore;

  //API
  final fba.FirebaseAuth _authApi;

  //AuthStatus
  final _statusController = BehaviorSubject<AuthStatus>.seeded(AuthStatus.Uninitialized);
  Stream<AuthStatus> get status => _statusController.stream;

  //State
  final _state = AuthBlocState();
  
  //TODO: Creio q esta stream foi abandonada no codigo.
  //UserId
  final _userId = BehaviorSubject<String>();
  Stream<String> get userId => _userId.stream;

  //Usuario Model
  final _perfilController = BehaviorSubject<UsuarioModel>();
  StreamSubscription<UsuarioModel> _perfilSubscription;
  Stream<UsuarioModel> get perfil => _perfilController.stream;

  //Event
  final _inputController = BehaviorSubject<AuthBlocEvent>();
  Function get dispatch => _inputController.sink.add;

  
  // NOTIFICACAO
  final FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

  //Construtor AuthBloc
  AuthBloc(this._authApi, this._firestore) : assert(_authApi != null) {
    _statusController.sink.add(AuthStatus.Unauthenticated);
    var stream = _authApi.onUserIdChange.where((userId) => userId != null);
    stream.listen(_getPerfilUsuarioFromFirebaseUser);
    stream.listen(_getUserId);
    stream.listen(_setpushTokenfromUsuario);

    _authApi.onUserIdChange.listen(_updateStatus);
    _inputController.stream.listen(_handleInputEvent);
    //metodo que registra o servico da notificacao.
    NotificacaoService.registerNotification();
  }

  //Destrutor AuthBloc
  void dispose() {
    _perfilController.close();
    _userId.close();
    _perfilSubscription.cancel();
    _statusController.close();
    _inputController.close();
  }


  void _setpushTokenfromUsuario(String userId) {
    // Ao logar atualiza o token do usuario.
    firebaseMessaging.getToken().then((token) {
      print('Novo token >> $token');
      Firestore.instance
          .collection(UsuarioModel.collection)
          .document(userId)
          .updateData({'pushToken': token});
    }).catchError((err) {
      print(err.message.toString());
    });
  }

  void _getPerfilUsuarioFromFirebaseUser(String userId) {
    _state.usuarioID=userId;

    final perfilRef =
        _firestore.collection(UsuarioModel.collection).document(userId);

    final perfilStream = perfilRef.snapshots().map((perfilSnap) =>
        UsuarioModel(id: perfilSnap.documentID)
            .fromMap(perfilSnap.data));
    if (_perfilSubscription != null) {
      _perfilSubscription.cancel().then((_) {
        _perfilSubscription = perfilStream.listen(_pipPerfil);
      });
    } else {
      _perfilSubscription = perfilStream.listen(_pipPerfil);
    }
  }

  void _getUserId(String userId) {
    _userId.sink.add(userId);
  }

  void _pipPerfil(UsuarioModel perfil) {
    _perfilController.sink.add(perfil);
  }

  void _updateStatus(String userId) {
    if (userId == null) {
      _statusController.sink.add(AuthStatus.Unauthenticated);
    }
    else{
      _statusController.sink.add(AuthStatus.Authenticated);
    }
  }

  void _handleInputEvent(AuthBlocEvent event) {
    if(event is UpdateEmailAuthBlocEvent){
      _state.email = event.email;
    }
    else if(event is UpdatePasswordAuthBlocEvent){
      _state.passord = event.password;
    }
    else if(event is LoginAuthBlocEvent){
      _handleLoginAuthBlocEvent();
    }
    else if(event is LogoutAuthBlocEvent){
      _authApi.logout();
      
    }
  }

  void _handleLoginAuthBlocEvent(){
    _statusController.sink.add(AuthStatus.Authenticating);
    _authApi.loginWithEmailAndPassword(_state.email, _state.passord);
  }

}
