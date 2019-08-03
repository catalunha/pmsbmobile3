import 'package:firebase_auth/firebase_auth.dart';
import 'package:pmsbmibile3/api/auth_api.dart';

class AuthApiMobile extends AuthApi{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<bool> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<String> get onUserIdChange {
    return _auth.onAuthStateChanged.map((firebaseUser){
      return firebaseUser != null? firebaseUser.uid : null;
    });
  }

  @override
  Future logout() {
    _auth.signOut();
    return Future.delayed(Duration.zero);
  }

}