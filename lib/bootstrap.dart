import 'package:firestore_wrapper/firestore_wrapper.dart' as fsw;
import 'package:firestore_wrapper_flutter/firestore_wrapper_flutter.dart'
    as fswfm;

import 'package:firebaseauth_wrapper/firebaseauth_wrapper.dart' as faw;
import 'package:firebaseauth_wrapper_flutter/firebaseauth_wrapper_flutter.dart'
    as fawfm;
import 'package:pmsbmibile3/state/auth_bloc.dart';

class Bootstrap {
  static final Bootstrap instance =
      Bootstrap._(fswfm.Firestore(), fswfm.FieldValue(), fawfm.FirebaseAuth());
  final fsw.Firestore firestore;
  final faw.FirebaseAuth auth;
  final fsw.FieldValue FieldValue;
  final AuthBloc authBloc;

  Bootstrap._(this.firestore, this.FieldValue, this.auth)
      : authBloc = AuthBloc(auth, firestore);
}
