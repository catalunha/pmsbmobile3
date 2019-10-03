import 'package:firestore_wrapper_web/firestore_wrapper_web.dart'
    if (dart.library.io) 'package:firestore_wrapper_flutter/firestore_wrapper_flutter.dart';

import 'package:firebaseauth_wrapper_web/firebaseauth_wrapper_web.dart'
    if (dart.library.io) 'package:firebaseauth_wrapper_flutter/firebaseauth_wrapper_flutter.dart';
import 'package:pmsbmibile3/state/auth_bloc.dart';

class Bootstrap {
  static final Bootstrap instance =
      Bootstrap._(Firestore(), FieldValue(), FirebaseAuth());
  final Firestore firestore;
  final FirebaseAuth auth;
  final FieldValue fieldValue;
  final AuthBloc authBloc;

  Bootstrap._(this.firestore, this.fieldValue, this.auth)
      : authBloc = AuthBloc(auth, firestore);
}
